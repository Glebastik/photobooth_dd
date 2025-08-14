import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/photobooth/services/photobooth_mode_service.dart';
import 'package:io_photobooth/photobooth/services/camera_service.dart';
import 'package:io_photobooth/photobooth/widgets/camera_selector.dart';
import 'package:io_photobooth/photobooth/widgets/print_button.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

/// Виджет режима автоматической фотобудки
class PhotoboothModeWidget extends StatefulWidget {
  const PhotoboothModeWidget({super.key});

  @override
  State<PhotoboothModeWidget> createState() => _PhotoboothModeWidgetState();
}

class _PhotoboothModeWidgetState extends State<PhotoboothModeWidget> {
  final PhotoboothModeService _photoboothService = PhotoboothModeService();
  final CameraService _cameraService = CameraService();
  
  bool _showCameraSelector = false;
  bool _isPhotoboothActive = false;
  Uint8List? _lastPhotoBytes;

  @override
  void initState() {
    super.initState();
    _setupPhotoboothCallbacks();
  }

  void _setupPhotoboothCallbacks() {
    _photoboothService.onTakePhoto = _takePhoto;
    _photoboothService.onPhotoTaken = _onPhotoTaken;
    _photoboothService.onSessionCompleted = _onSessionCompleted;
    _photoboothService.onError = _onError;
  }

  Future<Uint8List?> _takePhoto() async {
    try {
      // Trigger photo capture through PhotoboothBloc
      context.read<PhotoboothBloc>().add(const PhotoboothPhotoTaken());
      
      // Wait for the photo to be processed
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Get the current image from the bloc state
      final state = context.read<PhotoboothBloc>().state;
      if (state.image != null) {
        // Convert the image to bytes (this would need proper implementation)
        // For now, return a placeholder
        return Uint8List(0); // Placeholder - needs proper image conversion
      }
      
      return null;
    } catch (e) {
      debugPrint('Error taking photo: $e');
      return null;
    }
  }

  Future<void> _onPhotoTaken(Uint8List imageBytes) async {
    setState(() {
      _lastPhotoBytes = imageBytes;
    });
  }

  void _onSessionCompleted() {
    // Session completed - photo taken and optionally printed
  }

