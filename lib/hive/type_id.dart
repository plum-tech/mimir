export "package:hive/hive.dart";

class HiveTypeId {
  HiveTypeId._();

  // Basic 0-10
  static const version = 0;

  // Credential 10-19
  static const credential = 10;
  static const loginStatus = 11;
  static const emailCredential = 12;

  // Electric Bill 20-29
  static const balance = 20;

  // Activity 30-39
  static const activityDetail = 30;
  static const activity = 31;
  static const scScoreSummary = 32;
  static const scActivityApplication = 33;
  static const scScoreItem = 34;
  static const activityType = 35;

  // Exam Arrangement 40-49
  static const examEntry = 40;

  // OA Announcement 50-59
  static const announceDetail = 50;
  static const announceAttachment = 51;
  static const announceCatalogue = 52;
  static const announceListPage = 53;
  static const announceRecord = 54;

  // Application 60-69
  static const applicationDetail = 61;
  static const applicationDetailSection = 62;
  static const applicationMeta = 63;
  static const applicationMsg = 64;
  static const applicationMsgPage = 65;
  static const applicationMsgCount = 66;
  static const applicationMessageType = 67;

  // Exam Result 70-79
  static const examResult = 70;
  static const examResultDetail = 71;
  static const semester = 72;
  static const schoolYear = 73;

  // Library 80-89
  static const librarySearchHistory = 80;
}
