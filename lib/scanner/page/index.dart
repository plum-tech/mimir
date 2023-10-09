import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sit/design/adaptive/dialog.dart';
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
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    controller.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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

  Widget buildScanner() {
    return MobileScanner(
      controller: controller,
      fit: BoxFit.contain,
      onDetect: (captured) async {
        HapticFeedback.heavyImpact();
        final qrcode = captured.barcodes.firstOrNull;
        if (qrcode != null) {
          context.pop(qrcode.rawValue);
          // dispose the controller to stop scanning
          controller.dispose();
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
            context.showSnackBar(i18n.barcodeNotRecognized.text());
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
}
