import 'package:mimir/credential/symbol.dart';

import 'entity/ftype.dart';

class BrickMaker {
  BrickMaker._();

  static final Map<int, List<FType>> _cache = {};

  static List<FType> makeDefaultBricks() {
    final oa = Auth.oaCredential;
    final hasLoggedIn = Auth.hasLoggedIn;
    final key = oa.hashCode + hasLoggedIn.hashCode;
    final cache = _cache[key];
    if (cache != null) {
      return cache;
    } else {
      final res = makeDefaultBricksBy(
        oa,
        hasLoggedIn,
      );
      _cache[key] = res;
      return res;
    }
  }

  // TODO: A new personalization system for this.
  static List<FType> makeDefaultBricksBy(
    OACredential? oa,
    bool hasLoggedIn,
  ) {
    final r = <FType>[];
    // The common function for all users no matter user type.
    // Only undergraduates need the Timetable.
    // Open the timetable for anyone who has logged in before, even though they have a wrong credential now.
    r << FType.timetable;

    if (oa != null) {
      // Only the OA user can report temperature.
      r << FType.reportTemp;
    }
    r << FType.separator;
    if (hasLoggedIn) {
      r << FType.expense;
      r << FType.elecBill;
      // Only undergraduates need to check the activity, because it's linked to their Second class Score.
      r << FType.activity;
      r << FType.examResult;
      r << FType.examArr;

      r << FType.separator;
      // Only OA user can see the announcement.
      r << FType.oaAnnouncement;
    }
    if (hasLoggedIn) {
      r << FType.eduEmail;
      r << FType.application;
    }
    // Everyone can use the library, but some functions only work for OA users.
    r << FType.library;
    // Yellow pages are open for all no matter user type.
    // Freshman or Offline may need to look up the tel.
    r << FType.yellowPages;
    r << FType.scanner;
    r << FType.separator;
    // Entertainment
    // Trailing separator to ensure override works fine.
    r << FType.separator;
    return r;
  }
}

extension _ListEx<T> on List<T> {
  void operator <<(T e) => add(e);
}
