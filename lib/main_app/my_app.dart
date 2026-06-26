import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:than_reader/core/utils/app_theme.dart';
import 'package:than_reader/main_app/home/home_screen.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    appThemeTypeNotifier.addListener(onThemeChanged);
    super.initState();
    onThemeChanged();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void onThemeChanged() {
    brightness = AppThemeType.isDarkMode ? .dark : .light;
    if (!mounted) return;
    setState(() {});
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    onThemeChanged();
  }

  Brightness brightness = PlatformDispatcher.instance.platformBrightness;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: currentThemeData,
      home: HomeScreen(),
    );
  }

  ThemeData get currentThemeData {
    if (brightness == .dark) {
      return ThemeData.dark();
    }
    return ThemeData.light();
  }
}
