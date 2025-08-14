import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/photobooth/services/print_service.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:analytics/analytics.dart';

/// Кнопка для печати фото
class PrintButton extends StatefulWidget {
  const PrintButton({
    required this.imageBytes,
    super.key,
    this.onPrintStarted,
    this.onPrintCompleted,
    this.onPrintError,
    this.showQuickPrint = true,
  });

  final Uint8List imageBytes;
  final VoidCallback? onPrintStarted;
  final VoidCallback? onPrintCompleted;
  final void Function(String error)? onPrintError;
  final bool showQuickPrint;

  @override
  State<PrintButton> createState() => _PrintButtonState();
}

class _PrintButtonState extends State<PrintButton> {
  final PrintService _printService = PrintService();
  bool _isPrinting = false;

  Future<void> _handlePrint() async {
    if (_isPrinting) return;

    setState(() => _isPrinting = true);
    widget.onPrintStarted?.call();

    try {
      trackEvent(
        category: 'button',
        action: 'click-print-photo',
        label: 'print-photo',
      );

      await _printService.quickPrint(widget.imageBytes);
      widget.onPrintCompleted?.call();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Фото отправлено на печать'),
            backgroundColor: PhotoboothColors.green,
          ),
        );
      }
    } catch (e) {
      widget.onPrintError?.call(e.toString());
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка печати: $e'),
            backgroundColor: PhotoboothColors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isPrinting = false);
      }
    }
  }

  Future<void> _showPrintOptions() async {
    final l10n = context.l10n;
    
    showAppModal<void>(
      context: context,
      landscapeChild: _PrintOptionsDialog(
        imageBytes: widget.imageBytes,
        onPrintStarted: widget.onPrintStarted,
        onPrintCompleted: widget.onPrintCompleted,
        onPrintError: widget.onPrintError,
      ),
      portraitChild: _PrintOptionsDialog(
        imageBytes: widget.imageBytes,
        onPrintStarted: widget.onPrintStarted,
        onPrintCompleted: widget.onPrintCompleted,
        onPrintError: widget.onPrintError,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    
    if (widget.showQuickPrint) {
      return ElevatedButton(
        onPressed: _isPrinting ? null : _handlePrint,
        style: ElevatedButton.styleFrom(
          backgroundColor: PhotoboothColors.green,
          foregroundColor: PhotoboothColors.white,
        ),
        child: _isPrinting
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(PhotoboothColors.white),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.print),
                  const SizedBox(width: 8),
                  Text(l10n.sharePagePrintButtonText ?? 'Печать'),
                ],
              ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: _isPrinting ? null : _handlePrint,
          style: ElevatedButton.styleFrom(
            backgroundColor: PhotoboothColors.green,
            foregroundColor: PhotoboothColors.white,
          ),
          child: _isPrinting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(PhotoboothColors.white),
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.print),
                    const SizedBox(width: 8),
                    Text(l10n.sharePagePrintButtonText ?? 'Печать'),
                  ],
                ),
        ),
        const SizedBox(width: 8),
        OutlinedButton(
          onPressed: _showPrintOptions,
          style: OutlinedButton.styleFrom(
            foregroundColor: PhotoboothColors.white,
            side: const BorderSide(color: PhotoboothColors.white),
          ),
          child: const Icon(Icons.settings),
        ),
      ],
    );
  }
}

/// Диалог с опциями печати
class _PrintOptionsDialog extends StatelessWidget {
  const _PrintOptionsDialog({
    required this.imageBytes,
    this.onPrintStarted,
    this.onPrintCompleted,
    this.onPrintError,
  });

  final Uint8List imageBytes;
  final VoidCallback? onPrintStarted;
  final VoidCallback? onPrintCompleted;
  final void Function(String error)? onPrintError;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: PhotoboothColors.whiteBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Настройки печати',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: PhotoboothColors.black,
            ),
          ),
          const SizedBox(height: 20),
          _buildPrintOption(
            context,
            'Быстрая печать',
            'Печать с настройками по умолчанию',
            Icons.flash_on,
            () => _quickPrint(context),
          ),
          const SizedBox(height: 12),
          _buildPrintOption(
            context,
            'Печать с настройками',
            'Выбор принтера и формата',
            Icons.settings,
            () => _printWithSettings(context),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Отмена'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPrintOption(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: PhotoboothColors.black.withOpacity(0.1)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: PhotoboothColors.blue),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: PhotoboothColors.black,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: PhotoboothColors.black.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _quickPrint(BuildContext context) async {
    Navigator.of(context).pop();
    onPrintStarted?.call();
    
    try {
      await PrintService().quickPrint(imageBytes);
      onPrintCompleted?.call();
    } catch (e) {
      onPrintError?.call(e.toString());
    }
  }

  Future<void> _printWithSettings(BuildContext context) async {
    Navigator.of(context).pop();
    onPrintStarted?.call();
    
    try {
      await PrintService().printPhotoWithSettings(imageBytes: imageBytes);
      onPrintCompleted?.call();
    } catch (e) {
      onPrintError?.call(e.toString());
    }
  }
}
