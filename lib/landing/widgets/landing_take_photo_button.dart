import 'package:analytics/analytics.dart';
import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/photobooth/widgets/enhanced_photobooth.dart';
import 'package:io_photobooth/services/camera_service.dart';
import 'package:io_photobooth/services/printer_service.dart';

class LandingTakePhotoButton extends StatelessWidget {
  const LandingTakePhotoButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ElevatedButton(
      onPressed: () {
        trackEvent(
          category: 'button',
          action: 'click-start-photobooth',
          label: 'start-photobooth',
        );
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EnhancedPhotobooth(
              cameraService: CameraService(),
              printerService: PrinterService(),
            ),
          ),
        );
      },
      child: Text(l10n.landingPageTakePhotoButtonText),
    );
  }
}
