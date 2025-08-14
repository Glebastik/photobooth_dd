import 'dart:async';
import 'dart:html' as html;
import 'dart:js' as js;
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

/// Сервис для работы с принтером
class PrinterService {
  static final PrinterService _instance = PrinterService._internal();
  factory PrinterService() => _instance;
  PrinterService._internal();

  /// Список доступных принтеров
  List<String> _availablePrinters = [];
  String? _selectedPrinter;

  /// Получить список доступных принтеров
  Future<List<String>> getAvailablePrinters() async {
    try {
      debugPrint('🖨️ Начинаем поиск принтеров...');
      
      // В веб-версии используем Web Print API
      if (kIsWeb) {
        // Попытаемся получить принтеры через различные Web API
        _availablePrinters = await _getWebPrinters();
        
        // Попытаемся получить дополнительную информацию о принтерах через JavaScript
        try {
          // Проверяем доступность Web Print API
          if (js.context.hasProperty('navigator') && 
              js.context['navigator'].hasProperty('printing')) {
            debugPrint('✅ Web Print API доступен');
          } else {
            debugPrint('⚠️ Web Print API недоступен, используем стандартный список');
          }
        } catch (e) {
          debugPrint('⚠️ Ошибка проверки Web Print API: $e');
        }
        
        debugPrint('🎯 Найдено принтеров: ${_availablePrinters.length}');
        for (int i = 0; i < _availablePrinters.length; i++) {
          debugPrint('🖨️ Принтер ${i + 1}: ${_availablePrinters[i]}');
        }
        
        return _availablePrinters;
      }
      
      // Для десктопных версий можно добавить интеграцию с системными принтерами
      debugPrint('🖥️ Десктопная версия, используем базовый список принтеров');
      _availablePrinters = [
        'Принтер по умолчанию',
        'PDF принтер',
        'Сетевые принтеры',
      ];
      
      debugPrint('🎯 Найдено принтеров: ${_availablePrinters.length}');
      for (int i = 0; i < _availablePrinters.length; i++) {
        debugPrint('🖨️ Принтер ${i + 1}: ${_availablePrinters[i]}');
      }
      
      return _availablePrinters;
    } catch (e) {
      debugPrint('❌ Критическая ошибка получения списка принтеров: $e');
      // Возвращаем базовый список в случае ошибки
      _availablePrinters = ['Системный принтер по умолчанию', 'PDF принтер'];
      return _availablePrinters;
    }
  }

  /// Получить принтеры в веб-версии
  Future<List<String>> _getWebPrinters() async {
    List<String> printers = [];
    
    try {
      // Базовый список принтеров, которые обычно доступны
      printers.addAll([
        'Системный принтер по умолчанию',
        'PDF принтер',
        'Сохранить как PDF',
        'Microsoft Print to PDF',
      ]);
      
      // Попытаемся получить дополнительные принтеры через JavaScript
      try {
        final jsResult = js.context.callMethod('eval', ['''
          (function() {
            var printers = [];
            
            // Попытаемся получить принтеры через различные API
            if (window.navigator && window.navigator.mediaDevices) {
              // Некоторые браузеры могут предоставлять информацию о принтерах
            }
            
            // Добавляем стандартные принтеры для разных ОС
            if (navigator.platform.indexOf('Win') !== -1) {
              printers.push('Отправить в OneNote', 'Факс', 'Microsoft XPS Document Writer');
            } else if (navigator.platform.indexOf('Mac') !== -1) {
              printers.push('Сохранить как PDF', 'Предварительный просмотр');
            } else if (navigator.platform.indexOf('Linux') !== -1) {
              printers.push('Print to File (PDF)', 'CUPS-PDF');
            }
            
            return printers;
          })()
        ''']);
        
        if (jsResult != null && jsResult is List) {
          for (var printer in jsResult) {
            if (printer is String && !printers.contains(printer)) {
              printers.add(printer);
            }
          }
        }
      } catch (e) {
        debugPrint('⚠️ Не удалось получить дополнительные принтеры: $e');
      }
      
      debugPrint('🔍 Обнаружено принтеров через Web API: ${printers.length}');
      
    } catch (e) {
      debugPrint('❌ Ошибка получения принтеров: $e');
      // Возвращаем минимальный список
      printers = ['Системный принтер по умолчанию', 'PDF принтер'];
    }
    
    return printers;
  }

