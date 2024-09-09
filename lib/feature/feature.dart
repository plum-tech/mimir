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
      secondClass$ = "school.secondClass",
      secondClassScore = "school.secondClass.score",
      secondClassActivity = "school.secondClass.activity",
      secondClassAttended = "school.secondClass.attended",
      // exam result
      examResult$ = "school.examResult",
      examResultPg = "school.examResult.pg",
      examResultUg = "school.examResult.ug",
      gpa = "school.examResult.ug.gpa",
      examArrangement = "school.examArrangement",
      // teacher eval
      teacherEval = "school.teacherEval",
      // expense records
      expenseRecords$ = "school.expenseRecords",
      expenseRecords = "school.expenseRecords",
      expenseRecordsStats = "school.expenseRecords.stats",
      // electricity balance
      electricityBalance = "school.electricityBalance",
      // edu email
      eduEmail$ = "school.eduEmail",
      eduEmailInbox = "school.eduEmail.inbox",
      eduEmailOutbox = "school.eduEmail.outbox",
      // OA announcement
      oaAnnouncement = "school.oaAnnouncement",
      // SIT YWB
      ywb = "school.ywb",
      // library
      library$ = "school.library",
      librarySearch = "school.library.search",
      libraryAccount$ = "school.library.account",
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
      game$ = "game",
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
  static final tree = AppFeatureTree.build(all);
}

class AppFeatureTreeNode {
  final String name;
  final name2node = <String, AppFeatureTreeNode>{};

  AppFeatureTreeNode({
    required this.name,
  });

  final isRoot = false;

  @override
  String toString() {
    return "[$name]${name2node.values}";
  }
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
      final maybe = cur.name2node[part];
      if (maybe != null) {
        cur = maybe;
      } else {
        cur = cur.name2node[part] = AppFeatureTreeNode(name: part);
      }
    }
  }

  bool has(String feature) {
    final parts = Queue.of(feature.split("."));
    final queue = Queue<AppFeatureTreeNode>();
    queue.addLast(this);
    while (queue.isNotEmpty && parts.isNotEmpty) {
      final node = queue.removeFirst();
      if (node.isRoot) {
        queue.addAll(node.name2node.values);
      } else if (node.name == parts.first) {
        parts.removeFirst();
        queue.addAll(node.name2node.values);
      }
    }
    return parts.isEmpty;
  }

  @override
  String toString() {
    return "${name2node.values}";
  }
}
