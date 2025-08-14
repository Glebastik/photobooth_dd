import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

/// Упрощенный виджет режима фотобудки
class SimplePhotoboothMode extends StatefulWidget {
  const SimplePhotoboothMode({super.key});

  @override
  State<SimplePhotoboothMode> createState() => _SimplePhotoboothModeState();
}

class _SimplePhotoboothModeState extends State<SimplePhotoboothMode> {
  bool _isFullscreen = false;
  bool _isAutoMode = false;
  int _countdown = 0;
  Timer? _timer;
  String _statusMessage = 'Готов к работе';
  
  @override
  void initState() {
    super.initState();
  }

  /// Переключить полноэкранный режим
  Future<void> _toggleFullscreen() async {
    try {
      if (_isFullscreen) {
        await html.document.exitFullscreen();
      } else {
        await html.document.documentElement?.requestFullscreen();
      }
      setState(() => _isFullscreen = !_isFullscreen);
    } catch (e) {
      _showMessage('Ошибка полноэкранного режима: $e');
    }
  }

  /// Начать автоматический режим
  void _startAutoMode() {
    setState(() {
      _isAutoMode = true;
      _statusMessage = 'Автоматический режим активен';
    });
    _startCountdown();
  }

  /// Остановить автоматический режим
  void _stopAutoMode() {
    _timer?.cancel();
    setState(() {
      _isAutoMode = false;
      _countdown = 0;
      _statusMessage = 'Автоматический режим остановлен';
    });
  }

  /// Начать обратный отсчет
  void _startCountdown() {
    setState(() {
      _countdown = 5;
      _statusMessage = 'Приготовьтесь! Фото через $_countdown секунд';
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _countdown--;
        if (_countdown > 0) {
          _statusMessage = 'Фото через $_countdown секунд';
        } else {
          _statusMessage = 'Улыбайтесь! 📸';
        }
      });

      if (_countdown <= 0) {
        timer.cancel();
        _takePhoto();
      }
    });
  }

  /// Сделать фото
  void _takePhoto() {
    context.read<PhotoboothBloc>().add(const PhotoboothPhotoTaken());
    setState(() => _statusMessage = 'Фото сделано!');
    
    // Автоматическая печать через 2 секунды
    Timer(const Duration(seconds: 2), () {
      _printPhoto();
    });

    // Перезапуск через 5 секунд
    if (_isAutoMode) {
      Timer(const Duration(seconds: 5), () {
        if (_isAutoMode) _startCountdown();
      });
    }
  }

  /// Печать фото
  void _printPhoto() {
    setState(() => _statusMessage = 'Печатаем фото...');
    
    try {
      // Простая печать через браузер
      html.window.print();
      setState(() => _statusMessage = 'Фото отправлено на печать!');
    } catch (e) {
      _showMessage('Ошибка печати: $e');
    }
  }

  /// Показать сообщение
  void _showMessage(String message) {
    setState(() => _statusMessage = message);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PhotoboothColors.black,
      body: Stack(
        children: [
          // Основной интерфейс
          _buildMainInterface(),
          
          // Панель управления
          Positioned(
            top: 20,
            right: 20,
            child: _buildControlPanel(),
          ),
          
          // Оверлей обратного отсчета
          if (_countdown > 0) _buildCountdownOverlay(),
        ],
      ),
    );
  }

  Widget _buildMainInterface() {
    return Column(
      children: [
        // Заголовок
        Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'ФОТОБУДКА',
                style: TextStyle(
                  color: PhotoboothColors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _statusMessage,
                style: const TextStyle(
                  color: PhotoboothColors.white,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
        
        // Область камеры/фото
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: PhotoboothColors.black,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: PhotoboothColors.white.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: _buildCameraArea(),
          ),
        ),
        
        // Кнопки управления
        _buildControlButtons(),
      ],
    );
  }

  Widget _buildCameraArea() {
    return BlocBuilder<PhotoboothBloc, PhotoboothState>(
      builder: (context, state) {
        if (state.image != null) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.memory(
              state.image!,
              fit: BoxFit.contain,
              width: double.infinity,
              height: double.infinity,
            ),
          );
        }
        
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.camera_alt,
                size: 120,
                color: PhotoboothColors.white,
              ),
              SizedBox(height: 20),
              Text(
                'Нажмите "Сделать фото" или включите автоматический режим',
                style: TextStyle(
                  color: PhotoboothColors.white,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildControlButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Кнопка фото
          ElevatedButton(
            onPressed: _isAutoMode ? null : () => _takePhoto(),
            style: ElevatedButton.styleFrom(
              backgroundColor: PhotoboothColors.blue,
              foregroundColor: PhotoboothColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.camera_alt, size: 24),
                SizedBox(width: 8),
                Text('Сделать фото', style: TextStyle(fontSize: 18)),
              ],
            ),
          ),
          
          const SizedBox(width: 20),
          
          // Кнопка автоматического режима
          ElevatedButton(
            onPressed: _isAutoMode ? _stopAutoMode : _startAutoMode,
            style: ElevatedButton.styleFrom(
              backgroundColor: _isAutoMode ? PhotoboothColors.red : PhotoboothColors.green,
              foregroundColor: PhotoboothColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_isAutoMode ? Icons.stop : Icons.play_arrow, size: 24),
                const SizedBox(width: 8),
                Text(
                  _isAutoMode ? 'СТОП' : 'АВТО',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 20),
          
          // Кнопка печати
          BlocBuilder<PhotoboothBloc, PhotoboothState>(
            builder: (context, state) {
              return ElevatedButton(
                onPressed: state.image != null ? _printPhoto : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: PhotoboothColors.orange,
                  foregroundColor: PhotoboothColors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.print, size: 24),
                    SizedBox(width: 8),
                    Text('Печать', style: TextStyle(fontSize: 18)),
                  ],
                ),
              );
            },
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
          // Кнопка выхода
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close, color: PhotoboothColors.white, size: 28),
            tooltip: 'Выйти',
          ),
          
          const SizedBox(height: 8),
          
          // Кнопка полноэкранного режима
          IconButton(
            onPressed: _toggleFullscreen,
            icon: Icon(
              _isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
              color: PhotoboothColors.white,
              size: 28,
            ),
            tooltip: _isFullscreen ? 'Выйти из полноэкранного режима' : 'Полноэкранный режим',
          ),
        ],
      ),
    );
  }

  Widget _buildCountdownOverlay() {
    return Positioned.fill(
      child: Container(
        color: PhotoboothColors.black.withOpacity(0.9),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _countdown.toString(),
                style: const TextStyle(
                  color: PhotoboothColors.white,
                  fontSize: 200,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _statusMessage,
                style: const TextStyle(
                  color: PhotoboothColors.white,
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
