import 'package:flutter/widgets.dart';
import 'package:mimir/intent/file_type/protocol.dart';

import '../page/mine.dart';
import '../utils/import.dart';

class TimetableFileType with FixedExtensionMixin implements FileTypeHandlerProtocol {
  const TimetableFileType();

  @override
  List<String> get extensions => const [".timetable", ".json"];

  @override
  Future<void> onHandle({
    required BuildContext context,
    required String path,
  }) async {
    final timetable = await readTimetableWithPrompt(
      context,
      get: () async {
        final bytes = await readBytesFromPath(path);
        return readTimetableFromBytes(bytes);
      },
    );
    if (timetable == null) return;
    if (!context.mounted) return;
    await onTimetableFromFile(
      context: context,
      timetable: timetable,
    );
  }
}
