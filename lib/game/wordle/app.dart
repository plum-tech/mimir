import 'dart:ui';

import 'package:flutter/material.dart';
import 'event_bus.dart';
import 'page/home.dart';

class WordleApp extends StatefulWidget {
  const WordleApp({
    super.key,
  });

  @override
  State<WordleApp> createState() => _WordleAppState();
}

class _WordleAppState extends State<WordleApp> {
  var brightness = Brightness.light;

  void _onThemeChange(dynamic args) {
    setState(() {
      brightness = brightness == Brightness.light ? Brightness.dark : Brightness.light;
    });
  }

  @override
  void initState() {
    super.initState();
    //loadSettings();
    mainBus.on(event: "ToggleTheme", onEvent: _onThemeChange);
  }

  @override
  void dispose() {
    mainBus.off(event: "ToggleTheme", callBack: _onThemeChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.trackpad,
          PointerDeviceKind.unknown
        },
      ),
      title: 'Wordle',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        brightness: brightness,
      ),
      routes: {
        "/": (context) => const HomePage(),
        "/game": (context) => const HomePage(),
      },
      initialRoute: "/",
    );
  }
}
