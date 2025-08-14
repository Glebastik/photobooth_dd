import 'dart:typed_data';

/// Тип камеры
enum CameraType {
  front,
  back,
  external,
  builtin,
}

/// Устройство камеры
class CameraDevice {
  final String deviceId;
  final String label;
  final CameraType type;

  const CameraDevice(this.deviceId, this.label, this.type);

  @override
  String toString() => 'CameraDevice(id: $deviceId, label: $label, type: $type)';
}

/// Настройки камеры
class CameraSettings {
  final int width;
  final int height;
  final int quality;
  final bool enableFlash;
  final String? frameStyle;
  final Map<String, dynamic>? effects;
  final bool addFrame;
  final double brightness;
  final double contrast;
  final String? watermark;

  const CameraSettings({
    this.width = 1920,
    this.height = 1080,
    this.quality = 90,
    this.enableFlash = false,
    this.frameStyle,
    this.effects,
    this.addFrame = false,
    this.brightness = 0.5,
    this.contrast = 0.5,
    this.watermark,
  });

  CameraSettings copyWith({
    int? width,
    int? height,
    int? quality,
    bool? enableFlash,
    String? frameStyle,
    Map<String, dynamic>? effects,
    bool? addFrame,
    double? brightness,
    double? contrast,
    String? watermark,
  }) {
    return CameraSettings(
      width: width ?? this.width,
      height: height ?? this.height,
      quality: quality ?? this.quality,
      enableFlash: enableFlash ?? this.enableFlash,
      frameStyle: frameStyle ?? this.frameStyle,
      effects: effects ?? this.effects,
      addFrame: addFrame ?? this.addFrame,
      brightness: brightness ?? this.brightness,
      contrast: contrast ?? this.contrast,
      watermark: watermark ?? this.watermark,
    );
  }
}

/// Устройство принтера
class PrinterDevice {
  final String name;
  final String? description;
  final bool isDefault;
  final Map<String, dynamic>? capabilities;

  const PrinterDevice({
    required this.name,
    this.description,
    this.isDefault = false,
    this.capabilities,
  });

  @override
  String toString() => 'PrinterDevice(name: $name, default: $isDefault)';
}

/// Настройки печати
class PrintSettings {
  final String paperSize;
  final String orientation;
  final int copies;
  final bool colorMode;
  final int quality;
  final Map<String, dynamic>? advanced;

  const PrintSettings({
    this.paperSize = 'A4',
    this.orientation = 'portrait',
    this.copies = 1,
    this.colorMode = true,
    this.quality = 300,
    this.advanced,
  });

  PrintSettings copyWith({
    String? paperSize,
    String? orientation,
    int? copies,
    bool? colorMode,
    int? quality,
    Map<String, dynamic>? advanced,
  }) {
    return PrintSettings(
      paperSize: paperSize ?? this.paperSize,
      orientation: orientation ?? this.orientation,
      copies: copies ?? this.copies,
      colorMode: colorMode ?? this.colorMode,
      quality: quality ?? this.quality,
      advanced: advanced ?? this.advanced,
    );
  }
}
