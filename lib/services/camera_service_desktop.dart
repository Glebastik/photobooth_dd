import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'common_types.dart';

/// Desktop-совместимый сервис для работы с камерой
class CameraService {
  static final CameraService _instance = CameraService._internal();
  factory CameraService() => _instance;
  CameraService._internal();

  List<CameraDevice> _availableCameras = [];
  CameraDevice? _selectedCamera;
  bool _isInitialized = false;
  bool _isRecording = false;

  /// Получить список доступных камер
  Future<List<CameraDevice>> getAvailableCameras() async {
    try {
      // На Linux используем системные команды для поиска камер
      final result = await Process.run('ls', ['/dev/video*']);
      if (result.exitCode == 0) {
        final devices = result.stdout.toString().split('\n')
            .where((line) => line.isNotEmpty)
            .map((device) => CameraDevice(
                  device,
                  'Camera ${device.split('/').last}',
                  device == '/dev/video0' ? CameraType.builtin : CameraType.external,
                ))
            .toList();
        _availableCameras = devices;
        return devices;
      }
    } catch (e) {
      debugPrint('Ошибка получения камер: $e');
    }
    
    // Fallback - создаем виртуальную камеру
    _availableCameras = [
      const CameraDevice(
        'virtual_camera',
        'Virtual Camera',
        CameraType.builtin,
      ),
    ];
    return _availableCameras;
  }

  /// Инициализировать камеру
  Future<bool> initializeCamera([CameraDevice? camera]) async {
    try {
      _selectedCamera = camera ?? _availableCameras.firstOrNull;
      _isInitialized = true;
      debugPrint('Камера инициализирована: ${_selectedCamera?.name}');
      return true;
    } catch (e) {
      debugPrint('Ошибка инициализации камеры: $e');
      return false;
    }
  }

  /// Начать запись с камеры
  Future<bool> startRecording() async {
    if (!_isInitialized) return false;
    
    try {
      _isRecording = true;
      debugPrint('Запись с камеры начата');
      return true;
    } catch (e) {
      debugPrint('Ошибка начала записи: $e');
      return false;
    }
  }

  /// Остановить запись
  Future<void> stopRecording() async {
    _isRecording = false;
    debugPrint('Запись с камеры остановлена');
  }

  /// Сделать снимок
  Future<Uint8List?> capturePhoto() async {
    if (!_isInitialized || !_isRecording) return null;

    try {
      // На Linux можно использовать ffmpeg или v4l2 для захвата
      // Для демонстрации создаем заглушку
      debugPrint('Снимок сделан с камеры: ${_selectedCamera?.name}');
      
      // Возвращаем пустой массив байт как заглушку
      // В реальной реализации здесь будет захват с камеры
      return Uint8List.fromList([]);
    } catch (e) {
      debugPrint('Ошибка создания снимка: $e');
      return null;
    }
  }

  /// Освободить ресурсы
  Future<void> dispose() async {
    await stopRecording();
    _isInitialized = false;
    _selectedCamera = null;
    debugPrint('Ресурсы камеры освобождены');
  }

  // Геттеры
  List<CameraDevice> get availableCameras => _availableCameras;
  CameraDevice? get selectedCamera => _selectedCamera;
  bool get isInitialized => _isInitialized;
  bool get isRecording => _isRecording;
  
  /// Проверить доступность камеры на платформе
  static bool get isCameraAvailable {
    return !kIsWeb; // На desktop платформах камера доступна
  }

  /// Запросить разрешения (для desktop не требуется)
  Future<bool> requestPermissions() async {
    return true; // На Linux разрешения не требуются
  }

  /// Запросить разрешение на камеру
  Future<bool> requestCameraPermission() async {
    return true; // На Linux разрешения не требуются
  }

  /// Выбрать камеру
  Future<bool> selectCamera(String deviceId) async {
    final camera = _availableCameras.where((c) => c.deviceId == deviceId).firstOrNull;
    if (camera != null) {
      _selectedCamera = camera;
      return await initializeCamera(camera);
    }
    return false;
  }

  /// Остановить камеру
  Future<void> stopCamera() async {
    await stopRecording();
    _isInitialized = false;
  }

  /// Сделать фото с настройками
  Future<Uint8List?> takePhoto({CameraSettings? settings}) async {
    return await capturePhoto();
  }

  /// Получить видео элемент (для совместимости с веб-версией)
  dynamic get videoElement => null; // На desktop не используется
}
