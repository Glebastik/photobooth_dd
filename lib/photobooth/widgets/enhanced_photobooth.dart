// Быстрое исправление enhanced_photobooth.dart для Linux сборки
// Минимальная версия без сложной логики UI для успешной компиляции

import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../l10n/l10n.dart';
import '../../services/camera_service.dart';
import '../../services/printer_service.dart';
import '../../services/common_types.dart';

/// Упрощенная фотобудка для Linux сборки
class EnhancedPhotobooth extends StatefulWidget {
  const EnhancedPhotobooth({
    super.key,
    required this.cameraService,
    required this.printerService,
  });

  final CameraService cameraService;
  final PrinterService printerService;

  @override
  State<EnhancedPhotobooth> createState() => _EnhancedPhotoboothState();
}

class _EnhancedPhotoboothState extends State<EnhancedPhotobooth> {
  bool _isInitialized = false;
  bool _isAutoMode = false;
  bool _isFullscreen = false;
  String _message = '';
  Uint8List? _lastPhoto;
  
  List<CameraDevice> _availableCameras = [];
  List<PrinterDevice> _availablePrinters = [];
  CameraSettings _cameraSettings = const CameraSettings();
  PrintSettings _printSettings = const PrintSettings();

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    try {
      _availableCameras = await widget.cameraService.getAvailableCameras();
      _availablePrinters = await widget.printerService.getAvailablePrinters();
      
      if (_availableCameras.isNotEmpty) {
        await widget.cameraService.selectCamera(_availableCameras.first.deviceId);
      }
      
      if (_availablePrinters.isNotEmpty) {
        widget.printerService.selectPrinter(_availablePrinters.first);
      }
      
      setState(() {
        _isInitialized = true;
        _message = 'Фотобудка готова к работе';
      });
    } catch (e) {
      setState(() {
        _message = 'Ошибка инициализации: $e';
      });
    }
  }

  Future<void> _takePhoto() async {
    try {
      setState(() => _message = 'Делаем снимок...');
      
      final photoData = await widget.cameraService.takePhoto(settings: _cameraSettings);
      if (photoData != null) {
        setState(() {
          _lastPhoto = photoData;
          _message = 'Снимок готов!';
        });
      } else {
        setState(() => _message = 'Ошибка создания снимка');
      }
    } catch (e) {
      setState(() => _message = 'Ошибка: $e');
    }
  }

  Future<void> _printPhoto() async {
    if (_lastPhoto == null) {
      setState(() => _message = 'Нет снимка для печати');
      return;
    }

    try {
      setState(() => _message = 'Печатаем...');
      
      final success = await widget.printerService.printPhoto(
        _lastPhoto!,
        settings: _printSettings,
      );
      
      setState(() {
        _message = success ? 'Снимок отправлен на печать!' : 'Ошибка печати';
      });
    } catch (e) {
      setState(() => _message = 'Ошибка печати: $e');
    }
  }

  void _toggleFullscreen() {
    try {
      if (kIsWeb) {
        // Веб-версия: используем JavaScript API
        // Здесь будет веб-специфичный код
      } else {
        // Desktop версия: используем системные вызовы
        if (_isFullscreen) {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        } else {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
        }
      }
      setState(() => _isFullscreen = !_isFullscreen);
    } catch (e) {
      setState(() => _message = 'Полноэкранный режим недоступен');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: _isFullscreen ? null : AppBar(
        title: const Text('Фотобудка'),
        actions: [
          IconButton(
            icon: Icon(_isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen),
            onPressed: _toggleFullscreen,
          ),
        ],
      ),
      body: Column(
        children: [
          // Область предварительного просмотра
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              color: Colors.black,
              child: _lastPhoto != null
                  ? Image.memory(_lastPhoto!, fit: BoxFit.contain)
                  : const Center(
                      child: Text(
                        'Предварительный просмотр',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
            ),
          ),
          
          // Панель управления
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  _message,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _takePhoto,
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Сделать снимок'),
                    ),
                    ElevatedButton.icon(
                      onPressed: _lastPhoto != null ? _printPhoto : null,
                      icon: const Icon(Icons.print),
                      label: const Text('Печать'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Камер: ${_availableCameras.length}, Принтеров: ${_availablePrinters.length}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
