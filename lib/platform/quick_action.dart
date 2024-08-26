import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:mimir/lifecycle.dart';

class _Type {
  const _Type._();

  static const examArrange = "exam_arrange";
  static const oaAnnounce = "oa_announce";
}

class QuickAction {
  static const QuickActions _quickActions = QuickActions();

  static void quickActionHandler(String type) {
    final ctx = $key.currentContext;
    if (ctx == null) return;
    switch (type) {
      case _Type.examArrange:
        ctx.push("/exam_arrange");
        break;
      case _Type.oaAnnounce:
        ctx.push("/oa_announce");
        break;
    }
  }

  static void init(BuildContext context) {
    _quickActions.initialize(quickActionHandler);
    _quickActions.setShortcutItems(<ShortcutItem>[
      const ShortcutItem(
        type: _Type.examArrange,
        localizedTitle: "Exam arrangement",
      ),
      const ShortcutItem(
        type: _Type.oaAnnounce,
        localizedTitle: "OA announcement",
      ),
    ]);
  }
}
