import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mimir/global/global.dart';
import 'package:mimir/mini_apps/library/search/entity/hot_search.dart';
import 'package:mimir/mini_apps/library/search/init.dart';
import 'package:mimir/mini_apps/library/i18n.dart';

import '../../../mini_app.dart';
import '../widgets/brick.dart';

class LibraryBrick extends StatefulWidget {
  final String route;
  final IconBuilder icon;

  const LibraryBrick({
    super.key,
    required this.route,
    required this.icon,
  });

  @override
  State<StatefulWidget> createState() => _LibraryBrickState();
}

class _LibraryBrickState extends State<LibraryBrick> {
  String? content;

  @override
  void initState() {
    super.initState();
    Global.eventBus.on<EventTypes>().listen((e) {
      if (e == EventTypes.onHomeRefresh) {}
    });
  }

  void _onHomeRefresh(_) async {
    final String? result = await _buildContent();
    if (!mounted) return;
    setState(() => content = result);
  }

  Future<String?> _buildContent() async {
    late HotSearch hotSearch;

    try {
      hotSearch = await LibrarySearchInit.hotSearchService.getHotSearch();
    } catch (e) {
      return null;
    }
    final monthlyHot = hotSearch.recentMonth;
    final randomIndex = Random().nextInt(monthlyHot.length);
    final hotItem = monthlyHot[randomIndex];

    final result = '${i18n.hotPost}: ${hotItem.hotSearchWord} (${hotItem.count})';
    // Settings.lastHotSearch = result;
    return result;
  }

  @override
  Widget build(BuildContext context) {
    if (content == null) {
      // TODO: Hot search
      // final lastHotSearch = Settings.lastHotSearch;
      // content = lastHotSearch;
    }
    return Brick(
      route: widget.route,
      icon: widget.icon,
      title: MiniApp.library.l10nName(),
      subtitle: content ?? MiniApp.library.l10nDesc(),
    );
  }
}
