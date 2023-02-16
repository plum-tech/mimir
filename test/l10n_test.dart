import 'dart:io';
import 'package:path/path.dart';
import 'package:yaml/yaml.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("test loading l10n.yaml", () {
    final l10nDir = Directory(join("assets", "l10n"));
    for (final file in l10nDir.listSync()) {
      final l10nFile = File(file.path);
      print("It's reading $l10nFile");
      final text = l10nFile.readAsStringSync();
      final yaml = loadYaml(text);
    }
  });
}
