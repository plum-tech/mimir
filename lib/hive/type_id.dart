export "package:hive/hive.dart";

/// Basic 0-19
class HiveTypeBasic {
  static const size = 0;
  static const themeMode = 1;
  static const version = 2;
}

/// Credential 20-29
class HiveTypeCredentials {
  static const oa = 20;
  static const loginStatus = 21;
  static const email = 22;
}

/// Credential 30-39
class HiveTypeSchool {
  static const campus = 30;
  static const semester = 31;
  static const schoolYear = 32;
  static const schoolContact = 33;
}

/// Exam 40-49
class HiveTypeExam {
  // Exam arrange
  static const examEntry = 40;

  // Exam result
  static const examResult = 41;
  static const examResultDetails = 42;
}

/// Second Class 50-69
class HiveTypeClass2nd {
  // Second class activity 50-54
  static const activity = 50;
  static const activityDetails = 51;
  static const activityType = 52;

  // Second class score 55-59
  static const scoreSummary = 60;
  static const activityApplication = 61;
  static const scoreItem = 62;
}

/// Expense Records 70-74
class HiveTypeExpenseRecords {
  static const transaction = 70;
  static const transactionType = 71;
}

/// Electricity 75-79
class HiveTypeElectricity {
  static const balance = 80;
}

/// Ywb 80-89
class HiveTypeYwb {
  static const details = 80;
  static const detailSection = 81;
  static const meta = 82;
  static const message = 83;
  static const messagePage = 84;
  static const messageCount = 85;
  static const messageType = 86;
}

/// Ywb 90-99
class HiveTypeOaAnnounce {
  static const details = 90;
  static const attachment = 91;
  static const catalogue = 92;
  static const listPage = 93;
  static const record = 94;
}
