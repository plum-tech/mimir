import 'package:mimir/timetable/file_type/timetable.dart';

import 'protocol.dart';

class FileTypeHandlers {
  static final List<FileTypeHandlerProtocol> all = [
    const TimetableFileType(),
  ];
}
