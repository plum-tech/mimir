import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';
import 'package:mimir/design/adaptive/dialog.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:rettulf/rettulf.dart';
import 'package:mimir/design/adaptive/multiplatform.dart';
import 'package:mimir/files.dart';
import 'package:mimir/utils/error.dart';
import 'package:mimir/utils/images.dart';
import 'package:mimir/utils/permission.dart';
import 'package:universal_platform/universal_platform.dart';

import '../i18n.dart';
import '../widget/overlay.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> with WidgetsBindingObserver {
  final controller = MobileScannerController(
    torchEnabled: false,
    formats: [BarcodeFormat.qrCode],
    facing: CameraFacing.back,
  );
  StreamSubscription<Object?>? _subscription;
  bool isReturned = false;
  bool isPermissionGranted = !UniversalPlatform.isAndroid;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // Start listening to lifecycle changes.
    WidgetsBinding.instance.addObserver(this);

    // Start listening to the barcode events.
    _subscription = controller.barcodes.listen(_handleBarcode);

    // Finally, start the scanner itself.
    unawaited(startCamera());
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // Stop listening to lifecycle changes.
    WidgetsBinding.instance.removeObserver(this);
    // Stop listening to the barcode events.
    unawaited(_subscription?.cancel());
    _subscription = null;
    // Dispose the widget itself.
    super.dispose();
    // Finally, dispose of the controller.
    unawaited(controller.dispose());
  }

  Future<void> startCamera() async {
    final granted = await requestPermission(context, Permission.camera);
    if (!mounted) return;
    setState(() {
      isPermissionGranted = granted;
    });
    if (!granted) return;
    try {
      await controller.start();
    } catch (error, stackTrace) {
      debugPrintError(error, stackTrace);
      if (error is MobileScannerException && error.errorCode == MobileScannerErrorCode.permissionDenied) {
        if (!mounted) return;
        await showPermissionDeniedDialog(context, Permission.camera);
      }
    }
  }

  Future<void> _handleBarcode(BarcodeCapture capture) async {
    if (kDebugMode) {
      print("Recognized: ${capture.barcodes.map((code) => code.rawValue)}");
    }

    /// prevent accidentally multiple pop.
    if (!context.mounted || isReturned) return;

    final qrcode = capture.barcodes.firstOrNull;
    if (qrcode != null) {
      isReturned = true;
      context.pop(qrcode.rawValue);
      await HapticFeedback.heavyImpact();
    }
  }

  Future<void> recognizeFromFile() async {
    final picker = ImagePicker();
    await requestPermission(context, Permission.photos);
    // Pick an image
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    // try fix: https://github.com/juliansteenbakker/mobile_scanner/issues/849
    var path = image.path;
    if (UniversalPlatform.isIOS) {
      final intermediate = Files.temp.subFile("scanned_image${p.extension(path)}");
      copyCompressedImageToTarget(source: File(image.path), target: intermediate.path);
      path = intermediate.path;
    }
    final result = await controller.analyzeImage(path);
    if (result != null) {
      await _handleBarcode(result);
    } else {
      if (!mounted) return;
      context.showSnackBar(content: i18n.noQrCodeRecognizedTip.text());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: [
        if (isPermissionGranted) buildScanner(),
        const QRScannerOverlay(
          overlayColour: Colors.black26,
        ),
      ].stack(),
      persistentFooterButtons: [
        buildTorchButton(),
        buildSwitchButton(),
        if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS) buildScanImageButton(),
      ],
    );
  }

  Widget buildScanner() {
    return MobileScanner(
      controller: controller,
      fit: BoxFit.contain,
    );
  }

  Widget buildScanImageButton() {
    return PlatformIconButton(
      icon: const Icon(Icons.image),
      onPressed: recognizeFromFile,
    );
  }

  Widget buildSwitchButton() {
    return PlatformIconButton(
      icon: Icon(context.icons.switchCamera),
      onPressed: () => controller.switchCamera(),
    );
  }

  Widget buildTorchButton() {
    return controller >>
        (context, state) => switch (state.torchState) {
              TorchState.off => PlatformIconButton(
                  icon: const Icon(Icons.flash_off),
                  onPressed: controller.toggleTorch,
                ),
              TorchState.on => PlatformIconButton(
                  icon: const Icon(Icons.flash_on, color: Colors.yellow),
                  onPressed: controller.toggleTorch,
                ),
              TorchState.unavailable => PlatformIconButton(
                  icon: const Icon(Icons.flash_off),
                ),
              TorchState.auto => PlatformIconButton(
                  icon: const Icon(Icons.flash_on),
                  onPressed: controller.toggleTorch,
                ),
            };
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
        // Restart the scanner when the app is resumed.
        // Don't forget to resume listening to the barcode events.
        _subscription = controller.barcodes.listen(_handleBarcode);

        unawaited(controller.start());
      case AppLifecycleState.inactive:
        // Stop the scanner when the app is paused.
        // Also stop the barcode events subscription.
        unawaited(_subscription?.cancel());
        _subscription = null;
        unawaited(controller.stop());
    }
  }
}
