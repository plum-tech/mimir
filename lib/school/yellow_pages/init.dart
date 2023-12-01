import 'package:sit/school/yellow_pages/storage/contact.dart';

class YellowPagesInit {
  static late YellowPagesStorage storage;

  static void init() {
    storage = const YellowPagesStorage();
  }
}
