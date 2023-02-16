import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:rettulf/rettulf.dart';

import '../using.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> with SingleTickerProviderStateMixin {
  String? barcode;

  MobileScannerController controller = MobileScannerController(
    torchEnabled: false,
    formats: [BarcodeFormat.qrCode],
    facing: CameraFacing.back,
  );

  bool isStarted = true;

  Widget buildImagePicker() {
    return IconButton(
      color: Colors.white,
      icon: const Icon(Icons.image),
      iconSize: 32.0,
      onPressed: () async {
        final ImagePicker picker = ImagePicker();
        // Pick an image
        final XFile? image = await picker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          if (await controller.analyzeImage(image.path)) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: i18n.barcodeRecognized.text(),
              backgroundColor: Colors.green,
            ));
          } else {
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
      color: Colors.white,
      icon: ValueListenableBuilder(
        valueListenable: controller.cameraFacingState,
        builder: (context, state, child) {
          switch (state) {
            case CameraFacing.front:
              return const Icon(Icons.camera_front);
            case CameraFacing.back:
              return const Icon(Icons.camera_rear);
          }
        },
      ),
      iconSize: 32.0,
      onPressed: () => controller.switchCamera(),
    );
  }

  Widget buildTorchButton() {
    return IconButton(
      color: Colors.white,
      icon: ValueListenableBuilder(
        valueListenable: controller.torchState,
        builder: (context, state, child) {
          switch (state) {
            case TorchState.off:
              return const Icon(Icons.flash_off, color: Colors.grey);
            case TorchState.on:
              return const Icon(Icons.flash_on, color: Colors.yellow);
          }
        },
      ),
      iconSize: 32.0,
      onPressed: () => controller.toggleTorch(),
    );
  }

  Widget buildStopButton() {
    return IconButton(
      color: Colors.white,
      icon: isStarted ? const Icon(Icons.stop) : const Icon(Icons.play_arrow),
      iconSize: 32.0,
      onPressed: () => setState(() {
        isStarted ? controller.stop() : controller.start();
        isStarted = !isStarted;
      }),
    );
  }

  Widget buildScanner() {
    return MobileScanner(
      controller: controller,
      fit: BoxFit.contain,
      onDetect: (barcode, args) {
        controller.dispose();

        Future.delayed(Duration.zero, () async {
          await const Vibration(milliseconds: 100).emit();
        });

        Navigator.pop(context, barcode.rawValue);
      },
    );
  }

  Widget buildControllerView() {
    return Container(
      alignment: Alignment.bottomCenter,
      height: 100,
      color: Colors.black.withOpacity(0.4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildTorchButton(),
          // buildStopButton(),
          buildSwitchButton(),
          buildImagePicker(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Builder(builder: (context) {
        return Stack(
          children: [
            buildScanner(),
            Align(
              alignment: Alignment.bottomCenter,
              child: buildControllerView(),
            ),
          ],
        );
      }),
    );
  }
}
