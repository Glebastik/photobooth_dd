import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

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
                  id: device,
                  name: 'Camera ${device.split('/').last}',
                  isDefault: device == '/dev/video0',
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
      CameraDevice(
        id: 'virtual_camera',
        name: 'Virtual Camera',
        isDefault: true,
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
}

/// Модель устройства камеры
class CameraDevice {
  final String id;
  final String name;
  final bool isDefault;

  CameraDevice({
    required this.id,
    required this.name,
    this.isDefault = false,
  });

  @override
  String toString() => 'CameraDevice(id: $id, name: $name, default: $isDefault)';
}
