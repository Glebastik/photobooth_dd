import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/landing/landing.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/app/localized_app.dart';

import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:photos_repository/photos_repository.dart';

class App extends StatelessWidget {
  const App({
    required this.authenticationRepository,
    required this.photosRepository,
    super.key,
  });

  final AuthenticationRepository authenticationRepository;
  final PhotosRepository photosRepository;

  @override
  Widget build(BuildContext context) {
    return LocalizedApp(
      authenticationRepository: authenticationRepository,
      photosRepository: photosRepository,
    );
  }
}

class _App extends StatelessWidget {
  const _App({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'I/O Photo Booth',
      theme: theme,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const LandingPage(),
      routes: {

      },
    );
  }
}
