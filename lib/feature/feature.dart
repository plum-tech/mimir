import 'dart:collection';

class AppFeature {
  const AppFeature._();

  static const //
      // --- mimir ---
      mimirForum = "mimir.forum",
      mimirBulletin = "mimir.bulletin",
      mimirUser = "mimir.user",
      // --- school section ---
      // second class
      secondClassScore = "school.secondClass.score",
      secondClassActivity = "school.secondClass.activity",
      secondClassAttended = "school.secondClass.attended",
      // exam result
      examResultPg = "school.examResult.pg",
      examResultUg = "school.examResult.ug",
      examArrangement = "school.examArrangement",
      gpa = "school.gpa",
      // teacher eval
      teacherEval = "school.teacherEval",
      // expense records
      expenseRecords = "school.expenseRecords",
      expenseRecordsStats = "school.expenseRecords.stats",
      // electricity balance
      electricityBalance = "school.electricityBalance",
      // edu email
      eduEmailInbox = "school.eduEmail.inbox",
      eduEmailOutbox = "school.eduEmail.outbox",
      // OA announcement
      oaAnnouncement = "school.oaAnnouncement",
      // SIT YWB
      ywb = "school.ywb",
      // library
      librarySearch = "school.library.search",
      libraryBorrowing = "school.library.account.borrowing",
      libraryBorrowingHistory = "school.library.account.borrowingHistory",
      // yellow pages
      yellowPages = "school.yellowPages",
      // course selection
      courseSelection = "school.courseSelection",
      // student plan
      studentPlan = "school.studentPlan",
      // --- SIT Robot section ---
      sitRobotOpenLabDoor = "school.sitRobot.openLabDoor",
      // --- basic section ---
      timetable = "basic.timetable",
      scanner = "basic.scanner",
      // --- game section ---
      game2048 = "game.2048",
      gameMinesweeper = "game.minesweeper",
      gameSudoku = "game.sudoku",
      gameWordle = "game.wordle",
      gameSuika = "game.suika";

  static const all = {
    // mimir
    mimirForum,
    mimirBulletin,
    mimirUser,
    // school
    secondClassScore,
    secondClassActivity,
    secondClassAttended,
    examResultPg,
    examResultUg,
    examArrangement,
    gpa,
    teacherEval,
    expenseRecords,
    expenseRecordsStats,
    electricityBalance,
    eduEmailInbox,
    oaAnnouncement,
    ywb,
    librarySearch,
    libraryBorrowing,
    libraryBorrowingHistory,
    yellowPages,
    courseSelection,
    studentPlan,
    // SIT Rebot
    sitRobotOpenLabDoor,
    // basic
    timetable,
    scanner,
    // game
    game2048,
    gameMinesweeper,
    gameSudoku,
    gameWordle,
    gameSuika,
  };
}

class AppFeatureTreeNode {
  final String name;
  final name2node = <String, AppFeatureTreeNode>{};

  AppFeatureTreeNode({
    required this.name,
  });

  final isRoot = false;
}

class AppFeatureTree implements AppFeatureTreeNode {
  @override
  String get name => throw Exception("Root node doesn't have name");
  @override
  final name2node = <String, AppFeatureTreeNode>{};

  AppFeatureTree();

  factory AppFeatureTree.build(Set<String> features) {
    final root = AppFeatureTree();
    for (final feature in features) {
      root.insert(feature);
    }
    return root;
  }

  @override
  final isRoot = true;

  void insert(String feature) {
    final parts = Queue.of(feature.split("."));
    AppFeatureTreeNode cur = this;
    while (parts.isNotEmpty) {
      final part = parts.removeFirst();
      if (cur.name2node.containsKey(part)) {
        var maybe = cur.name2node[part];
        if (maybe == null) {
          maybe = AppFeatureTreeNode(name: part);
          cur.name2node[part] = maybe;
        }
        cur = maybe;
      }
    }
  }

  bool find(String feature) {
    final parts = Queue.of(feature.split("."));
    final queue = Queue<AppFeatureTreeNode>();
    queue.addLast(this);
    while (queue.isNotEmpty && parts.isNotEmpty) {
      final node = queue.removeFirst();
      if (node.isRoot || node.name == parts.first) {
        parts.removeFirst();
        queue.addAll(node.name2node.values);
      }
    }
    return parts.isEmpty && queue.isEmpty;
  }
}
