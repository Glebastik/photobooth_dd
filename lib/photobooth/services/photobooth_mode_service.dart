import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:io_photobooth/photobooth/services/print_service.dart';
import 'package:io_photobooth/photobooth/services/fullscreen_service.dart';

/// Настройки режима фотобудки
class PhotoboothSettings {
  const PhotoboothSettings({
    this.countdownDuration = const Duration(seconds: 5),
    this.autoPrint = true,
    this.autoRestart = true,
    this.restartDelay = const Duration(seconds: 10),
    this.showInstructions = true,
    this.instructionsDuration = const Duration(seconds: 3),
    this.enableSound = true,
    this.maxPhotosPerSession = 1,
  });

  final Duration countdownDuration;
  final bool autoPrint;
  final bool autoRestart;
  final Duration restartDelay;
  final bool showInstructions;
  final Duration instructionsDuration;
  final bool enableSound;
  final int maxPhotosPerSession;

  PhotoboothSettings copyWith({
    Duration? countdownDuration,
    bool? autoPrint,
    bool? autoRestart,
    Duration? restartDelay,
    bool? showInstructions,
    Duration? instructionsDuration,
    bool? enableSound,
    int? maxPhotosPerSession,
  }) {
    return PhotoboothSettings(
      countdownDuration: countdownDuration ?? this.countdownDuration,
      autoPrint: autoPrint ?? this.autoPrint,
      autoRestart: autoRestart ?? this.autoRestart,
      restartDelay: restartDelay ?? this.restartDelay,
      showInstructions: showInstructions ?? this.showInstructions,
      instructionsDuration: instructionsDuration ?? this.instructionsDuration,
      enableSound: enableSound ?? this.enableSound,
      maxPhotosPerSession: maxPhotosPerSession ?? this.maxPhotosPerSession,
    );
  }
}

/// Состояния режима фотобудки
enum PhotoboothState {
  idle,           // Ожидание
  instructions,   // Показ инструкций
  countdown,      // Обратный отсчет
  takingPhoto,    // Съемка фото
  processing,     // Обработка фото
  printing,       // Печать
  completed,      // Завершено
  error,          // Ошибка
}

/// Сервис для автоматического режима фотобудки
class PhotoboothModeService {
  static final PhotoboothModeService _instance = PhotoboothModeService._internal();
  factory PhotoboothModeService() => _instance;
  PhotoboothModeService._internal();

  PhotoboothSettings _settings = const PhotoboothSettings();
  PhotoboothState _currentState = PhotoboothState.idle;
  Timer? _timer;
  int _currentCountdown = 0;
  int _photosInSession = 0;
  bool _isActive = false;

  final StreamController<PhotoboothState> _stateController = StreamController<PhotoboothState>.broadcast();
  final StreamController<int> _countdownController = StreamController<int>.broadcast();
  final StreamController<String> _messageController = StreamController<String>.broadcast();

  // Streams для подписки на события
  Stream<PhotoboothState> get stateStream => _stateController.stream;
  Stream<int> get countdownStream => _countdownController.stream;
  Stream<String> get messageStream => _messageController.stream;

  // Callbacks для взаимодействия с UI
  Future<Uint8List?> Function()? onTakePhoto;
  Future<void> Function(Uint8List imageBytes)? onPhotoTaken;
  VoidCallback? onSessionCompleted;
  void Function(String error)? onError;

  /// Запустить режим фотобудки
  Future<void> startPhotoboothMode({
    PhotoboothSettings? settings,
    Future<Uint8List?> Function()? takePhotoCallback,
    Future<void> Function(Uint8List imageBytes)? photoTakenCallback,
    VoidCallback? sessionCompletedCallback,
    void Function(String error)? errorCallback,
  }) async {
    if (_isActive) return;

    _settings = settings ?? _settings;
    onTakePhoto = takePhotoCallback;
    onPhotoTaken = photoTakenCallback;
    onSessionCompleted = sessionCompletedCallback;
    onError = errorCallback;

    _isActive = true;
    _photosInSession = 0;

    try {
      // Включаем полноэкранный режим
      await FullscreenService().enterKioskMode();
      
      // Начинаем сессию
      await _startSession();
    } catch (e) {
      _handleError('Ошибка запуска режима фотобудки: $e');
    }
  }

  /// Остановить режим фотобудки
  Future<void> stopPhotoboothMode() async {
    if (!_isActive) return;

    _isActive = false;
    _timer?.cancel();
    _timer = null;

    try {
      await FullscreenService().exitKioskMode();
    } catch (e) {
      debugPrint('Error exiting kiosk mode: $e');
    }

    _setState(PhotoboothState.idle);
    _setMessage('Режим фотобудки остановлен');
  }

