import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rettulf/rettulf.dart';

class QrCodePage extends StatelessWidget {
  final String data;
  final double? size;
  final Widget? title;

  const QrCodePage({
    super.key,
    required this.data,
    this.size,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: title,
      ),
      body: [
        Container(
          color: context.isDarkMode ? Colors.white : null,
          child: QrImageView(
            data: data,
            version: QrVersions.auto,
            size: size,
          ),
        ).padAll(20),
        RichText(
            text: TextSpan(children: [
          TextSpan(text: 'Please navigate to Me'),
          WidgetSpan(child: Icon(Icons.person)),
          TextSpan(text: ''),
          TextSpan(text: ', and click the scanner '),
          WidgetSpan(child: Icon(Icons.qr_code_scanner)),
          TextSpan(text: ' on the right corner.'),
        ])),
      ].column().padAll(10),
    );
  }
}
