import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mimir/design/adaptive/dialog.dart';
import 'package:mimir/entity/campus.dart';
import 'package:mimir/utils/error.dart';
import 'package:mimir/utils/permission.dart';
import 'package:permission_handler/permission_handler.dart';

import '../entity/timetable.dart';
import 'parse.ug.dart';
import '../i18n.dart';

Future<SitTimetable?> _readTimetableFromPickedFile() async {
  final result = await FilePicker.platform.pickFiles(
    // Cannot limit the extensions. My RedMi phone just reject all files.
    // type: FileType.custom,
    // allowedExtensions: const ["timetable", "json"],
    lockParentWindow: true,
  );
  if (result == null) return null;
  final content = await _readTimetableFi(result.files.single);
  if (content == null) return null;
  final json = jsonDecode(content);
  try {
    final timetable = SitTimetable.fromJson(json);
    return timetable;
  } catch (_) {
    // try parsing the file as timetable raw
    return parseUndergraduateTimetableFromRaw(
      json,
      defaultCampus: Campus.fengxian,
    );
  }
}
Future<SitTimetable?> _readTimetableFromFile(String path) async {
  final file = File(path);
  final content = await file.readAsString();
  final json = jsonDecode(content);
  final timetable = SitTimetable.fromJson(json);
  return timetable;
}

Future<SitTimetable?> _readTimetableFromBytes(Uint8List bytes) async {
  // timetable file should be encoding in utf-8.
  final content = const Utf8Decoder().convert(bytes.toList());
  final json = jsonDecode(content);
  final timetable = SitTimetable.fromJson(json);
  return timetable;
}

Future<SitTimetable?> readTimetableFromFileWithPrompt(
    BuildContext context,
    String path,
    ) async {
  return readTimetableWithPrompt(context, get: () => _readTimetableFromFile(path));
}

Future<SitTimetable?> readTimetableFromPickedFileWithPrompt(BuildContext context) {
  return readTimetableWithPrompt(context, get: _readTimetableFromPickedFile);
}

Future<SitTimetable?> readTimetableWithPrompt(
    BuildContext context, {
      required Future<SitTimetable?> Function() get,
    }) async {
  try {
    final timetable = await get();
    return timetable;
  } catch (error, stackTrace) {
    debugPrintError(error, stackTrace);
    if (!context.mounted) return null;
    if (error is PlatformException) {
      await showPermissionDeniedDialog(context: context, permission: Permission.storage);
    } else {
      await context.showTip(
        title: i18n.import.formatError,
        desc: i18n.import.formatErrorDesc,
        primary: i18n.ok,
      );
    }
    return null;
  }
}

Future<String?> _readTimetableFi(PlatformFile fi) async {
  if (kIsWeb) {
    final bytes = fi.bytes;
    if (bytes == null) return null;
    // timetable file should be encoding in utf-8.
    return const Utf8Decoder().convert(bytes.toList());
  } else {
    final path = fi.path;
    if (path == null) return null;
    final file = File(path);
    return await file.readAsString();
  }
}
