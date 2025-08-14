import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:ui_web' as ui_web;

/// Расширенный сервис для работы с камерой
class CameraService {
  static final CameraService _instance = CameraService._internal();
  factory CameraService() => _instance;
  CameraService._internal();

  html.MediaStream? _currentStream;
  html.VideoElement? _videoElement;
  List<CameraDevice> _availableCameras = [];
  CameraDevice? _selectedCamera;
  
  /// Получить список доступных камер
  Future<List<CameraDevice>> getAvailableCameras() async {
    if (!kIsWeb) {
      // Для десктопных версий можно добавить поддержку через platform channels
      return [CameraDevice('default', 'Камера по умолчанию', CameraType.builtin)];
    }

    try {
      debugPrint('🔍 Начинаем поиск камер...');
      
      // Проверяем поддержку MediaDevices API
      if (html.window.navigator.mediaDevices == null) {
        debugPrint('❌ MediaDevices API не поддерживается');
        return [CameraDevice('default', 'Камера по умолчанию', CameraType.builtin)];
      }

      debugPrint('✅ MediaDevices API поддерживается');

      // Сначала запрашиваем разрешения на камеру
      debugPrint('🔐 Запрашиваем разрешения на камеру...');
      html.MediaStream? permissionStream;
      try {
        permissionStream = await html.window.navigator.mediaDevices!.getUserMedia({
          'video': {'facingMode': 'user'}
        });
        debugPrint('✅ Разрешение на камеру получено');
        
        // Останавливаем поток сразу после получения разрешения
        permissionStream.getTracks().forEach((track) => track.stop());
      } catch (e) {
        debugPrint('❌ Разрешение на камеру отклонено: $e');
        // Все равно пытаемся получить список устройств
      }

      // Получаем список устройств
      debugPrint('📋 Получаем список устройств...');
      final devices = await html.window.navigator.mediaDevices!.enumerateDevices();
      debugPrint('📋 Всего устройств найдено: ${devices.length}');
      
      _availableCameras.clear();
      
      int cameraIndex = 1;
      for (final device in devices) {
        debugPrint('🔍 Устройство: kind=${device.kind}, label="${device.label}", id="${device.deviceId}"');
        
        if (device.kind == 'videoinput') {
          String label = device.label ?? '';
          String deviceId = device.deviceId ?? '';
          
          // Если название пустое, создаем описательное название
          if (label.isEmpty || label == '') {
            label = 'Камера $cameraIndex';
            cameraIndex++;
          }
          
          // Если deviceId пустой, создаем default ID
          if (deviceId.isEmpty) {
            deviceId = 'camera_$cameraIndex';
          }
          
          final cameraType = _determineCameraType(label);
          _availableCameras.add(CameraDevice(
            deviceId,
            label,
            cameraType,
          ));
          
          debugPrint('✅ Добавлена камера: $label ($deviceId) - $cameraType');
        }
      }
      
      // Если камер не найдено, добавляем камеру по умолчанию
      if (_availableCameras.isEmpty) {
        debugPrint('⚠️ Камеры не найдены, добавляем камеру по умолчанию');
        _availableCameras.add(CameraDevice('default', 'Камера по умолчанию', CameraType.builtin));
      }
      
      debugPrint('🎯 Итого найдено камер: ${_availableCameras.length}');
      for (final camera in _availableCameras) {
        debugPrint('📷 ${camera.label} (${camera.deviceId}) - ${camera.type}');
      }
      
      return _availableCameras;
    } catch (e) {
      debugPrint('❌ Критическая ошибка получения списка камер: $e');
      // Возвращаем камеру по умолчанию в случае ошибки
      final defaultCamera = CameraDevice('default', 'Камера по умолчанию', CameraType.builtin);
      _availableCameras = [defaultCamera];
      return _availableCameras;
    }
  }

