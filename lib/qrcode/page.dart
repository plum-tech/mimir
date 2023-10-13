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
      body: Container(
        color: context.isDarkMode ? Colors.white : null,
        child: QrImageView(
          data: data,
          version: QrVersions.auto,
          size: size,
        ),
      ),
    );
  }
}
