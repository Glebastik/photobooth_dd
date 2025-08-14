import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:html' as html show document;

/// Сервис для управления полноэкранным режимом
class FullscreenService {
  static final FullscreenService _instance = FullscreenService._internal();
  factory FullscreenService() => _instance;
  FullscreenService._internal();

  bool _isFullscreen = false;
  bool _isKioskMode = false;

  /// Включить полноэкранный режим
  Future<void> enterFullscreen() async {
    if (_isFullscreen) return;

    try {
      if (kIsWeb) {
        await _enterFullscreenWeb();
      } else {
        await _enterFullscreenDesktop();
      }
      _isFullscreen = true;
    } catch (e) {
      debugPrint('Error entering fullscreen: $e');
      rethrow;
    }
  }

  /// Выйти из полноэкранного режима
  Future<void> exitFullscreen() async {
    if (!_isFullscreen) return;

    try {
      if (kIsWeb) {
        await _exitFullscreenWeb();
      } else {
        await _exitFullscreenDesktop();
      }
      _isFullscreen = false;
    } catch (e) {
      debugPrint('Error exiting fullscreen: $e');
      rethrow;
    }
  }

  /// Переключить полноэкранный режим
  Future<void> toggleFullscreen() async {
    if (_isFullscreen) {
      await exitFullscreen();
    } else {
      await enterFullscreen();
    }
  }

  /// Включить режим киоска (для фотобудки)
  Future<void> enterKioskMode() async {
    if (_isKioskMode) return;

    try {
      await enterFullscreen();
      
      if (!kIsWeb) {
        // Desktop functionality would be implemented here
        debugPrint('Desktop kiosk mode settings would be applied here');
      }

      // Отключить системные горячие клавиши
      await _disableSystemShortcuts();
      
      _isKioskMode = true;
    } catch (e) {
      debugPrint('Error entering kiosk mode: $e');
      rethrow;
    }
  }

  /// Выйти из режима киоска
  Future<void> exitKioskMode() async {
    if (!_isKioskMode) return;

    try {
      await exitFullscreen();
      
      if (!kIsWeb) {
        debugPrint('Desktop kiosk mode settings would be disabled here');
      }

      // Включить системные горячие клавиши
      await _enableSystemShortcuts();
      
      _isKioskMode = false;
    } catch (e) {
      debugPrint('Error exiting kiosk mode: $e');
      rethrow;
    }
  }

  /// Полноэкранный режим для Web
  Future<void> _enterFullscreenWeb() async {
    final element = html.document.documentElement;
    if (element != null) {
      await element.requestFullscreen();
    }
  }

  /// Выход из полноэкранного режима для Web
  Future<void> _exitFullscreenWeb() async {
    if (html.document.fullscreenElement != null) {
      await html.document.exitFullscreen();
    }
  }

  /// Полноэкранный режим для Desktop
  Future<void> _enterFullscreenDesktop() async {
    // Desktop functionality would be implemented here
    // For now, just log that we're in desktop mode
    debugPrint('Desktop fullscreen mode would be activated here');
  }

  /// Выход из полноэкранного режима для Desktop
  Future<void> _exitFullscreenDesktop() async {
    // Desktop functionality would be implemented here
    debugPrint('Desktop fullscreen mode would be deactivated here');
  }

  /// Отключить системные горячие клавиши
  Future<void> _disableSystemShortcuts() async {
    try {
      // Отключаем основные системные комбинации
      await SystemChannels.platform.invokeMethod('SystemChrome.setEnabledSystemUIMode', {
        'mode': 'immersiveSticky',
      });
    } catch (e) {
      debugPrint('Could not disable system shortcuts: $e');
    }
  }

  /// Включить системные горячие клавиши
  Future<void> _enableSystemShortcuts() async {
    try {
      await SystemChannels.platform.invokeMethod('SystemChrome.setEnabledSystemUIMode', {
        'mode': 'edgeToEdge',
      });
    } catch (e) {
      debugPrint('Could not enable system shortcuts: $e');
    }
  }

  /// Проверить, активен ли полноэкранный режим
  bool get isFullscreen => _isFullscreen;

  /// Проверить, активен ли режим киоска
  bool get isKioskMode => _isKioskMode;

  /// Инициализация для desktop приложения
  Future<void> initializeDesktop() async {
    if (kIsWeb) return;

    try {
      // Desktop window initialization would be implemented here
      debugPrint('Desktop window initialization would happen here');
    } catch (e) {
      debugPrint('Error initializing desktop window: $e');
    }
  }

  /// Настроить окно для фотобудки
  Future<void> setupPhotobooth() async {
    try {
      await initializeDesktop();
      await enterKioskMode();
    } catch (e) {
      debugPrint('Error setting up photobooth: $e');
      rethrow;
    }
  }
}