  /// Определить тип камеры по названию
  CameraType _determineCameraType(String label) {
    final lowerLabel = label.toLowerCase();
    
    // Внешние USB камеры
    if (lowerLabel.contains('usb') || 
        lowerLabel.contains('external') ||
        lowerLabel.contains('webcam') ||
        lowerLabel.contains('logitech') ||
        lowerLabel.contains('microsoft') ||
        lowerLabel.contains('creative') ||
        lowerLabel.contains('genius')) {
      return CameraType.external;
    }
    
    // Передняя камера (фронтальная)
    if (lowerLabel.contains('front') || 
        lowerLabel.contains('user') ||
        lowerLabel.contains('facing front') ||
        lowerLabel.contains('selfie')) {
      return CameraType.front;
    }
    
    // Задняя камера
    if (lowerLabel.contains('back') || 
        lowerLabel.contains('rear') ||
        lowerLabel.contains('facing back') ||
        lowerLabel.contains('environment')) {
      return CameraType.back;
    }
    
    // Встроенные камеры
    if (lowerLabel.contains('integrated') ||
        lowerLabel.contains('built-in') ||
        lowerLabel.contains('facetime') ||
        lowerLabel.contains('isight') ||
        lowerLabel.contains('internal')) {
      return CameraType.builtin;
    }
    
    // По умолчанию считаем встроенной
    return CameraType.builtin;
  }

  /// Выбрать камеру
  Future<bool> selectCamera(String deviceId) async {
    // Проверяем, не выбрана ли уже эта камера
    if (_selectedCamera != null && _selectedCamera!.deviceId == deviceId) {
      debugPrint('📷 Камера уже выбрана: ${_selectedCamera!.label}');
      return true; // Возвращаем успех, не переинициализируя
    }
    
    final camera = _availableCameras.firstWhere(
      (cam) => cam.deviceId == deviceId,
      orElse: () => throw Exception('Камера не найдена'),
    );
    
    debugPrint('📷 Переключаемся на камеру: ${camera.label}');
    _selectedCamera = camera;
    return await _initializeCamera();
  }

  /// Инициализировать камеру
  Future<bool> _initializeCamera() async {
    if (!kIsWeb || _selectedCamera == null) {
      debugPrint('❌ Не веб или камера не выбрана');
      return false;
    }

    try {
      debugPrint('🎬 Инициализируем камеру: ${_selectedCamera!.label} (${_selectedCamera!.deviceId})');
      
      // Останавливаем предыдущий поток
      await stopCamera();

      final constraints = {
        'video': {
          'deviceId': {'exact': _selectedCamera!.deviceId},
          'width': {'ideal': 1920},
          'height': {'ideal': 1080},
          'frameRate': {'ideal': 30},
        },
        'audio': false,
      };

      debugPrint('📋 Используем constraints: $constraints');

      _currentStream = await html.window.navigator.mediaDevices!
          .getUserMedia(constraints);

      debugPrint('✅ MediaStream получен, создаем видео элемент...');

      // Создаем видео элемент для предварительного просмотра
      _videoElement = html.VideoElement();
      
      // Настраиваем видео элемент
      _videoElement!.autoplay = true;
      _videoElement!.muted = true;
      _videoElement!.style.width = '100%';
      _videoElement!.style.height = '100%';
      _videoElement!.style.objectFit = 'cover';
      
      // Устанавливаем поток
      _videoElement!.srcObject = _currentStream;
      
      // Регистрируем видео элемент для Flutter (только для веб)
      if (kIsWeb) {
        final viewType = 'camera-video-preview';
        try {
          ui_web.platformViewRegistry.registerViewFactory(
            viewType,
            (int viewId) => _videoElement!,
          );
          debugPrint('📹 Видео элемент зарегистрирован с viewType: $viewType');
        } catch (e) {
          debugPrint('⚠️ Ошибка регистрации видео элемента: $e');
        }
      }
      
      // Добавляем обработчики событий для отладки
      _videoElement!.onLoadedMetadata.listen((event) {
        debugPrint('📹 Видео метаданные загружены: ${_videoElement!.videoWidth}x${_videoElement!.videoHeight}');
      });
      
      _videoElement!.onPlaying.listen((event) {
        debugPrint('▶️ Видео начало воспроизведение');
      });
      
      _videoElement!.onError.listen((event) {
        debugPrint('❌ Ошибка видео: $event');
      });
      
      await _videoElement!.play();
      debugPrint('📹 Камера инициализирована успешно');
      return true;
    } catch (e) {
      debugPrint('❌ Ошибка инициализации камеры: $e');
      return false;
    }
  }