  /// Начать новую сессию
  Future<void> _startSession() async {
    if (!_isActive) return;

    _photosInSession = 0;

    if (_settings.showInstructions) {
      await _showInstructions();
    } else {
      await _startCountdown();
    }
  }

  /// Показать инструкции
  Future<void> _showInstructions() async {
    _setState(PhotoboothState.instructions);
    _setMessage('Приготовьтесь! Фото будет сделано через ${_settings.countdownDuration.inSeconds} секунд');

    _timer = Timer(_settings.instructionsDuration, () {
      if (_isActive) _startCountdown();
    });
  }

  /// Начать обратный отсчет
  Future<void> _startCountdown() async {
    _setState(PhotoboothState.countdown);
    _currentCountdown = _settings.countdownDuration.inSeconds;
    _countdownController.add(_currentCountdown);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isActive) {
        timer.cancel();
        return;
      }

      _currentCountdown--;
      _countdownController.add(_currentCountdown);

      if (_currentCountdown <= 0) {
        timer.cancel();
        _takePhoto();
      } else {
        _setMessage('Фото через $_currentCountdown...');
      }
    });
  }

  /// Сделать фото
  Future<void> _takePhoto() async {
    _setState(PhotoboothState.takingPhoto);
    _setMessage('Улыбайтесь! 📸');

    try {
      final imageBytes = await onTakePhoto?.call();
      
      if (imageBytes != null) {
        _photosInSession++;
        await _processPhoto(imageBytes);
      } else {
        _handleError('Не удалось сделать фото');
      }
    } catch (e) {
      _handleError('Ошибка при съемке: $e');
    }
  }

  /// Обработать фото
  Future<void> _processPhoto(Uint8List imageBytes) async {
    _setState(PhotoboothState.processing);
    _setMessage('Обрабатываем фото...');

    try {
      // Уведомляем UI о новом фото
      await onPhotoTaken?.call(imageBytes);

      if (_settings.autoPrint) {
        await _printPhoto(imageBytes);
      } else {
        await _completeSession();
      }
    } catch (e) {
      _handleError('Ошибка обработки фото: $e');
    }
  }

  /// Напечатать фото
  Future<void> _printPhoto(Uint8List imageBytes) async {
    _setState(PhotoboothState.printing);
    _setMessage('Печатаем фото...');

    try {
      await PrintService().quickPrint(imageBytes);
      await _completeSession();
    } catch (e) {
      _handleError('Ошибка печати: $e');
    }
  }

  /// Завершить сессию
  Future<void> _completeSession() async {
    _setState(PhotoboothState.completed);
    _setMessage('Готово! Заберите ваше фото 📷');

    onSessionCompleted?.call();

    if (_settings.autoRestart) {
      _timer = Timer(_settings.restartDelay, () {
        if (_isActive) _startSession();
      });
    } else {
      // Возвращаемся в режим ожидания
      _timer = Timer(const Duration(seconds: 5), () {
        if (_isActive) _setState(PhotoboothState.idle);
      });
    }
  }

  /// Обработать ошибку
  void _handleError(String error) {
    _setState(PhotoboothState.error);
    _setMessage('Ошибка: $error');
    onError?.call(error);

    // Автоматический перезапуск через 5 секунд
    _timer = Timer(const Duration(seconds: 5), () {
      if (_isActive && _settings.autoRestart) {
        _startSession();
      }
    });
  }

  /// Установить состояние
  void _setState(PhotoboothState state) {
    _currentState = state;
    _stateController.add(state);
  }

  /// Установить сообщение
  void _setMessage(String message) {
    _messageController.add(message);
  }

  /// Принудительно начать новую сессию
  void triggerNewSession() {
    _timer?.cancel();
    if (_isActive) {
      _startSession();
    }
  }

  /// Пропустить текущий этап
  void skipCurrentStage() {
    _timer?.cancel();
    
    switch (_currentState) {
      case PhotoboothState.instructions:
        _startCountdown();
        break;
      case PhotoboothState.countdown:
        _takePhoto();
        break;
      default:
        break;
    }
  }

  // Getters
  PhotoboothState get currentState => _currentState;
  PhotoboothSettings get settings => _settings;
  bool get isActive => _isActive;
  int get currentCountdown => _currentCountdown;
  int get photosInSession => _photosInSession;

  /// Обновить настройки
  void updateSettings(PhotoboothSettings newSettings) {
    _settings = newSettings;
  }

  /// Освободить ресурсы
  void dispose() {
    _timer?.cancel();
    _stateController.close();
    _countdownController.close();
    _messageController.close();
  }
}
