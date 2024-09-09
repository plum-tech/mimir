enum AppFeature {
  // --- mimir ---
  mimirForum("mimir.forum"),
  mimirBulletin("mimir.bulletin"),
  mimirUser("mimir.user"),
  update("mimir.update"),
  // --- school section ---
  // second class
  secondClass("school.secondClass"),
  secondClassScore("school.secondClass.score"),
  secondClassActivity("school.secondClass.activity"),
  secondClassAttended("school.secondClass.attended"),
  // exam result
  examResult("school.examResult"),
  examArrangement("school.examArrangement"),
  gpa("school.gpa"),
  // teacher eval
  teacherEval("school.teacherEval"),
  // expense records
  expenseRecords("school.expenseRecords"),
  expenseRecordsStats("school.expenseRecords.stats"),
  // electricity balance
  electricityBalance("school.electricityBalance"),
  // edu email
  eduEmail("school.eduEmail"),
  // OA announcement
  oaAnnouncement("school.oaAnnouncement"),
  // SIT YWB
  ywb("school.ywb"),
  // library
  library("school.library"),
  librarySearch("school.librarySearch"),
  libraryBorrowing("school.borrowing"),
  libraryBorrowingHistory("school.borrowing.history"),
  // yellow pages
  yellowPages("school.yellowPages"),
  // course selection
  courseSelection("school.courseSelection"),
  // student plan
  studentPlan("school.studentPlan"),
  // --- SIT Robot section ---
  sitRobotOpenLabDoor("school.sitRobot.openLabDoor"),
  // --- basic section ---
  timetable("basic.timetable"),
  scanner("basic.scanner"),
  // --- game section ---
  game2048("game.2048"),
  gameMinesweeper("game.minesweeper"),
  gameSudoku("game.sudoku"),
  gameWordle("game.wordle"),
  gameSuika("game.suika"),
  ;

  final String id;

  const AppFeature(this.id);

  static const mimir = {
    mimirForum,
    mimirBulletin,
    mimirUser,
    update,
  };
  static const school = {
    secondClass,
    secondClassScore,
    secondClassActivity,
    secondClassAttended,
    examResult,
    examArrangement,
    gpa,
    teacherEval,
    expenseRecords,
    expenseRecordsStats,
    electricityBalance,
    eduEmail,
    oaAnnouncement,
    ywb,
    library,
    librarySearch,
    libraryBorrowing,
    libraryBorrowingHistory,
    yellowPages,
    courseSelection,
    studentPlan,
  };
  static const sitRobot = {
    sitRobotOpenLabDoor,
  };
  static const basic = {
    timetable,
    scanner,
  };
  static const game = {
    game2048,
    gameMinesweeper,
    gameSudoku,
    gameWordle,
    gameSuika,
  };
}
