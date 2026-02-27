/// App initialization and bootstrap logic.
///
/// This file handles all initialization that must happen before
/// the app starts, including:
/// - Hive database initialization
/// - System UI configuration
/// - Data migration from legacy storage
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'features/history/data/models/focus_session_model.dart';
import 'core/constants/storage_keys.dart';

/// Bootstraps the application by initializing all required services.
///
/// This should be called in [main] before [runApp].
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Hive for local storage
  await _initializeHive();

  // Configure system UI
  await _configureSystemUI();
}

/// Initializes Hive and opens required boxes.
Future<void> _initializeHive() async {
  await Hive.initFlutter();

  // Register type adapters
  Hive.registerAdapter(FocusSessionModelAdapter());

  // Open boxes
  await Future.wait([
    Hive.openBox(HiveBoxes.userProfile),
    Hive.openBox(HiveBoxes.appConfig),
    Hive.openBox(HiveBoxes.shopData),
    Hive.openBox(HiveBoxes.timerState),
    Hive.openBox<FocusSessionModel>(HiveBoxes.focusSessions),
    Hive.openBox(HiveBoxes.dailyStats),
  ]);
}

/// Configures system UI overlays and orientations.
Future<void> _configureSystemUI() async {
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

/// Closes all Hive boxes. Call this when the app is disposed.
Future<void> closeHive() async {
  await Hive.close();
}
