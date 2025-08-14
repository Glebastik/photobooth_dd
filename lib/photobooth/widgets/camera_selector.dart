import 'package:flutter/material.dart';
import 'package:io_photobooth/photobooth/services/camera_service.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

/// Виджет для выбора камеры
class CameraSelector extends StatefulWidget {
  const CameraSelector({
    super.key,
    this.onCameraSelected,
  });

  final void Function(String deviceId)? onCameraSelected;

  @override
  State<CameraSelector> createState() => _CameraSelectorState();
}

class _CameraSelectorState extends State<CameraSelector> {
  final CameraService _cameraService = CameraService();
  List<CameraInfo> _cameras = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCameras();
  }

  Future<void> _loadCameras() async {
    setState(() => _isLoading = true);
    try {
      final cameras = await _cameraService.getAvailableCameras();
      setState(() {
        _cameras = cameras;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: AppCircularProgressIndicator(),
      );
    }

    if (_cameras.isEmpty) {
      return const Center(
        child: Text(
          'Камеры не найдены',
          style: TextStyle(color: PhotoboothColors.white),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: PhotoboothColors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Выберите камеру:',
            style: TextStyle(
              color: PhotoboothColors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ..._cameras.map((camera) => _buildCameraOption(camera)),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _loadCameras,
            style: ElevatedButton.styleFrom(
              backgroundColor: PhotoboothColors.blue,
              foregroundColor: PhotoboothColors.white,
            ),
            child: const Text('Обновить список'),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraOption(CameraInfo camera) {
    final isSelected = _cameraService.selectedCameraId == camera.deviceId;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          _cameraService.selectCamera(camera.deviceId);
          widget.onCameraSelected?.call(camera.deviceId);
          setState(() {});
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected ? PhotoboothColors.blue : PhotoboothColors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? PhotoboothColors.blue : PhotoboothColors.white.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.videocam,
                color: isSelected ? PhotoboothColors.white : PhotoboothColors.white.withOpacity(0.7),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      camera.label,
                      style: TextStyle(
                        color: isSelected ? PhotoboothColors.white : PhotoboothColors.white.withOpacity(0.9),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    if (camera.isDefault)
                      Text(
                        'По умолчанию',
                        style: TextStyle(
                          color: PhotoboothColors.white.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: PhotoboothColors.white,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
