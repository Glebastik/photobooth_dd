import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/landing/landing.dart';
import 'package:io_photobooth/widgets/language_selector.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:photos_repository/photos_repository.dart';

/// Локализованное приложение с поддержкой переключения языков
class LocalizedApp extends StatefulWidget {
  const LocalizedApp({
    required this.authenticationRepository,
    required this.photosRepository,
    super.key,
  });

  final AuthenticationRepository authenticationRepository;
  final PhotosRepository photosRepository;

  @override
  State<LocalizedApp> createState() => _LocalizedAppState();
}

class _LocalizedAppState extends State<LocalizedApp> {
  Locale _currentLocale = const Locale('ru'); // По умолчанию русский

  void _changeLocale(Locale locale) {
    setState(() {
      _currentLocale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: widget.authenticationRepository),
        RepositoryProvider.value(value: widget.photosRepository),
      ],
      child: AnimatedFadeIn(
        child: ResponsiveLayoutBuilder(
          small: (_, __) => _LocalizedMaterialApp(
            theme: PhotoboothTheme.small,
            locale: _currentLocale,
            onLocaleChanged: _changeLocale,
          ),
          medium: (_, __) => _LocalizedMaterialApp(
            theme: PhotoboothTheme.medium,
            locale: _currentLocale,
            onLocaleChanged: _changeLocale,
          ),
          large: (_, __) => _LocalizedMaterialApp(
            theme: PhotoboothTheme.standard,
            locale: _currentLocale,
            onLocaleChanged: _changeLocale,
          ),
        ),
      ),
    );
  }
}

class _LocalizedMaterialApp extends StatelessWidget {
  const _LocalizedMaterialApp({
    required this.theme,
    required this.locale,
    required this.onLocaleChanged,
  });

  final ThemeData theme;
  final Locale locale;
  final Function(Locale) onLocaleChanged;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Фотобудка / Photo Booth',
      theme: theme,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ru'),
      ],
      home: LandingPageWithLanguageSelector(
        onLocaleChanged: onLocaleChanged,
        currentLocale: locale,
      ),
    );
  }
}

/// Главная страница с селектором языка
class LandingPageWithLanguageSelector extends StatelessWidget {
  const LandingPageWithLanguageSelector({
    required this.onLocaleChanged,
    required this.currentLocale,
    super.key,
  });

  final Function(Locale) onLocaleChanged;
  final Locale currentLocale;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PhotoboothColors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: LanguageSelector(
              currentLocale: currentLocale,
              onLocaleChanged: onLocaleChanged,
            ),
          ),
        ],
      ),
      body: const LandingView(),
    );
  }
}
