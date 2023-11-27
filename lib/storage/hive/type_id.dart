export "package:hive/hive.dart";

/// Basic 0-19
class CoreHiveType {
  static const size = 0;
  static const themeMode = 1;
  static const version = 2;
  static const campus = 3;
  static const credentials = 4;
  static const loginStatus = 5;
  static const oaUserType = 6;
  static const semester = 7;
}

class CacheHiveType {
  // Exam result 0-9
  static const examResult = 0;
  static const examResultItem = 1;

  // Second class activity 10-19
  static const activity = 10;
  static const activityDetails = 11;
  static const activityCat = 12;

  // Second class score 20-29
  static const class2ndScoreSummary = 20;
  static const class2ndActivityApplication = 21;
  static const class2ndScoreItem = 22;
  static const class2ndScoreType = 23;

  // Expense Records 30-39
  static const expenseTransactionType = 30;
  static const expenseTransaction = 39;

  // Electricity 40-49
  static const electricityBalance = 40;

  // Ywb 50-59
  static const ywbServiceDetails = 50;
  static const ywbServiceDetailSection = 51;
  static const ywbService = 52;
  static const ywbApplication = 53;
  static const ywbApplicationTrack = 54;

  // OaAnnounce 60-69
  static const oaAnnounceDetails = 60;
  static const oaAnnounceAttachment = 61;
  static const oaAnnounceRecord = 62;

  // School yellow pages 70-79
  static const schoolContact = 70;
}
