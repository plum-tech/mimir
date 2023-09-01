import 'package:mimir/main/desktop/entity/miniApp.dart';
import 'package:mimir/mini_apps/symbol.dart';

abstract class HomeSettingDao {
  int get campus; // 校区
  set campus(int value);

  String? background; // 背景图片 path

  int get backgroundMode; // 背景模式
  set backgroundMode(int mode);

  DateTime? installTime; // 安装时间

  // 首页在无网状态下加载的缓存
  Balance? lastBalance;
  String? lastHotSearch;
  Set<int>? readNotice;
  List<MiniApp>? homeItems;

  // 启动时是否自动启动课表
  bool? autoLaunchTimetable;
}
