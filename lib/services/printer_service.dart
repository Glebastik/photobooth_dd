// Условные импорты для кроссплатформенности
// На веб-платформе используется printer_service_web.dart
// На desktop платформах (Linux, Windows, macOS) используется printer_service_desktop.dart
export 'printer_service_web.dart' if (dart.library.io) 'printer_service_desktop.dart';
