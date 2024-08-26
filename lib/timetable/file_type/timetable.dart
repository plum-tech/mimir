import 'package:flutter/widgets.dart';
import 'package:mimir/file_type/protocol.dart';
import 'package:mimir/timetable/utils.dart';

import '../page/mine.dart';

class TimetableFileType with FixedExtensionFileTypeHandler implements FileTypeHandlerProtocol {
  const TimetableFileType();

  @override
  List<String> get extensions => const [".timetable"];

  @override
  Future<void> onHandle({
    required BuildContext context,
    required String path,
  }) async {
    final timetable = await readTimetableFromFileWithPrompt(context, path);
    if (timetable == null) return;
    if (!context.mounted) return;
    await onTimetableFromFile(context: context, timetable: timetable);
  }
}
