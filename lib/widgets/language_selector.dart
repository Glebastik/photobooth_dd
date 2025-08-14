import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';

/// Виджет для выбора языка
class LanguageSelector extends StatelessWidget {
  final Locale currentLocale;
  final Function(Locale) onLocaleChanged;

  const LanguageSelector({
    super.key,
    required this.currentLocale,
    required this.onLocaleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Locale>(
      icon: const Icon(Icons.language, color: Colors.black54),
      tooltip: 'Выбрать язык / Select Language',
      onSelected: onLocaleChanged,
      itemBuilder: (context) => [
        PopupMenuItem(
          value: const Locale('en'),
          child: Row(
            children: [
              const Text('🇺🇸', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              const Text('English'),
              if (currentLocale.languageCode == 'en')
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(Icons.check, color: Colors.green, size: 16),
                ),
            ],
          ),
        ),
        PopupMenuItem(
          value: const Locale('ru'),
          child: Row(
            children: [
              const Text('🇷🇺', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              const Text('Русский'),
              if (currentLocale.languageCode == 'ru')
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(Icons.check, color: Colors.green, size: 16),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
