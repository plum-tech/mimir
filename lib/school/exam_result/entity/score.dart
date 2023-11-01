class PostgraduateScoreRaw {
  /// 课程类别
  final String courseClass;

  /// 课程编号
  final String courseCode;

  /// 课程名称
  final String courseName;

  /// 学分
  final String courseCredit;

  /// 教师
  final String teacher;

  /// 成绩
  final String score;

  /// 是否及格
  final String isPassed;

  /// 考试性质
  final String examNature;

  /// 考试方式
  final String examForm;

  /// 考试时间
  final String examTime;

  /// 备注
  final String notes;

  const PostgraduateScoreRaw({
    required this.courseClass,
    required this.courseCode,
    required this.courseName,
    required this.courseCredit,
    required this.teacher,
    required this.score,
    required this.isPassed,
    required this.examNature,
    required this.examForm,
    required this.examTime,
    required this.notes
  });
}