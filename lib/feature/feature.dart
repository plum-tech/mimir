import 'dart:collection';

class AppFeature {
  const AppFeature._();

  static const //
      // --- mimir ---
      mimirForum = "mimir.forum",
      mimirBulletin = "mimir.bulletin",
      mimirUser = "mimir.user",
      mimirUpdate = "mimir.update",
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
      gpaUg = "school.examResult.ug.gpa",
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
      // freshman
      freshman = "school.freshman",
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
      // --- basic section ---
      timetable = "basic.timetable",
      timetableScreenshot = "basic.timetable.screenshot",
      timetableSync = "basic.timetable.sync",
      timetableAutoSync = "basic.timetable.sync.auto",
      scanner = "basic.scanner",
      // --- game section ---
      game$ = "game",
      game2048 = "game.2048",
      gameMinesweeper = "game.minesweeper",
      gameSudoku = "game.sudoku";

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
    gpaUg,
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
    // basic
    timetable,
    scanner,
    // game
    game2048,
    gameMinesweeper,
    gameSudoku,
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

  bool get isLeaf => name2node.isEmpty;

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

  @override
  bool get isLeaf => name2node.isEmpty;

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
    if (isLeaf) return false;
    final parts = Queue.of(feature.split("."));
    AppFeatureTreeNode node = this;
    while (parts.isNotEmpty) {
      final subNode = node.name2node[parts.first];
      if (subNode != null) {
        node = subNode;
        parts.removeFirst();
      } else {
        return node.isLeaf;
      }
    }
    return parts.isEmpty;
  }

  @override
  String toString() {
    return "${name2node.values}";
  }
}

extension type const AppFeatureFilter(({AppFeatureTree allow, AppFeatureTree prohibit}) o) {
  factory AppFeatureFilter.build({
    required Set<String> allow,
    required Set<String> prohibit,
  }) {
    return AppFeatureFilter((
      allow: AppFeatureTree.build(allow),
      prohibit: AppFeatureTree.build(prohibit),
    ));
  }

  factory AppFeatureFilter.create({
    required AppFeatureTree allow,
    required AppFeatureTree prohibit,
  }) {
    return AppFeatureFilter((
      allow: allow,
      prohibit: prohibit,
    ));
  }

  bool allow(String feature) {
    return o.allow.has(feature);
  }

  bool prohibit(String feature) {
    return o.prohibit.has(feature);
  }
}
