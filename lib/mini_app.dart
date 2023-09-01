import 'package:easy_localization/easy_localization.dart';

const _ns = "miniApp";

class MiniApp {
  final String id;

  const MiniApp(this.id);

  /// Separator
  static const MiniApp separator = MiniApp("separator"),
      timetable = MiniApp("timetable"),
      examArr = MiniApp("examArr"),
      activity = MiniApp("activity"),
      expense = MiniApp("expense"),
      examResult = MiniApp("examResult"),
      library = MiniApp("library"),
      application = MiniApp("application"),
      eduEmail = MiniApp("eduEmail"),
      oaAnnouncement = MiniApp("oaAnnouncement"),
      yellowPages = MiniApp("yellowPages"),
      elecBill = MiniApp("elecBill");

  String l10nName() => "$_ns.$id.name".tr();

  String l10nDesc() => "$_ns.$id.desc".tr();
}
