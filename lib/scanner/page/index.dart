import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mimir/design/widgets/dialog.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:rettulf/rettulf.dart';

import '../i18n.dart';
import '../widgets/overlay.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

const _iconSize = 32.0;

class _ScannerPageState extends State<ScannerPage> with SingleTickerProviderStateMixin {
  final controller = MobileScannerController(
    torchEnabled: false,
    formats: [BarcodeFormat.qrCode],
    facing: CameraFacing.back,
  );

  Widget buildImagePicker() {
    return IconButton(
      icon: const Icon(Icons.image),
      iconSize: _iconSize,
      onPressed: () async {
        final ImagePicker picker = ImagePicker();
        // Pick an image
        final XFile? image = await picker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          if (!await controller.analyzeImage(image.path)) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: i18n.barcodeNotRecognized.text(),
              backgroundColor: Colors.redAccent,
            ));
          }
        }
      },
    );
  }

  Widget buildSwitchButton() {
    return IconButton(
      iconSize: _iconSize,
      icon: controller.cameraFacingState >>
          (context, state) {
            switch (state) {
              case CameraFacing.front:
                return const Icon(Icons.camera_front);
              case CameraFacing.back:
                return const Icon(Icons.camera_rear);
            }
          },
      onPressed: () => controller.switchCamera(),
    );
  }

  Widget buildTorchButton() {
    return IconButton(
      iconSize: _iconSize,
      icon: controller.torchState >>
          (context, state) {
            switch (state) {
              case TorchState.off:
                return const Icon(Icons.flash_off, color: Colors.grey);
              case TorchState.on:
                return const Icon(Icons.flash_on, color: Colors.yellow);
            }
          },
      onPressed: () => controller.toggleTorch(),
    );
  }

  Widget buildScanner() {
    return MobileScanner(
      controller: controller,
      fit: BoxFit.contain,
      onDetect: (captured) async {
        controller.dispose();
        HapticFeedback.heavyImpact();
        final qrcode = captured.barcodes.firstOrNull;
        if (qrcode != null) {
          await context.showTip(title: "Result", desc: qrcode.rawValue.toString(), ok: "OK");
          Navigator.pop(context, qrcode.rawValue);
        }
      },
    );
  }

  Widget buildControllerView() {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildTorchButton(),
          buildSwitchButton(),
          buildImagePicker(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        buildScanner(),
        const QRScannerOverlay(
          overlayColour: Colors.black26,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: buildControllerView(),
        ),
      ].stack(),
    );
  }
}
