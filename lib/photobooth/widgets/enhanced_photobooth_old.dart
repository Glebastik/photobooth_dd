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

/// Улучшенная фотобудка с поддержкой внешних камер и принтеров
class EnhancedPhotobooth extends StatefulWidget {
  const EnhancedPhotobooth({super.key});

  @override
  State<EnhancedPhotobooth> createState() => _EnhancedPhotoboothState();
}

class _EnhancedPhotoboothState extends State<EnhancedPhotobooth> {
  final CameraService _cameraService = CameraService();
  final PrinterService _printerService = PrinterService();
  
  bool _isFullscreen = false;
  bool _isAutoMode = false;
  bool _isInitialized = false;
  bool _isInitializing = false;
  bool _isCountingDown = false;
  int _countdown = 0;
  int _delaySeconds = 10;
  Timer? _timer;
  Timer? _autoModeTimer;
  String _message = '';
  Uint8List? _lastPhoto;
  
  List<CameraDevice> _availableCameras = [];
  List<PrinterDevice> _availablePrinters = [];
  CameraSettings _cameraSettings = const CameraSettings();
  PrintSettings _printSettings = const PrintSettings();
  
  int _autoModeDelay = 10; // секунд между автоматическими фото

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized && !_isInitializing) {
      _initializeServices();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _autoModeTimer?.cancel();
    _cameraService.stopCamera();
    super.dispose();
  }

  /// Инициализировать камеру и принтер
  Future<void> _initializeServices() async {
    if (_isInitializing || _isInitialized) {
      debugPrint('⚠️ Инициализация уже выполняется или завершена, пропускаем...');
      return;
    }
    
    _isInitializing = true;
    debugPrint('=== 🚀 Начинаем инициализацию сервисов ===');
    
    try {
      final l10n = AppLocalizations.of(context);
      
      // Сначала получаем список принтеров (они не требуют разрешений)
      debugPrint('🖨️ Получаем список принтеров...');
      _availablePrinters = await _printerService.getAvailablePrinters();
      debugPrint('✅ Найдено принтеров: ${_availablePrinters.length}');
      debugPrint('🖨️ Список принтеров: ${_availablePrinters.join(", ")}');
      
      if (_availablePrinters.isNotEmpty) {
        _printerService.selectPrinter(_availablePrinters.first);
        debugPrint('✅ Выбран принтер: ${_availablePrinters.first}');
      }

      // Теперь работаем с камерами
      debugPrint('📷 Запрашиваем разрешения на камеру...');
      final hasPermission = await _cameraService.requestCameraPermission();
      debugPrint('📷 Разрешение на камеру: $hasPermission');
      
      if (!hasPermission) {
        debugPrint('❌ Разрешение на камеру отклонено');
        setState(() {
          _isInitialized = true;
          _message = 'Принтеры готовы. Для камеры нужно разрешение.';
        });
        return;
      }

      // Получаем список камер ПОСЛЕ получения разрешения
      debugPrint('📷 Получаем список камер...');
      _availableCameras = await _cameraService.getAvailableCameras();
      debugPrint('📷 Найдено камер: ${_availableCameras.length}');
      debugPrint('📷 Список камер: ${_availableCameras.map((c) => c.label).join(", ")}');
      
      if (_availableCameras.isEmpty) {
        debugPrint('⚠️ Камеры не найдены');
        if (mounted) {
          setState(() {
            _isInitialized = true;
            _message = 'Принтеры готовы, но камеры не найдены';
          });
        }
        return;
      }

      // Выбираем первую доступную камеру
      debugPrint('📷 Выбираем камеру: ${_availableCameras.first.label}');
      try {
        final success = await _cameraService.selectCamera(_availableCameras.first.deviceId);
        debugPrint('📷 Камера выбрана успешно: $success');
        
        if (!success) {
          debugPrint('❌ Не удалось выбрать камеру');
          if (mounted) {
            setState(() {
              _isInitialized = true;
              _message = 'Принтеры готовы, но камера не работает';
            });
          }
          return;
        }
      } catch (e) {
        debugPrint('❌ Ошибка при выборе камеры: $e');
        if (mounted) {
          setState(() {
            _isInitialized = true;
            _message = 'Ошибка инициализации камеры: $e';
          });
        }
        return;
      }

      if (mounted) {
        setState(() {
          _isInitialized = true;
          _message = l10n?.photoboothWelcomeText ?? 'Ready to take photos!';
        });
      }
      
      debugPrint('📷 UI состояние: камер=${_availableCameras.length}, принтеров=${_availablePrinters.length}');
      
      debugPrint('=== ✅ Инициализация завершена успешно ===');
    } catch (e) {
      debugPrint('❌ Критическая ошибка инициализации: $e');
      if (mounted) {
        setState(() {
          _isInitialized = true;
          _message = 'Ошибка инициализации: $e';
        });
      }
    } finally {
      _isInitializing = false;
    }
  }

  /// Установить сообщение
  void _setMessage(String message) {
    if (mounted) {
      setState(() => _message = message);
    }
  }

  /// Обновить список устройств
  Future<void> refreshDevices() async {
    debugPrint('🔄 Принудительное обновление списка устройств...');
    
    try {
      // Обновляем список камер
      _availableCameras = await _cameraService.getAvailableCameras();
      
      // Обновляем список принтеров
      _availablePrinters = await _printerService.getAvailablePrinters();
      
      // Если есть камеры и ни одна не выбрана, выбираем первую
      if (_availableCameras.isNotEmpty && _cameraService.selectedCamera == null) {
        debugPrint('📷 Автоматически выбираем первую камеру: ${_availableCameras.first.label}');
        await _cameraService.selectCamera(_availableCameras.first.deviceId);
      }
      
      // Если есть принтеры и ни один не выбран, выбираем первый
      if (_availablePrinters.isNotEmpty && _printerService.selectedPrinter == null) {
        debugPrint('🖨️ Автоматически выбираем первый принтер: ${_availablePrinters.first}');
        _printerService.selectPrinter(_availablePrinters.first);
      }
      
      if (mounted) {
        setState(() {
          _isInitialized = true;
          _message = _availableCameras.isEmpty ? 
            'Принтеры готовы, но камеры не найдены' : 
            'Устройства обновлены и готовы к работе';
        });
      }
      
      debugPrint('✅ Обновление устройств завершено');
    } catch (e) {
      debugPrint('❌ Ошибка обновления устройств: $e');
      _setMessage('Ошибка обновления устройств: $e');
    }
  }

  /// Переключить полноэкранный режим
  void _toggleFullscreen() {
    try {
      if (kIsWeb) {
        // Веб-версия: используем JavaScript API
        if (_isFullscreen) {
          // html.document.exitFullscreen(); // Будет работать только на веб
        } else {
          // html.document.documentElement?.requestFullscreen(); // Будет работать только на веб
        }
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
      _showSnackBar('Полноэкранный режим недоступен');
    }
  }

  /// Начать автоматический режим
  void _startAutoMode() {
    final l10n = context.l10n;
    setState(() {
      _isAutoMode = true;
      _message = l10n.photoboothAutoModeOnText;
    });
    _scheduleAutoPhoto();
  }

  /// Остановить автоматический режим
  void _stopAutoMode() {
    final l10n = context.l10n;
    _autoModeTimer?.cancel();
    setState(() {
      _isAutoMode = false;
      _message = l10n.photoboothAutoModeOffText;
    });
  }

  /// Запланировать автоматическое фото
  void _scheduleAutoPhoto() {
    _autoModeTimer?.cancel();
    _autoModeTimer = Timer(Duration(seconds: _autoModeDelay), () {
      if (_isAutoMode && !_isCountingDown) {
        _takePhoto();
      }
    });
  }

  /// Сделать фото
  Future<void> _takePhoto() async {
    if (!_isInitialized || _isCountingDown) return;

    final l10n = context.l10n;
    
    if (mounted) {
      setState(() => _isCountingDown = true);
    }
    
    // Обратный отсчет
    for (int i = 3; i > 0; i--) {
      if (mounted) {
        setState(() {
          _countdown = i;
          _message = l10n.photoboothCountdownText(i);
        });
      }
      await Future.delayed(const Duration(seconds: 1));
    }

    // Показываем "Улыбайтесь!"
    if (mounted) {
      setState(() => _message = l10n.photoboothSmileText);
    }
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      // Делаем фото
      final photoData = await _cameraService.takePhoto(settings: _cameraSettings);
      
      if (photoData != null) {
        if (mounted) {
          setState(() {
            _lastPhoto = photoData;
            _message = l10n.photoboothPhotoReadyText;
            _isCountingDown = false;
          });
        }

        // Если включен автоматический режим, планируем следующее фото
        if (_isAutoMode) {
          _scheduleAutoPhoto();
        }
      } else {
        throw Exception('Не удалось сделать фото');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _message = '${l10n.cameraGenericErrorText}: $e';
          _isCountingDown = false;
        });
      }
    }
  }

  /// Печать фото
  Future<void> _printPhoto() async {
    if (_lastPhoto == null) return;

    final l10n = context.l10n;
    
    try {
      final success = await _printerService.printImage(
        _lastPhoto!,
        settings: _printSettings,
      );
      
      if (success) {
        _setMessage(l10n.photoboothPrintSentText);
      } else {
        _setMessage(l10n.printerErrorText);
      }
    } catch (e) {
      _setMessage('${l10n.printerErrorText}: $e');
    }
  }

  /// Показать настройки
  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => _SettingsDialog(
        availableCameras: _availableCameras,
        availablePrinters: _availablePrinters,
        cameraService: _cameraService,
        printerService: _printerService,
        cameraSettings: _cameraSettings,
        printSettings: _printSettings,
        autoModeDelay: _autoModeDelay,
        onCameraSettingsChanged: (settings) {
          setState(() => _cameraSettings = settings);
        },
        onPrintSettingsChanged: (settings) {
          setState(() => _printSettings = settings);
        },
        onAutoModeDelayChanged: (delay) {
          setState(() => _autoModeDelay = delay);
        },
        onDevicesRefreshed: (cameras, printers) async {
          debugPrint('🔄 Обновляем устройства в главном виджете...');
          if (mounted) {
            setState(() {
              _availableCameras = cameras;
              _availablePrinters = printers;
            });
          }
          debugPrint('🔄 Устройства обновлены: камер=${cameras.length}, принтеров=${printers.length}');
        },
      ),
    );
  }

  /// Показать SnackBar
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Предварительный просмотр камеры
          if (_isInitialized && _cameraService.videoElement != null)
            Positioned.fill(
              child: Container(
                color: Colors.black,
                child: Center(
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green, width: 2),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Реальное видео с камеры
                        Transform.scale(
                          scaleX: -1, // Зеркальное отображение
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            child: HtmlElementView(
                              viewType: 'camera-video-preview',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          else if (_isInitialized)
            Positioned.fill(
              child: Container(
                color: Colors.grey[800],
                child: const Center(
                  child: Icon(
                    Icons.camera_alt,
                    size: 100,
                    color: Colors.white54,
                  ),
                ),
              ),
            ),
          
          // Оверлей с элементами управления
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.transparent,
                    Colors.black.withOpacity(0.5),
                  ],
                ),
              ),
              child: Column(
                children: [
                  // Верхняя панель
                  _buildTopBar(l10n),
                  
                  // Центральная область с сообщением
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 18),
                          ),

                          if (_countdown > 0) ...[
                            const SizedBox(height: 20),
                            Text(
                              '$_countdown',
                              style: const TextStyle(
                                fontSize: 72,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  
                  // Нижняя панель с кнопками
                  _buildBottomControls(l10n),
                ],
              ),
            ),
          ),
          
          // Превью последнего фото
          if (_lastPhoto != null)
            Positioned(
              top: 100,
              right: 20,
              child: _buildPhotoPreview(),
            ),
        ],
      ),
    );
  }

  /// Верхняя панель
  Widget _buildTopBar(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Кнопка настроек
          IconButton(
            onPressed: _showSettingsDialog,
            icon: const Icon(Icons.settings, color: Colors.white, size: 32),
            tooltip: l10n.settingsText,
          ),
          
          // Кнопка полноэкранного режима
          IconButton(
            onPressed: _toggleFullscreen,
            icon: Icon(
              _isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
              color: Colors.white,
              size: 32,
            ),
            tooltip: l10n.photoboothFullscreenButtonText,
          ),
        ],
      ),
    );
  }

  /// Нижняя панель с элементами управления
  Widget _buildBottomControls(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Кнопка автоматического режима
          ElevatedButton(
            onPressed: _isAutoMode ? _stopAutoMode : _startAutoMode,
            style: ElevatedButton.styleFrom(
              backgroundColor: _isAutoMode ? Colors.red : Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
            child: Text(
              _isAutoMode ? l10n.photoboothStopButtonText : l10n.photoboothAutoModeButtonText,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          
          // Кнопка съемки
          ElevatedButton(
            onPressed: _isInitialized && !_isCountingDown ? _takePhoto : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              shape: const CircleBorder(),
            ),
            child: const Icon(
              Icons.camera_alt,
              size: 40,
              color: Colors.white,
            ),
          ),
          
          // Кнопка печати
          ElevatedButton(
            onPressed: _lastPhoto != null ? _printPhoto : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
            child: Text(
              l10n.photoboothPrintButtonText,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  /// Превью последнего фото
  Widget _buildPhotoPreview() {
    return Container(
      width: 150,
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: Image.memory(
          _lastPhoto!,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

/// Диалог настроек
class _SettingsDialog extends StatefulWidget {
  final List<CameraDevice> availableCameras;
  final List<String> availablePrinters;
  final CameraService cameraService;
  final PrinterService printerService;
  final CameraSettings cameraSettings;
  final PrintSettings printSettings;
  final int autoModeDelay;
  final Function(CameraSettings) onCameraSettingsChanged;
  final Function(PrintSettings) onPrintSettingsChanged;
  final Function(int) onAutoModeDelayChanged;
  final Function(List<CameraDevice>, List<String>)? onDevicesRefreshed;

  const _SettingsDialog({
    required this.availableCameras,
    required this.availablePrinters,
    required this.cameraService,
    required this.printerService,
    required this.cameraSettings,
    required this.printSettings,
    required this.autoModeDelay,
    required this.onCameraSettingsChanged,
    required this.onPrintSettingsChanged,
    required this.onAutoModeDelayChanged,
    this.onDevicesRefreshed,
  });

  @override
  State<_SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<_SettingsDialog> {
  late CameraSettings _cameraSettings;
  late PrintSettings _printSettings;
  late int _autoModeDelay;

  @override
  void initState() {
    super.initState();
    _cameraSettings = widget.cameraSettings;
    _printSettings = widget.printSettings;
    _autoModeDelay = widget.autoModeDelay;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    
    return AlertDialog(
      title: Text(l10n.settingsText),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Выбор камеры
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l10n.selectCameraText, style: const TextStyle(fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () async {
                      debugPrint('🔄 Обновляем список устройств...');
                      
                      // Обновляем список камер и принтеров
                      final cameras = await widget.cameraService.getAvailableCameras();
                      final printers = await widget.printerService.getAvailablePrinters();
                      
                      debugPrint('🔄 Найдено камер: ${cameras.length}');
                      debugPrint('🔄 Найдено принтеров: ${printers.length}');
                      
                      // Вызываем callback для обновления родительского виджета
                      if (widget.onDevicesRefreshed != null) {
                        widget.onDevicesRefreshed!(cameras, printers);
                      }
                      
                      // Закрываем диалог
                      if (mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                    tooltip: 'Обновить устройства',
                  ),
                ],
              ),
              
              // Отладочная информация
              Text('Камер найдено: ${widget.availableCameras.length}', 
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
              
              DropdownButton<String>(
                value: widget.cameraService.selectedCamera?.deviceId,
                isExpanded: true,
                items: widget.availableCameras.map((camera) {
                  IconData cameraIcon;
                  String typeText;
                  
                  switch (camera.type) {
                    case CameraType.front:
                      cameraIcon = Icons.camera_front;
                      typeText = 'Передняя';
                      break;
                    case CameraType.back:
                      cameraIcon = Icons.camera_rear;
                      typeText = 'Задняя';
                      break;
                    case CameraType.external:
                      cameraIcon = Icons.videocam;
                      typeText = 'Внешняя';
                      break;
                    case CameraType.builtin:
                    default:
                      cameraIcon = Icons.camera_alt;
                      typeText = 'Встроенная';
                      break;
                  }
                  
                  return DropdownMenuItem(
                    value: camera.deviceId,
                    child: Row(
                      children: [
                        Icon(cameraIcon, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                camera.label,
                                style: const TextStyle(fontWeight: FontWeight.w500),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                typeText,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (deviceId) {
                  if (deviceId != null) {
                    widget.cameraService.selectCamera(deviceId);
                    setState(() {});
                  }
                },
              ),
              
              const SizedBox(height: 20),
              
              // Выбор принтера
              Text(l10n.selectPrinterText, style: const TextStyle(fontWeight: FontWeight.bold)),
              
              // Отладочная информация
              Text('Принтеров найдено: ${widget.availablePrinters.length}', 
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
              
              DropdownButton<String>(
                value: widget.printerService.selectedPrinter,
                isExpanded: true,
                items: widget.availablePrinters.map((printer) {
                  IconData printerIcon;
                  String typeText;
                  
                  if (printer.toLowerCase().contains('pdf')) {
                    printerIcon = Icons.picture_as_pdf;
                    typeText = 'PDF документ';
                  } else if (printer.toLowerCase().contains('факс')) {
                    printerIcon = Icons.fax;
                    typeText = 'Факс';
                  } else if (printer.toLowerCase().contains('onenote')) {
                    printerIcon = Icons.note;
                    typeText = 'Заметки';
                  } else if (printer.toLowerCase().contains('сетевые')) {
                    printerIcon = Icons.network_check;
                    typeText = 'Сетевой принтер';
                  } else {
                    printerIcon = Icons.print;
                    typeText = 'Физический принтер';
                  }
                  
                  return DropdownMenuItem(
                    value: printer,
                    child: Row(
                      children: [
                        Icon(printerIcon, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                printer,
                                style: const TextStyle(fontWeight: FontWeight.w500),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                typeText,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (printer) {
                  if (printer != null) {
                    widget.printerService.selectPrinter(printer);
                    setState(() {});
                  }
                },
              ),
              
              const SizedBox(height: 20),
              
              // Задержка автоматического режима
              Text(l10n.autoModeDelayText, style: const TextStyle(fontWeight: FontWeight.bold)),
              Slider(
                value: _autoModeDelay.toDouble(),
                min: 5,
                max: 60,
                divisions: 11,
                label: '$_autoModeDelay сек',
                onChanged: (value) {
                  setState(() {
                    _autoModeDelay = value.round();
                  });
                },
              ),
              Text('Текущая задержка: $_autoModeDelay секунд', 
                style: const TextStyle(fontSize: 14, color: Colors.grey)),
              
              const SizedBox(height: 20),
              
              // Настройки камеры
              Text(l10n.photoQualityText, style: const TextStyle(fontWeight: FontWeight.bold)),
              CheckboxListTile(
                title: const Text('Добавить рамку'),
                value: _cameraSettings.addFrame,
                onChanged: (value) {
                  setState(() {
                    _cameraSettings = CameraSettings(
                      width: _cameraSettings.width,
                      height: _cameraSettings.height,
                      brightness: _cameraSettings.brightness,
                      contrast: _cameraSettings.contrast,
                      addFrame: value ?? false,
                      watermark: _cameraSettings.watermark,
                      applyEffects: _cameraSettings.applyEffects,
                    );
                  });
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onCameraSettingsChanged(_cameraSettings);
            widget.onPrintSettingsChanged(_printSettings);
            widget.onAutoModeDelayChanged(_autoModeDelay);
            Navigator.of(context).pop();
          },
          child: const Text('Сохранить'),
        ),
      ],
    );
  }
}
