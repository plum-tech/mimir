import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/utils/error.dart';
import 'package:sit/utils/permission.dart';

import '../i18n.dart';
import '../widgets/overlay.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

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
    startCamera();
  }

  Future<void> startCamera() async {
    try {
      await controller.start();
    } catch (error, stackTrace) {
      debugPrintError(error, stackTrace);
      if (error is MobileScannerException && error.errorCode == MobileScannerErrorCode.permissionDenied) {
        if (!mounted) return;
        await showPermissionDeniedDialog(context: context, permission: Permission.camera);
      }
    }
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
      ].stack(),
      bottomNavigationBar: buildControllerView(),
    );
  }

  Widget buildScanner() {
    return MobileScanner(
      controller: controller,
      fit: BoxFit.contain,
      onDetect: (captured) async {
        final qrcode = captured.barcodes.firstOrNull;
        if (qrcode != null) {
          context.pop(qrcode.rawValue);
          // dispose the controller to stop scanning
          controller.dispose();
          await HapticFeedback.heavyImpact();
        }
      },
    );
  }

  Widget buildControllerView() {
    return [
      buildTorchButton(),
      buildSwitchButton(),
      buildImagePicker(),
    ].row(
      caa: CrossAxisAlignment.center,
      maa: MainAxisAlignment.spaceEvenly,
    );
  }

  Widget buildImagePicker() {
    return PlatformIconButton(
      icon: const Icon(Icons.image),
      onPressed: () async {
        final ImagePicker picker = ImagePicker();
        // Pick an image
        final XFile? image = await picker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          if (!await controller.analyzeImage(image.path)) {
            if (!mounted) return;
            context.showSnackBar(content: i18n.barcodeNotRecognized.text());
          }
        }
      },
    );
  }

  Widget buildSwitchButton() {
    return PlatformIconButton(
      icon: Icon(context.icons.switchCamera),
      onPressed: () => controller.switchCamera(),
    );
  }

  Widget buildTorchButton() {
    return PlatformIconButton(
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
