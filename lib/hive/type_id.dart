/// 存放所有 hive 的自定义类型的typeId
class HiveTypeId {
  HiveTypeId._();

  // Basic 0-99
  static const version = 0;

  // Credential 100-199
  static const oaUserCredential = 100;
  static const loginStatus = 101;

  // Electric Bill 200-299
  static const balance = 200;

  // Activity 300-399
  static const activityDetail = 300;
  static const activity = 301;
  static const scScoreSummary = 302;
  static const scActivityApplication = 303;
  static const scScoreItem = 304;
  static const activityType = 305;

  // Exam Arrangement 400-499
  static const examEntry = 400;

  // OA Announcement 500-599
  static const announceDetail = 500;
  static const announceAttachment = 501;
  static const announceCatalogue = 502;
  static const announceListPage = 503;
  static const announceRecord = 504;

  // Application 600-699
  static const applicationDetail = 601;
  static const applicationDetailSection = 602;
  static const applicationMeta = 603;
  static const applicationMsg = 604;
  static const applicationMsgPage = 605;
  static const applicationMsgCount = 606;
  static const applicationMessageType = 607;

  // Exam Result 700-799
  static const examResult = 700;
  static const examResultDetail = 701;
  static const semester = 702;
  static const schoolYear = 703;

  // Library 800-899
  static const librarySearchHistory = 800;
}
