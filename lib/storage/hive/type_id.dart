export "package:hive/hive.dart";

/// Basic 0-19
class HiveTypeBasic {
  static const size = 0;
  static const themeMode = 1;
  static const version = 2;
}

/// Credential 20-29
class HiveTypeCredentials {
  static const credentials = 20;
  static const loginStatus = 21;
  static const email = 22;
  static const oaUserType = 23;
}

/// School 30-39
class HiveTypeSchool {
  static const campus = 30;
  static const semester = 31;

  // School yellow pages 36-39
  static const schoolContact = 36;
}

/// Exam 40-49
class HiveTypeExam {
  // Exam result
  static const result = 41;
  static const resultItem = 42;
}

/// Second Class 50-69
class HiveTypeClass2nd {
  // Second class activity 50-54
  static const activity = 50;
  static const activityDetails = 51;
  static const activityCat = 52;

  // Second class score 55-59
  static const scoreSummary = 60;
  static const activityApplication = 61;
  static const scoreItem = 62;
  static const scoreType = 63;
}

/// Expense Records 70-74
class HiveTypeExpenseRecords {
  static const transaction = 70;
  static const transactionType = 71;
}

/// Electricity 75-79
class HiveTypeElectricity {
  static const balance = 75;
}

/// Ywb 80-89
class HiveTypeYwb {
  static const metaDetails = 80;
  static const metaDetailSection = 81;
  static const meta = 82;
  static const application = 83;
  static const applicationTrack = 84;
}

/// Ywb 90-99
class HiveTypeOaAnnounce {
  static const details = 90;
  static const attachment = 91;
  static const catalogue = 92;
  static const record = 94;
}