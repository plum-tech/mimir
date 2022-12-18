import 'adapter.dart';
import 'using.dart';

class HiveBoxInit {
  HiveBoxInit._();

  static late Box<dynamic> credentials;
  static late Box<LibrarySearchHistoryItem> librarySearchHistory;
  static late Box<ContactData> contactSetting;
  static late Box<dynamic> course;
  static late Box<dynamic> timetable;
  static late Box<dynamic> expense;
  static late Box<dynamic> activityCache;
  static late Box<dynamic> examArrCache;
  static late Box<dynamic> examResultCache;
  static late Box<dynamic> oaAnnounceCache;
  static late Box<dynamic> applicationCache;
  static late Box<dynamic> kv;
  static late Box<dynamic> cookiesBox;

  static late Map<String, Box> name2Box;

  static Future<void> init(String root) async {
    await Hive.initFlutter(root);
    HiveAdapter.registerAll();
    credentials = await Hive.openBox('credentials');
    kv = await Hive.openBox('setting');
    librarySearchHistory = await Hive.openBox('librarySearchHistory');
    contactSetting = await Hive.openBox('contactSetting');
    course = await Hive.openBox<dynamic>('course');
    timetable = await Hive.openBox<dynamic>('timetable');
    expense = await Hive.openBox('expense');
    activityCache = await Hive.openBox('activityCache');
    examArrCache = await Hive.openBox('examArrCache');
    examResultCache = await Hive.openBox('examResultCache');
    oaAnnounceCache = await Hive.openBox('oaAnnounceCache');
    applicationCache = await Hive.openBox('applicationCache');
    cookiesBox = await Hive.openBox<dynamic>('cookies');
    name2Box = {
      "credentials": HiveBoxInit.credentials,
      "setting": HiveBoxInit.kv,
      "librarySearchHistory": HiveBoxInit.librarySearchHistory,
      "cookies": HiveBoxInit.cookiesBox,
      "course": HiveBoxInit.course,
      "timetable": HiveBoxInit.timetable,
      "examArrCache": HiveBoxInit.examArrCache,
      "examResultCache": HiveBoxInit.examResultCache,
      "oaAnnounceCache": HiveBoxInit.oaAnnounceCache,
      "activityCache": HiveBoxInit.activityCache,
      "applicationCache": HiveBoxInit.applicationCache,
      "contactSetting": HiveBoxInit.contactSetting,
      // almost time, this box is very very long which ends up low performance in building.
      // So put this on the bottom
      "expense": HiveBoxInit.expense,
    };
  }

  static Future<void> clear() async {
    await credentials.deleteFromDisk();
    await kv.deleteFromDisk();
    await librarySearchHistory.deleteFromDisk();
    await contactSetting.deleteFromDisk();
    await course.deleteFromDisk();
    await timetable.deleteFromDisk();
    await expense.deleteFromDisk();
    await activityCache.deleteFromDisk();
    await examArrCache.deleteFromDisk();
    await examResultCache.deleteFromDisk();
    await oaAnnounceCache.deleteFromDisk();
    await applicationCache.deleteFromDisk();
    await cookiesBox.deleteFromDisk();
    await Hive.close();
  }

  static Future<void> clearCache() async {
    activityCache.clear();
    oaAnnounceCache.clear();
    examArrCache.clear();
    examResultCache.clear();
    applicationCache.clear();
  }
}
