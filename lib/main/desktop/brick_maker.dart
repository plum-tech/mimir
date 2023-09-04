import 'package:flutter/widgets.dart';
import 'package:mimir/credential/symbol.dart';

import '../../mini_app.dart';

class BrickMaker {
  BrickMaker._();

  static final Map<int, List<MiniApp>> _cache = {};

  static List<MiniApp> makeDefaultBricks(BuildContext ctx) {
    final auth = ctx.auth;
    final oaCredential = auth.credential;
    final status = auth.loginStatus;
    final key = oaCredential.hashCode + status.hashCode;
    final cache = _cache[key];
    if (cache != null) {
      return cache;
    } else {
      final res = makeDefaultBricksBy(oaCredential, status);
      _cache[key] = res;
      return res;
    }
  }

  // TODO: A new personalization system for this.
  static List<MiniApp> makeDefaultBricksBy(
    Credential? oa,
    LoginStatus status,
  ) {
    final r = <MiniApp>[];

    if (status != LoginStatus.validated) {
      r << MiniApp.login;
    }

    // The common function for all users no matter user type.
    // Only undergraduates need the Timetable.
    // Open the timetable for anyone who has logged in before, even though they have a wrong credential now.
    r << MiniApp.timetable;

    if (status != LoginStatus.never) {
      r << MiniApp.expense;
      r << MiniApp.elecBill;
      r << MiniApp.separator;
      // Only undergraduates need to check the activity, because it's linked to their Second class Score.
      r << MiniApp.activity;
      r << MiniApp.examResult;
      r << MiniApp.examArr;

      r << MiniApp.separator;
      // Only OA user can see the announcement.
      r << MiniApp.oaAnnouncement;
    } else {
      r << MiniApp.separator;
    }
    if (status != LoginStatus.never) {
      r << MiniApp.eduEmail;
      r << MiniApp.application;
    }
    // Everyone can use the library, but some functions only work for OA users.
    r << MiniApp.library;
    // Yellow pages are open for all no matter user type.
    // Freshman or Offline may need to look up the tel.
    r << MiniApp.yellowPages;
    r << MiniApp.separator;
    return r;
  }
}

extension _ListEx<T> on List<T> {
  void operator <<(T e) => add(e);
}
