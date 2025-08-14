import 'dart:async';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

/// Минимальная версия фотобудки без сложных зависимостей
class MinimalPhotobooth extends StatefulWidget {
  const MinimalPhotobooth({super.key});

  @override
  State<MinimalPhotobooth> createState() => _MinimalPhotoboothState();
}

class _MinimalPhotoboothState extends State<MinimalPhotobooth> {
  bool _isFullscreen = false;
  bool _isAutoMode = false;
  int _countdown = 0;
  Timer? _timer;
  String _message = 'Добро пожаловать в фотобудку!';
  
  /// Переключить полноэкранный режим
  void _toggleFullscreen() {
    try {
      if (_isFullscreen) {
        html.document.exitFullscreen();
      } else {
        html.document.documentElement?.requestFullscreen();
      }
      setState(() => _isFullscreen = !_isFullscreen);
    } catch (e) {
      _showSnackBar('Полноэкранный режим недоступен');
    }
  }

  /// Начать автоматический режим
  void _startAutoMode() {
    setState(() {
      _isAutoMode = true;
      _message = 'Автоматический режим включен';
    });
    _startCountdown();
  }

  /// Остановить автоматический режим
  void _stopAutoMode() {
    _timer?.cancel();
    setState(() {
      _isAutoMode = false;
      _countdown = 0;
      _message = 'Автоматический режим выключен';
    });
  }

  /// Начать обратный отсчет
  void _startCountdown() {
    setState(() => _countdown = 5);
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _countdown--;
        _message = _countdown > 0 ? 'Фото через $_countdown сек...' : 'Улыбайтесь! 📸';
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
    setState(() => _message = 'Фото готово!');
    
    // Автоматическая печать через 2 секунды
    Timer(const Duration(seconds: 2), () {
      _printPhoto();
    });

    // Перезапуск автоматического режима
    if (_isAutoMode) {
      Timer(const Duration(seconds: 5), () {
        if (_isAutoMode) _startCountdown();
      });
    }
  }

  /// Печать фото
  void _printPhoto() {
    try {
      html.window.print();
      setState(() => _message = 'Отправлено на печать!');
      _showSnackBar('Фото отправлено на печать');
    } catch (e) {
      _showSnackBar('Ошибка печати');
    }
  }

  /// Показать уведомление
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PhotoboothColors.black,
      appBar: AppBar(
        backgroundColor: PhotoboothColors.black,
        foregroundColor: PhotoboothColors.white,
        title: const Text('ФОТОБУДКА'),
        actions: [
          IconButton(
            icon: Icon(_isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen),
            onPressed: _toggleFullscreen,
            tooltip: 'Полноэкранный режим',
          ),
        ],
      ),
      body: Column(
        children: [
          // Статус
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: PhotoboothColors.blue.withOpacity(0.1),
            child: Text(
              _message,
              style: const TextStyle(
                color: PhotoboothColors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          // Область фото/камеры
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: PhotoboothColors.white.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: _buildPhotoArea(),
            ),
          ),
          
          // Кнопки управления
          _buildControls(),
        ],
      ),
      
      // Оверлей обратного отсчета
      body: _countdown > 0 ? _buildCountdownOverlay() : null,
    );
  }

  Widget _buildPhotoArea() {
    return BlocBuilder<PhotoboothBloc, PhotoboothState>(
      builder: (context, state) {
        if (state.image != null) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
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
                size: 100,
                color: PhotoboothColors.white,
              ),
              SizedBox(height: 20),
              Text(
                'Нажмите кнопку для съемки',
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

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Кнопка фото
          ElevatedButton.icon(
            onPressed: _isAutoMode ? null : _takePhoto,
            icon: const Icon(Icons.camera_alt),
            label: const Text('ФОТО'),
            style: ElevatedButton.styleFrom(
              backgroundColor: PhotoboothColors.blue,
              foregroundColor: PhotoboothColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
          
          // Кнопка автоматического режима
          ElevatedButton.icon(
            onPressed: _isAutoMode ? _stopAutoMode : _startAutoMode,
            icon: Icon(_isAutoMode ? Icons.stop : Icons.play_arrow),
            label: Text(_isAutoMode ? 'СТОП' : 'АВТО'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _isAutoMode ? PhotoboothColors.red : PhotoboothColors.green,
              foregroundColor: PhotoboothColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
          
          // Кнопка печати
          BlocBuilder<PhotoboothBloc, PhotoboothState>(
            builder: (context, state) {
              return ElevatedButton.icon(
                onPressed: state.image != null ? _printPhoto : null,
                icon: const Icon(Icons.print),
                label: const Text('ПЕЧАТЬ'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: PhotoboothColors.orange,
                  foregroundColor: PhotoboothColors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              );
            },
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
                  fontSize: 150,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _message,
                style: const TextStyle(
                  color: PhotoboothColors.white,
                  fontSize: 24,
                ),
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