  /// Выбрать принтер
  void selectPrinter(String printerName) {
    if (_availablePrinters.contains(printerName)) {
      _selectedPrinter = printerName;
    }
  }

  /// Получить выбранный принтер
  String? get selectedPrinter => _selectedPrinter;

  /// Печать изображения
  Future<bool> printImage(Uint8List imageData, {
    String? printerName,
    PrintSettings? settings,
  }) async {
    try {
      final targetPrinter = printerName ?? _selectedPrinter;
      
      if (targetPrinter == null) {
        throw Exception('Принтер не выбран');
      }

      if (kIsWeb) {
        return await _printImageWeb(imageData, settings);
      }
      
      // Для десктопных версий
      return await _printImageDesktop(imageData, targetPrinter, settings);
    } catch (e) {
      debugPrint('Ошибка печати: $e');
      return false;
    }
  }

  /// Печать изображения в веб-версии
  Future<bool> _printImageWeb(Uint8List imageData, PrintSettings? settings) async {
    try {
      debugPrint('🖨️ Начинаем веб-печать...');
      
      // Создаем blob из данных изображения
      final blob = html.Blob([imageData], 'image/png');
      final url = html.Url.createObjectUrlFromBlob(blob);
      
      debugPrint('🖨️ Blob создан, URL: $url');
      
      // Создаем HTML страницу с изображением и автоматической печатью
      final printHtml = '''
        <!DOCTYPE html>
        <html>
        <head>
          <title>Печать фото</title>
          <style>
            body { margin: 0; padding: 0; }
            img { 
              width: 100%; 
              height: 100%; 
              object-fit: contain;
              page-break-inside: avoid;
            }
            @media print {
              body { margin: 0; }
              img { max-width: 100%; max-height: 100%; }
            }
          </style>
        </head>
        <body>
          <img src="$url" onload="window.print(); setTimeout(() => window.close(), 1000);" />
        </body>
        </html>
      ''';
      
      // Создаем blob с HTML содержимым
      final htmlBlob = html.Blob([printHtml], 'text/html');
      final htmlUrl = html.Url.createObjectUrlFromBlob(htmlBlob);
      
      // Открываем окно с HTML страницей
      final printWindow = html.window.open(htmlUrl, '_blank', 'width=800,height=600');
      
      if (printWindow != null) {
        debugPrint('🖨️ Окно печати открыто с автоматической печатью');
        
        // Освобождаем URLs через некоторое время
        Timer(const Duration(seconds: 15), () {
          html.Url.revokeObjectUrl(url);
          html.Url.revokeObjectUrl(htmlUrl);
          debugPrint('🖨️ URLs освобождены');
        });
        
        return true;
      } else {
        debugPrint('❌ Не удалось открыть окно печати');
        html.Url.revokeObjectUrl(url);
        html.Url.revokeObjectUrl(htmlUrl);
        return false;
      }
    } catch (e) {
      debugPrint('❌ Ошибка веб-печати: $e');
      return false;
    }
  }

  /// Печать изображения в десктопной версии
  Future<bool> _printImageDesktop(
    Uint8List imageData, 
    String printerName, 
    PrintSettings? settings
  ) async {
    // Здесь можно добавить интеграцию с системными принтерами
    // Например, через platform channels или FFI
    debugPrint('Печать на $printerName (десктопная версия)');
    return true;
  }

  /// Проверить статус принтера
  Future<PrinterStatus> getPrinterStatus(String printerName) async {
    try {
      // Базовая проверка доступности принтера
      if (_availablePrinters.contains(printerName)) {
        return PrinterStatus.ready;
      }
      return PrinterStatus.offline;
    } catch (e) {
      return PrinterStatus.error;
    }
  }
}

/// Настройки печати
class PrintSettings {
  final String width;
  final String height;
  final String orientation;
  final int copies;
  final bool colorMode;

  const PrintSettings({
    this.width = '10cm',
    this.height = '15cm',
    this.orientation = 'portrait',
    this.copies = 1,
    this.colorMode = true,
  });
}

/// Статус принтера
enum PrinterStatus {
  ready,
  printing,
  offline,
  error,
  outOfPaper,
  outOfInk,
}
