import 'package:hive/hive.dart';
import 'package:mimir/home/entity/home.dart';
import 'package:mimir/module/symbol.dart';

import '../dao/home.dart';

class HomeKeyKeys {
  static const namespace = '/home';
  static const campus = '$namespace/campus';
  static const background = '$namespace/background';
  static const backgroundMode = '$namespace/backgroundMode';
  static const installTime = '$namespace/installTime';
  static const homeItems = '$namespace/homeItems';

  // 首页在无网状态下加载的缓存.
  static const lastWeather = '$namespace/lastWeather';
  static const lastBalance = '$namespace/lastBalance';
  static const lastExpense = '$namespace/lastExpense';
  static const lastHotSearch = '$namespace/lastHotSearch';
  static const lastOfficeStatus = '$namespace/lastOfficeStatus';

  static const readNotice = '$namespace/readNotice';
  static const autoLaunchTimetable = '$namespace/autoLaunchTimetable';
}

class HomeSettingStorage implements HomeSettingDao {
  final Box<dynamic> box;

  HomeSettingStorage(this.box);

  @override
  String? get background => box.get(HomeKeyKeys.background);

  @override
  set background(String? v) => box.put(HomeKeyKeys.background, v);

  @override
  int get backgroundMode => box.get(HomeKeyKeys.backgroundMode, defaultValue: 1);

  @override
  set backgroundMode(int v) => box.put(HomeKeyKeys.backgroundMode, v);

  @override
  int get campus => box.get(HomeKeyKeys.campus, defaultValue: 1);

  @override
  set campus(int v) => box.put(HomeKeyKeys.campus, v);

  @override
  DateTime? get installTime => box.get(HomeKeyKeys.installTime);

  @override
  set installTime(DateTime? dateTime) => box.put(HomeKeyKeys.installTime, dateTime);

  @override
  Weather? get lastWeather => box.get(HomeKeyKeys.lastWeather, defaultValue: Weather.defaultWeather);

  @override
  set lastWeather(Weather? weather) => box.put(HomeKeyKeys.lastWeather, weather);

  @override
  Balance? get lastBalance => box.get(HomeKeyKeys.lastBalance);

  @override
  set lastBalance(Balance? lastBalance) => box.put(HomeKeyKeys.lastBalance, lastBalance);

  @override
  String? get lastHotSearch => box.get(HomeKeyKeys.lastHotSearch);

  @override
  set lastHotSearch(String? expense) => box.put(HomeKeyKeys.lastHotSearch, expense);

  @override
  String? get lastOfficeStatus => box.get(HomeKeyKeys.lastOfficeStatus);

  @override
  set lastOfficeStatus(String? status) => box.put(HomeKeyKeys.lastOfficeStatus, status);

  @override
  Set<int>? get readNotice => box.get(HomeKeyKeys.readNotice, defaultValue: <dynamic>{});

  @override
  set readNotice(Set<int>? noticeSet) => box.put(HomeKeyKeys.readNotice, noticeSet?.toList());

  @override
  List<FType>? get homeItems {
    final List? items = box.get(HomeKeyKeys.homeItems);
    return items?.map((e) => e as FType).toList();
  }

  @override
  set homeItems(List<FType>? items) => box.put(HomeKeyKeys.homeItems, items);

  @override
  bool? get autoLaunchTimetable => box.get(HomeKeyKeys.autoLaunchTimetable);

  @override
  set autoLaunchTimetable(bool? foo) => box.put(HomeKeyKeys.autoLaunchTimetable, foo);
}
