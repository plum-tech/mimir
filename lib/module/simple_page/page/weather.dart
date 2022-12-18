import 'package:flutter/material.dart';

import '../using.dart';

const String _ventuskyUrl = 'https://www.ventusky.com/?p=31.046;121.773;10&l=rain-1h';

String _getWeatherUrl(int campus) {
  String location = WeatherCode.from(campus: campus);
  return 'https://widget-page.qweather.net/h5/index.html?md=0123456&bg=1&lc=$location&key=f96261862c08497c90c0dea53467f511';
}

class WeatherPage extends StatefulWidget {
  final int campus;
  final String? title;

  const WeatherPage(this.campus, {this.title, super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  bool simple = true;
  late WebViewController controller;

  @override
  Widget build(BuildContext context) {
    final url = _getWeatherUrl(widget.campus);
    return SimpleWebViewPage(
      initialUrl: url,
      fixedTitle: widget.title ?? i18n.weather,
      onWebViewCreated: (controller) {
        this.controller = controller;
      },
      otherActions: [
        IconButton(
          onPressed: () {
            simple = !simple;
            if (simple) {
              controller.loadUrl(url);
            } else {
              controller.loadUrl(_ventuskyUrl);
            }
          },
          icon: const Icon(Icons.swap_horiz),
        ),
      ],
    );
  }
}
