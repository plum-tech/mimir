import 'package:hive/hive.dart';
import 'package:sit/school/yellow_pages/storage/contact.dart';

class YellowPagesInit {
  static late YellowPagesStorage storage;
  static void init({
    required Box box,
  }) {
    storage = YellowPagesStorage(box);
  }
}
