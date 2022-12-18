/// 存放所有 hive 的自定义类型的typeId
class HiveTypeId {
  HiveTypeId._();

  static const librarySearchHistory = 1;
  static const auth = 2; // 改为单用户后已不再使用该id
  static const weather = 3;
  static const reportHistory = 4;
  static const balance = 5;
  static const course = 6;
  static const expense = 7;
  static const expenseType = 8;
  static const contact = 9;
  static const userEventType = 10;
  static const userEvent = 11;
  static const gameType = 12;
  static const gameRecord = 13;
  static const ftype = 14;
  static const timetableMeta = 15;
  static const size = 16;
  static const color = 17;

  // Activity
  static const activityDetail = 18;
  static const activity = 19;
  static const scScoreSummary = 20;
  static const scActivityApplication = 21;
  static const scScoreItem = 22;
  static const activityType = 23;

  // Exam Arrangement
  static const examEntry = 24;

  // OA Announcement
  static const announceDetail = 25;
  static const announceAttachment = 26;
  static const announceCatalogue = 27;
  static const announceListPage = 28;
  static const announceRecord = 29;

  // Application
  static const applicationDetail = 30;
  static const applicationDetailSection = 31;
  static const applicationMeta = 32;
  static const applicationMsg = 33;
  static const applicationMsgPage = 34;
  static const applicationMsgCount = 35;
  static const applicationMessageType = 36;

  static const version = 37;

  // Credential
  static const oaUserCredential = 38;
  static const freshmanCredential = 39;
  static const userType = 40;

  // Exam Result
  static const examResult = 41;
  static const examResultDetail = 42;
  static const semester = 43;
  static const schoolYear = 44;
}
