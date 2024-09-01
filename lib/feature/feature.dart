enum AppFeature {
  // mimir
  mimirForum("mimir.forum"),
  mimirBulletin("mimir.bulletin"),
  mimirUser("mimir.user"),
  mimirSitRobotGate("mimir.sitRobot.gate"),
  // school
  secondClass("school.secondClass"),
  secondClassScore("school.secondClass.score"),
  secondClassActivity("school.secondClass.activity"),
  secondClassAttended("school.secondClass.attended"),
  examResult("school.examResult"),
  examArrangement("school.examArrangement"),
  gpa("school.gpa"),
  teacherEval("school.teacherEval"),
  expenseRecords("school.expenseRecords"),
  electricityBalance("school.electricityBalance"),
  expenseRecordsStats("school.expenseRecords.stats"),
  eduEmail("school.eduEmail"),
  oaAnnouncement("school.oaAnnouncement"),
  ywb("school.ywb"),
  library("school.library"),
  librarySearch("school.librarySearch"),
  libraryBorrowing("school.borrowing"),
  libraryBorrowingHistory("school.History"),
  yellowPages("school.yellowPages"),
  courseSelection("school.courseSelection"),
  studentPlan("school.studentPlan"),
  // basic
  timetable("basic.timetable"),
  timetableCelStyles("basic.timetable.cellStyles"),
  timetableWallpaper("basic.timetable.wallpaper"),
  timetableScreenshot("basic.timetable.screenshot"),
  timetablePatch("basic.timetable.patch"),
  scanner("basic.scanner"),
  settings("basic.settings"),
  settingsLanguage("basic.settings.language"),
  settingsThemeColor("basic.settings.themeColor"),
  settingsClearCache("basic.settings.clearCache"),
  settingsProxy("basic.settings.proxy"),
  settingsNetworkTool("basic.settings.networkTool"),
  about("basic.about"),
  update("basic.update"),
  // game
  game2048("game.2048"),
  gameMinesweeper("game.minesweeper"),
  gameSudoku("game.sudoku"),
  gameWordle("game.wordle"),
  gameSuika("game.suika"),
  ;

  final String id;

  const AppFeature(this.id);
}
