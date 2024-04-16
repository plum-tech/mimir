import 'package:flutter/cupertino.dart';
import 'package:sit/timetable/file_type/timetable.dart';
import 'package:path/path.dart';

abstract class FileTypeHandlerProtocol {
  const FileTypeHandlerProtocol();

  bool matchPath(String path);

  Future<void> onHandle({
    required BuildContext context,
    required String path,
  });

  static final List<FileTypeHandlerProtocol> all = [
    const TimetableFileType(),
  ];
}

abstract mixin class FixedExtensionFileTypeHandler implements FileTypeHandlerProtocol {
  List<String> get extensions;

  @override
  bool matchPath(String path) {
    return extensions.contains(extension(path));
  }
}