  /// Получить видео элемент для предварительного просмотра
  html.VideoElement? get videoElement => _videoElement;

  /// Сделать фото
  Future<Uint8List?> takePhoto({CameraSettings? settings}) async {
    if (_videoElement == null || _currentStream == null) {
      throw Exception('Камера не инициализирована');
    }

    try {
      final canvas = html.CanvasElement();
      final context = canvas.getContext('2d') as html.CanvasRenderingContext2D;
      
      // Устанавливаем размер canvas
      final width = settings?.width ?? _videoElement!.videoWidth;
      final height = settings?.height ?? _videoElement!.videoHeight;
      
      canvas.width = width;
      canvas.height = height;

      // Рисуем текущий кадр с видео на canvas
      context.drawImageScaled(_videoElement!, 0, 0, width, height);

      // Применяем эффекты если нужно
      if (settings?.applyEffects == true) {
        _applyPhotoEffects(context, width, height, settings!);
      }

      // Конвертируем в Uint8List
      final dataUrl = canvas.toDataUrl('image/png');
      final base64Data = dataUrl.split(',')[1];
      
      // Декодируем base64
      final bytes = html.window.atob(base64Data);
      final uint8List = Uint8List(bytes.length);
      for (int i = 0; i < bytes.length; i++) {
        uint8List[i] = bytes.codeUnitAt(i);
      }

      return uint8List;
    } catch (e) {
      debugPrint('Ошибка съемки фото: $e');
      return null;
    }
  }

  /// Применить эффекты к фото
  void _applyPhotoEffects(
    html.CanvasRenderingContext2D context,
    int width,
    int height,
    CameraSettings settings,
  ) {
    // Применяем фильтры
    if (settings.brightness != 1.0 || settings.contrast != 1.0) {
      context.filter = 'brightness(${settings.brightness}) contrast(${settings.contrast})';
    }

    // Добавляем рамку если нужно
    if (settings.addFrame) {
      context.strokeStyle = '#ffffff';
      context.lineWidth = 10;
      context.strokeRect(0, 0, width, height);
    }

    // Добавляем водяной знак
    if (settings.watermark != null) {
      context.fillStyle = 'rgba(255, 255, 255, 0.7)';
      context.font = '24px Arial';
      context.fillText(settings.watermark!, 20, height - 30);
    }
  }

  /// Остановить камеру
  Future<void> stopCamera() async {
    if (_currentStream != null) {
      _currentStream!.getTracks().forEach((track) => track.stop());
      _currentStream = null;
    }
    
    if (_videoElement != null) {
      _videoElement!.srcObject = null;
      _videoElement = null;
    }
  }

  /// Получить выбранную камеру
  CameraDevice? get selectedCamera => _selectedCamera;

  /// Проверить поддержку камеры
  Future<bool> isCameraSupported() async {
    if (!kIsWeb) return true;
    
    try {
      return html.window.navigator.mediaDevices != null;
    } catch (e) {
      return false;
    }
  }

  /// Запросить разрешение на использование камеры
  Future<bool> requestCameraPermission() async {
    if (!kIsWeb) return true;

    try {
      final stream = await html.window.navigator.mediaDevices!
          .getUserMedia({'video': true, 'audio': false});
      
      // Сразу останавливаем поток, нам нужно только разрешение
      stream.getTracks().forEach((track) => track.stop());
      return true;
    } catch (e) {
      debugPrint('Разрешение на камеру отклонено: $e');
      return false;
    }
  }
}

/// Информация о камере
class CameraDevice {
  final String deviceId;
  final String label;
  final CameraType type;

  CameraDevice(this.deviceId, this.label, this.type);

  @override
  String toString() => label;
}

/// Тип камеры
enum CameraType {
  builtin,   // Встроенная
  external,  // Внешняя USB
  front,     // Фронтальная
  back,      // Задняя
}

/// Настройки камеры
class CameraSettings {
  final int width;
  final int height;
  final double brightness;
  final double contrast;
  final bool addFrame;
  final String? watermark;
  final bool applyEffects;

  const CameraSettings({
    this.width = 1920,
    this.height = 1080,
    this.brightness = 1.0,
    this.contrast = 1.0,
    this.addFrame = false,
    this.watermark,
    this.applyEffects = false,
  });
}
