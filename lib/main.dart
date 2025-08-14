// ignore_for_file: avoid_print
import 'dart:async';
import 'dart:io';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photos_repository/photos_repository.dart';
import 'package:io_photobooth/app/app.dart';
import 'package:io_photobooth/app/app_bloc_observer.dart';
import 'package:io_photobooth/firebase_options.dart';
import 'package:io_photobooth/landing/loading_indicator_io.dart'
    if (dart.library.html) 'landing/loading_indicator_web.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();
  FlutterError.onError = (details) {
    print(details.exceptionAsString());
    print(details.stack);
  };
  // Инициализация Firebase только для поддерживаемых платформ
  if (!kIsWeb && !Platform.isLinux) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else if (kIsWeb) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  // Создание репозиториев с учетом платформы
  late final AuthenticationRepository authenticationRepository;
  late final PhotosRepository photosRepository;
  
  if (Platform.isLinux) {
    // Для Linux создаем заглушки без Firebase
    authenticationRepository = const AuthenticationRepository(
      firebaseAuth: null,
    );
    photosRepository = PhotosRepository(
      firebaseStorage: null,
    );
  } else {
    authenticationRepository = AuthenticationRepository(
      firebaseAuth: FirebaseAuth.instance,
    );
    photosRepository = PhotosRepository(
      firebaseStorage: FirebaseStorage.instance,
    );
  }

  if (!Platform.isLinux) {
    unawaited(
      authenticationRepository.signInAnonymously(),
    );
  }

  if (!Platform.isLinux) {
    unawaited(
      Future.wait([
        Flame.images.load('android_spritesheet.png'),
        Flame.images.load('dash_spritesheet.png'),
        Flame.images.load('dino_spritesheet.png'),
        Flame.images.load('sparky_spritesheet.png'),
        Flame.images.load('photo_frame_spritesheet_landscape.jpg'),
        Flame.images.load('photo_frame_spritesheet_portrait.png'),
        Flame.images.load('photo_indicator_spritesheet.png'),
      ]),
    );
  }

  runZonedGuarded(
    () => runApp(
      App(
        authenticationRepository: authenticationRepository,
        photosRepository: photosRepository,
      ),
    ),
    (error, stackTrace) {
      print(error);
      print(stackTrace);
    },
  );

  SchedulerBinding.instance.addPostFrameCallback(
    (_) => removeLoadingIndicator(),
  );
}
