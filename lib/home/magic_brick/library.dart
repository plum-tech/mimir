import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mimir/global/global.dart';
import 'package:mimir/l10n/extension.dart';
import 'package:mimir/module/library/search/entity/hot_search.dart';
import 'package:mimir/module/library/search/init.dart';
import 'package:mimir/storage/init.dart';

import '../widgets/brick.dart';

class LibraryItem extends StatefulWidget {
  const LibraryItem({super.key});

  @override
  State<StatefulWidget> createState() => _LibraryItemState();
}

class _LibraryItemState extends State<LibraryItem> {
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
    Kv.home.lastHotSearch = result;
    return result;
  }

  @override
  Widget build(BuildContext context) {
    // 如果是首屏加载
    if (content == null) {
      final lastHotSearch = Kv.home.lastHotSearch;
      content = lastHotSearch;
    }
    return Brick(
        route: '/library',
        icon: SvgAssetIcon('assets/home/icon_library.svg'),
        title: i18n.ftype_library,
        subtitle: content ?? i18n.ftype_library_desc);
  }
}
