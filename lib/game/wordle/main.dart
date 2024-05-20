import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future<void> loadWordleSettings() async {
  Directory documentsDirectory = await getApplicationDocumentsDirectory();
  String documentsPath = documentsDirectory.path + Platform.pathSeparator;
  File settings = File("${documentsPath}settings.txt");
  if (!(await settings.exists())) {
    var defaultSettings = "5\nCET4\nLight";
    settings.writeAsString(defaultSettings);
  }
  List<String> dicBooks = ["validation.txt", "CET4.txt"];
  for (String dicName in dicBooks) {
    if (!(await File(documentsPath + dicName).exists())) {
      //Copy file
      ByteData data = await rootBundle.load("assets/CET4.txt");
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(documentsPath + dicName).writeAsBytes(bytes, flush: true);
    }
  }
}