  void _onError(String error) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка фотобудки: $error'),
          backgroundColor: PhotoboothColors.red,
        ),
      );
    }
  }

  Future<void> _startPhotoboothMode() async {
    try {
      await _photoboothService.startPhotoboothMode(
        settings: const PhotoboothSettings(
          countdownDuration: Duration(seconds: 5),
          autoPrint: true,
          autoRestart: true,
          restartDelay: Duration(seconds: 10),
        ),
      );
      
      setState(() {
        _isPhotoboothActive = true;
      });
    } catch (e) {
      _onError('Не удалось запустить режим фотобудки: $e');
    }
  }

  Future<void> _stopPhotoboothMode() async {
    await _photoboothService.stopPhotoboothMode();
    setState(() {
      _isPhotoboothActive = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PhotoboothColors.black,
      body: Stack(
        children: [
          // Main photobooth interface
          _buildMainInterface(),
          
          // Control panel (top-right)
          Positioned(
            top: 20,
            right: 20,
            child: _buildControlPanel(),
          ),
          
          // Camera selector overlay
          if (_showCameraSelector)
            _buildCameraSelectorOverlay(),
          
          // Photobooth status overlay
          if (_isPhotoboothActive)
            _buildPhotoboothStatusOverlay(),
        ],
      ),
    );
  }

  Widget _buildMainInterface() {
    return Column(
      children: [
        // Header with title and controls
        Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'ФОТОБУДКА',
                style: TextStyle(
                  color: PhotoboothColors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () => setState(() => _showCameraSelector = !_showCameraSelector),
                    icon: const Icon(Icons.videocam, color: PhotoboothColors.white),
                    tooltip: 'Выбрать камеру',
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _isPhotoboothActive ? _stopPhotoboothMode : _startPhotoboothMode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isPhotoboothActive ? PhotoboothColors.red : PhotoboothColors.green,
                      foregroundColor: PhotoboothColors.white,
                    ),
                    child: Text(_isPhotoboothActive ? 'СТОП' : 'СТАРТ'),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // Main camera/photo area
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: PhotoboothColors.black,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: PhotoboothColors.white.withOpacity(0.3)),
            ),
            child: _buildCameraArea(),
          ),
        ),
        
        // Bottom controls
        if (!_isPhotoboothActive)
          _buildBottomControls(),
      ],
    );
  }

  Widget _buildCameraArea() {
    return BlocBuilder<PhotoboothBloc, PhotoboothState>(
      builder: (context, state) {
        return Center(
          child: state.image != null
              ? Image.memory(
                  state.image!,
                  fit: BoxFit.contain,
                )
              : const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt,
                      size: 100,
                      color: PhotoboothColors.white,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Камера не активна',
                      style: TextStyle(
                        color: PhotoboothColors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildBottomControls() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => context.read<PhotoboothBloc>().add(const PhotoboothPhotoTaken()),
            style: ElevatedButton.styleFrom(
              backgroundColor: PhotoboothColors.blue,
              foregroundColor: PhotoboothColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.camera_alt),
                SizedBox(width: 8),
                Text('Сделать фото'),
              ],
            ),
          ),
          const SizedBox(width: 20),
          if (_lastPhotoBytes != null)
            PrintButton(
              imageBytes: _lastPhotoBytes!,
              showQuickPrint: true,
            ),
        ],
      ),
    );
  }

  Widget _buildControlPanel() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: PhotoboothColors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close, color: PhotoboothColors.white),
            tooltip: 'Выйти из режима фотобудки',
          ),
          const SizedBox(height: 8),
          IconButton(
            onPressed: () {
              // Show settings dialog
              _showSettingsDialog();
            },
            icon: const Icon(Icons.settings, color: PhotoboothColors.white),
            tooltip: 'Настройки',
          ),
        ],
      ),
    );
  }

  Widget _buildCameraSelectorOverlay() {
    return Positioned.fill(
      child: Container(
        color: PhotoboothColors.black.withOpacity(0.8),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: CameraSelector(
              onCameraSelected: (deviceId) {
                setState(() => _showCameraSelector = false);
                // Update camera in photobooth bloc if needed
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoboothStatusOverlay() {
    return StreamBuilder<PhotoboothState>(
      stream: _photoboothService.stateStream,
      builder: (context, stateSnapshot) {
        return StreamBuilder<String>(
          stream: _photoboothService.messageStream,
          builder: (context, messageSnapshot) {
            return StreamBuilder<int>(
              stream: _photoboothService.countdownStream,
              builder: (context, countdownSnapshot) {
                final state = stateSnapshot.data ?? PhotoboothState.idle;
                final message = messageSnapshot.data ?? '';
                final countdown = countdownSnapshot.data ?? 0;

                if (state == PhotoboothState.idle) {
                  return const SizedBox.shrink();
                }

                return Positioned.fill(
                  child: Container(
                    color: PhotoboothColors.black.withOpacity(0.9),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (state == PhotoboothState.countdown && countdown > 0)
                            Text(
                              countdown.toString(),
                              style: const TextStyle(
                                color: PhotoboothColors.white,
                                fontSize: 120,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          else
                            Icon(
                              _getStateIcon(state),
                              size: 100,
                              color: PhotoboothColors.white,
                            ),
                          const SizedBox(height: 20),
                          Text(
                            message,
                            style: const TextStyle(
                              color: PhotoboothColors.white,
                              fontSize: 24,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (state == PhotoboothState.processing || state == PhotoboothState.printing)
                            const Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: AppCircularProgressIndicator(),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  IconData _getStateIcon(PhotoboothState state) {
    switch (state) {
      case PhotoboothState.instructions:
        return Icons.info;
      case PhotoboothState.takingPhoto:
        return Icons.camera_alt;
      case PhotoboothState.processing:
        return Icons.image;
      case PhotoboothState.printing:
        return Icons.print;
      case PhotoboothState.completed:
        return Icons.check_circle;
      case PhotoboothState.error:
        return Icons.error;
      default:
        return Icons.camera_alt;
    }
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => _PhotoboothSettingsDialog(
        currentSettings: _photoboothService.settings,
        onSettingsChanged: (settings) {
          _photoboothService.updateSettings(settings);
        },
      ),
    );
  }

  @override
  void dispose() {
    _photoboothService.stopPhotoboothMode();
    super.dispose();
  }
}

/// Диалог настроек фотобудки
class _PhotoboothSettingsDialog extends StatefulWidget {
  const _PhotoboothSettingsDialog({
    required this.currentSettings,
    required this.onSettingsChanged,
  });

  final PhotoboothSettings currentSettings;
  final void Function(PhotoboothSettings) onSettingsChanged;

  @override
  State<_PhotoboothSettingsDialog> createState() => _PhotoboothSettingsDialogState();
}

class _PhotoboothSettingsDialogState extends State<_PhotoboothSettingsDialog> {
  late PhotoboothSettings _settings;

  @override
  void initState() {
    super.initState();
    _settings = widget.currentSettings;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Настройки фотобудки'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('Автоматическая печать'),
              value: _settings.autoPrint,
              onChanged: (value) {
                setState(() {
                  _settings = _settings.copyWith(autoPrint: value);
                });
              },
            ),
            SwitchListTile(
              title: const Text('Автоматический перезапуск'),
              value: _settings.autoRestart,
              onChanged: (value) {
                setState(() {
                  _settings = _settings.copyWith(autoRestart: value);
                });
              },
            ),
            SwitchListTile(
              title: const Text('Показывать инструкции'),
              value: _settings.showInstructions,
              onChanged: (value) {
                setState(() {
                  _settings = _settings.copyWith(showInstructions: value);
                });
              },
            ),
            ListTile(
              title: const Text('Время обратного отсчета'),
              subtitle: Text('${_settings.countdownDuration.inSeconds} сек'),
              trailing: DropdownButton<int>(
                value: _settings.countdownDuration.inSeconds,
                items: [3, 5, 10].map((seconds) {
                  return DropdownMenuItem(
                    value: seconds,
                    child: Text('$seconds сек'),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _settings = _settings.copyWith(
                        countdownDuration: Duration(seconds: value),
                      );
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSettingsChanged(_settings);
            Navigator.of(context).pop();
          },
          child: const Text('Сохранить'),
        ),
      ],
    );
  }
}
