// Условные импорты для кроссплатформенности
// На веб-платформе используется camera_service_web.dart
// На desktop платформах (Linux, Windows, macOS) используется camera_service_desktop.dart
export 'camera_service_web.dart' if (dart.library.io) 'camera_service_desktop.dart';
