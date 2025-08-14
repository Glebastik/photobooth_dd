import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'dart:html' as html show Blob, Url, window;

/// Сервис для печати фотографий
class PrintService {
  static final PrintService _instance = PrintService._internal();
  factory PrintService() => _instance;
  PrintService._internal();

  /// Печать фото через браузер (Web)
  Future<void> printPhotoWeb(Uint8List imageBytes) async {
    if (!kIsWeb) return;
    
    try {
      // Создаем временный URL для изображения
      final blob = html.Blob([imageBytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      
      // Создаем новое окно для печати
      final printWindow = html.window.open(url, '_blank');
      if (printWindow != null) {
        // Ждем загрузки изображения и открываем диалог печати
        printWindow.onLoad.listen((_) {
          printWindow.print();
          printWindow.close();
        });
      }
      
      // Освобождаем URL
      html.Url.revokeObjectUrl(url);
    } catch (e) {
      debugPrint('Error printing photo on web: $e');
      rethrow;
    }
  }

  /// Печать фото через PDF (Desktop/Web)
  Future<void> printPhotoAsPdf(Uint8List imageBytes) async {
    try {
      // Для веб-версии используем простую печать
      if (kIsWeb) {
        await printPhotoWeb(imageBytes);
      } else {
        // Desktop PDF printing would be implemented here
        debugPrint('Desktop PDF printing would be implemented here');
      }
    } catch (e) {
      debugPrint('Error printing photo as PDF: $e');
      rethrow;
    }
  }

  /// Печать фото с настройками (размер, ориентация)
  Future<void> printPhotoWithSettings({
    required Uint8List imageBytes,
    String? fileName,
    bool showPrintDialog = true,
  }) async {
    try {
      // Упрощенная печать для веб-версии
      await printPhotoWeb(imageBytes);
    } catch (e) {
      debugPrint('Error printing photo with settings: $e');
      rethrow;
    }
  }

  /// Получить список доступных принтеров
  Future<List<String>> getAvailablePrinters() async {
    try {
      // Для веб-версии возвращаем заглушку
      return ['Default Printer'];
    } catch (e) {
      debugPrint('Error getting printers: $e');
      return [];
    }
  }

  /// Печать на конкретном принтере
  Future<void> printOnPrinter({
    required Uint8List imageBytes,
    required String printerName,
  }) async {
    try {
      // Упрощенная печать для веб-версии
      await printPhotoWeb(imageBytes);
    } catch (e) {
      debugPrint('Error printing on specific printer: $e');
      rethrow;
    }
  }

  /// Быстрая печать (автоматический выбор принтера)
  Future<void> quickPrint(Uint8List imageBytes) async {
    try {
      if (kIsWeb) {
        await printPhotoWeb(imageBytes);
      } else {
        await printPhotoAsPdf(imageBytes);
      }
    } catch (e) {
      debugPrint('Error in quick print: $e');
      rethrow;
    }
  }
}
