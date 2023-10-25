import 'dart:io';

import 'package:path/path.dart';

enum FileKind {
  temp,
  user,
  cache,
  internal;
}

abstract class DirLoc {
  final FileKind kind;
  final String path;

  const DirLoc(this.kind, this.path);

  const DirLoc.temp(this.path) : kind = FileKind.temp;

  const DirLoc.cache(this.path) : kind = FileKind.cache;

  const DirLoc.user(this.path) : kind = FileKind.user;

  const DirLoc.internal(this.path) : kind = FileKind.internal;
}

class FileLoc {
  final DirLoc dir;
  final String path;

  const FileLoc(this.dir, this.path);
}

class FileManager {
  // String resolvePath(FileLoc loc) {
  //   switch (loc.kind) {
  //     case FileKind.temp:
  //     case FileKind.user:
  //     case FileKind.cache:
  //     case FileKind.internal:
  //   }
  // }
}

extension DirectoryX on Directory {
  File sub(String fileName) => File(join(path, fileName));
}
