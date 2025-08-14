import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

/// Desktop-совместимый сервис для печати
class PrinterService {
  static final PrinterService _instance = PrinterService._internal();
  factory PrinterService() => _instance;
  PrinterService._internal();

  List<PrinterDevice> _availablePrinters = [];
  PrinterDevice? _selectedPrinter;
  bool _isInitialized = false;

  /// Получить список доступных принтеров
  Future<List<PrinterDevice>> getAvailablePrinters() async {
    try {
      // Используем CUPS для получения списка принтеров
      final result = await Process.run('lpstat', ['-p']);
      if (result.exitCode == 0) {
        final lines = result.stdout.toString().split('\n');
        final printers = <PrinterDevice>[];
        
        for (final line in lines) {
          if (line.startsWith('printer ')) {
            final parts = line.split(' ');
            if (parts.length >= 2) {
              final name = parts[1];
              printers.add(PrinterDevice(
                id: name,
                name: name,
                isDefault: false,
              ));
            }
          }
        }
        
        // Получаем принтер по умолчанию
        final defaultResult = await Process.run('lpstat', ['-d']);
        if (defaultResult.exitCode == 0) {
          final defaultLine = defaultResult.stdout.toString();
          final match = RegExp(r'system default destination: (.+)').firstMatch(defaultLine);
          if (match != null) {
            final defaultName = match.group(1)?.trim();
            for (final printer in printers) {
              if (printer.name == defaultName) {
                printer.isDefault = true;
                break;
              }
            }
          }
        }
        
        _availablePrinters = printers;
        return printers;
      }
    } catch (e) {
      debugPrint('Ошибка получения принтеров: $e');
    }
    
    // Fallback - создаем виртуальный принтер
    _availablePrinters = [
      PrinterDevice(
        id: 'virtual_printer',
        name: 'Virtual Printer',
        isDefault: true,
      ),
    ];
    return _availablePrinters;
  }

  /// Инициализировать принтер
  Future<bool> initializePrinter([PrinterDevice? printer]) async {
    try {
      await getAvailablePrinters();
      _selectedPrinter = printer ?? _availablePrinters.firstWhere(
        (p) => p.isDefault,
        orElse: () => _availablePrinters.firstOrNull,
      );
      _isInitialized = true;
      debugPrint('Принтер инициализирован: ${_selectedPrinter?.name}');
      return true;
    } catch (e) {
      debugPrint('Ошибка инициализации принтера: $e');
      return false;
    }
  }

  /// Печать изображения
  Future<bool> printImage(Uint8List imageData, {
    String? printerName,
    String paperSize = 'A4',
    String quality = 'high',
  }) async {
    if (!_isInitialized) {
      await initializePrinter();
    }

    try {
      final printer = printerName ?? _selectedPrinter?.name ?? 'default';
      
      // Создаем временный файл для изображения
      final tempDir = Directory.systemTemp;
      final tempFile = File('${tempDir.path}/photobooth_${DateTime.now().millisecondsSinceEpoch}.png');
      await tempFile.writeAsBytes(imageData);

      // Печатаем через lp команду
      final result = await Process.run('lp', [
        '-d', printer,
        '-o', 'media=$paperSize',
        '-o', 'print-quality=$quality',
        tempFile.path,
      ]);

      // Удаляем временный файл
      await tempFile.delete();

      if (result.exitCode == 0) {
        debugPrint('Изображение отправлено на печать: $printer');
        return true;
      } else {
        debugPrint('Ошибка печати: ${result.stderr}');
        return false;
      }
    } catch (e) {
      debugPrint('Ошибка печати изображения: $e');
      return false;
    }
  }

  /// Печать HTML контента
  Future<bool> printHtml(String htmlContent, {
    String? printerName,
    String paperSize = 'A4',
  }) async {
    if (!_isInitialized) {
      await initializePrinter();
    }

    try {
      final printer = printerName ?? _selectedPrinter?.name ?? 'default';
      
      // Создаем временный HTML файл
      final tempDir = Directory.systemTemp;
      final tempFile = File('${tempDir.path}/photobooth_${DateTime.now().millisecondsSinceEpoch}.html');
      await tempFile.writeAsString(htmlContent);

      // Конвертируем HTML в PDF и печатаем
      // Требует установки wkhtmltopdf: sudo apt install wkhtmltopdf
      final pdfFile = File('${tempDir.path}/photobooth_${DateTime.now().millisecondsSinceEpoch}.pdf');
      
      final convertResult = await Process.run('wkhtmltopdf', [
        '--page-size', paperSize,
        '--orientation', 'Portrait',
        tempFile.path,
        pdfFile.path,
      ]);

      if (convertResult.exitCode == 0) {
        final printResult = await Process.run('lp', [
          '-d', printer,
          '-o', 'media=$paperSize',
          pdfFile.path,
        ]);

        // Удаляем временные файлы
        await tempFile.delete();
        await pdfFile.delete();

        if (printResult.exitCode == 0) {
          debugPrint('HTML отправлен на печать: $printer');
          return true;
        } else {
          debugPrint('Ошибка печати PDF: ${printResult.stderr}');
          return false;
        }
      } else {
        debugPrint('Ошибка конвертации HTML в PDF: ${convertResult.stderr}');
        await tempFile.delete();
        return false;
      }
    } catch (e) {
      debugPrint('Ошибка печати HTML: $e');
      return false;
    }
  }

  /// Проверить статус принтера
  Future<PrinterStatus> getPrinterStatus([String? printerName]) async {
    try {
      final printer = printerName ?? _selectedPrinter?.name ?? 'default';
      final result = await Process.run('lpstat', ['-p', printer]);
      
      if (result.exitCode == 0) {
        final output = result.stdout.toString();
        if (output.contains('idle')) {
          return PrinterStatus.ready;
        } else if (output.contains('printing')) {
          return PrinterStatus.printing;
        } else if (output.contains('stopped')) {
          return PrinterStatus.error;
        }
      }
    } catch (e) {
      debugPrint('Ошибка проверки статуса принтера: $e');
    }
    
    return PrinterStatus.unknown;
  }

  /// Отменить все задания печати
  Future<bool> cancelAllJobs([String? printerName]) async {
    try {
      final printer = printerName ?? _selectedPrinter?.name ?? 'default';
      final result = await Process.run('cancel', ['-a', printer]);
      return result.exitCode == 0;
    } catch (e) {
      debugPrint('Ошибка отмены заданий печати: $e');
      return false;
    }
  }

  // Геттеры
  List<PrinterDevice> get availablePrinters => _availablePrinters;
  PrinterDevice? get selectedPrinter => _selectedPrinter;
  bool get isInitialized => _isInitialized;
  
  /// Проверить доступность печати на платформе
  static bool get isPrintingAvailable {
    return !kIsWeb && Platform.isLinux; // Доступно на Linux
  }
}

/// Модель устройства принтера
class PrinterDevice {
  final String id;
  final String name;
  bool isDefault;

  PrinterDevice({
    required this.id,
    required this.name,
    this.isDefault = false,
  });

  @override
  String toString() => 'PrinterDevice(id: $id, name: $name, default: $isDefault)';
}

/// Статус принтера
enum PrinterStatus {
  ready,
  printing,
  error,
  unknown,
}
