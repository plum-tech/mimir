import 'package:hive/hive.dart';
import 'package:sit/storage/hive/init.dart';

import '../entity/image.dart';

class _K {
  static const ns = "/library/images";

  static String image(String isbn) => "$ns/$isbn";
}

class LibraryImageStorage {
  Box get box => HiveInit.library;

  const LibraryImageStorage();

  BookImage? getImage(String isbn) => box.get(_K.image(isbn));

  Future<void> setImage(String isbn, BookImage? value) => box.put(_K.image(isbn), value);
}
