import 'dart:html' as html;
import 'dart:async';
import 'package:flutter/foundation.dart';

/// Информация о камере
class CameraInfo {
  const CameraInfo({
    required this.deviceId,
    required this.label,
    this.isDefault = false,
  });

  final String deviceId;
  final String label;
  final bool isDefault;

  @override
  String toString() => 'CameraInfo(deviceId: $deviceId, label: $label, isDefault: $isDefault)';
}

/// Сервис для работы с камерами
class CameraService {
  static final CameraService _instance = CameraService._internal();
  factory CameraService() => _instance;
  CameraService._internal();

  List<CameraInfo> _availableCameras = [];
  String? _selectedCameraId;

  /// Получить список доступных камер
  Future<List<CameraInfo>> getAvailableCameras() async {
    if (!kIsWeb) {
      // Для desktop версии можно использовать другую логику
      return [
        const CameraInfo(deviceId: 'default', label: 'Default Camera', isDefault: true),
      ];
    }

    try {
      // Запросить разрешения на камеру
      await html.window.navigator.mediaDevices!.getUserMedia({'video': true});
      
      // Получить список устройств
      final devices = await html.window.navigator.mediaDevices!.enumerateDevices();
      
      final cameras = <CameraInfo>[];
      for (final device in devices) {
        if (device.kind == 'videoinput') {
          cameras.add(CameraInfo(
            deviceId: device.deviceId!,
            label: device.label!.isNotEmpty ? device.label! : 'Camera ${cameras.length + 1}',
            isDefault: cameras.isEmpty,
          ));
        }
      }
      
      _availableCameras = cameras;
      
      // Установить первую камеру как выбранную по умолчанию
      if (cameras.isNotEmpty && _selectedCameraId == null) {
        _selectedCameraId = cameras.first.deviceId;
      }
      
      return cameras;
    } catch (e) {
      debugPrint('Error getting cameras: $e');
      return [];
    }
  }

  /// Выбрать камеру
  void selectCamera(String deviceId) {
    _selectedCameraId = deviceId;
  }

  /// Получить ID выбранной камеры
  String? get selectedCameraId => _selectedCameraId;

  /// Получить информацию о выбранной камере
  CameraInfo? get selectedCamera {
    if (_selectedCameraId == null) return null;
    try {
      return _availableCameras.firstWhere((camera) => camera.deviceId == _selectedCameraId);
    } catch (e) {
      return null;
    }
  }

  /// Получить список доступных камер (кэшированный)
  List<CameraInfo> get availableCameras => _availableCameras;
}
