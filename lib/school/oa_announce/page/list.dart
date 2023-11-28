import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sit/design/widgets/card.dart';
import 'package:sit/design/widgets/common.dart';

import 'package:sit/school/oa_announce/widget/tile.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/announce.dart';
import '../entity/page.dart';
import '../init.dart';
import '../i18n.dart';

class OaAnnounceListPage extends StatefulWidget {
  const OaAnnounceListPage({super.key});

  @override
  State<OaAnnounceListPage> createState() => _OaAnnounceListPageState();
}

class _OaAnnounceListPageState extends State<OaAnnounceListPage> {
  var recordList = OaAnnounceInit.storage.recordList;
  bool isFetching = false;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  Future<void> refresh() async {
    if (!mounted) return;
    setState(() {
      isFetching = true;
    });
    try {
      final recordList = await _queryAnnounceListInAllCategory(1);
      // 公告项按时间排序
      recordList.sort((a, b) => b.dateTime.compareTo(a.dateTime));
      OaAnnounceInit.storage.recordList = recordList;
      if (!mounted) return;
      setState(() {
        this.recordList = recordList;
        isFetching = false;
      });
    } catch (error, stackTrace) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: stackTrace);
      if (!mounted) return;
      setState(() {
        isFetching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final recordList = this.recordList;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: i18n.title.text(),
            bottom: isFetching
                ? const PreferredSize(
                    preferredSize: Size.fromHeight(4),
                    child: LinearProgressIndicator(),
                  )
                : null,
          ),
          if (recordList != null)
            if (recordList.isEmpty)
              SliverFillRemaining(
                child: LeavingBlank(
                  icon: Icons.inbox_outlined,
                  desc: i18n.noOaAnnouncesTip,
                ),
              )
            else
              SliverList.builder(
                itemCount: recordList.length,
                itemBuilder: (ctx, i) {
                  final record = recordList[i];
                  return FilledCard(
                    clip: Clip.hardEdge,
                    child: OaAnnounceTile(record).hero(record.uuid),
                  );
                },
              )
        ],
      ),
    );
  }

  // TODO: move this into service folder
  Future<List<OaAnnounceRecord>> _queryAnnounceListInAllCategory(int page) async {
    // Make sure login.
    await OaAnnounceInit.service.session.request(
      'https://myportal.sit.edu.cn/',
      options: Options(
        method: "GET",
      ),
    );

    final service = OaAnnounceInit.service;

    // 获取所有分类
    // TODO: user type system
    const catalogues = OaAnnounceCat.values;

    // 获取所有分类中的第一页
    final futureResult = await Future.wait(catalogues.map((e) => service.queryAnnounceList(page, e.id)));
    // 合并所有分类的第一页的公告项
    final List<OaAnnounceRecord> records = futureResult.whereNotNull().fold(
      <OaAnnounceRecord>[],
      (List<OaAnnounceRecord> previousValue, OaAnnounceListPayload page) => previousValue + page.items,
    ).toList();
    return records;
  }
}

class OaAnnounceLoadingList extends StatefulWidget {
  final OaAnnounceCat cat;
  final ValueChanged<bool> onLoadingChanged;

  const OaAnnounceLoadingList({
    super.key,
    required this.cat,
    required this.onLoadingChanged,
  });

  @override
  State<OaAnnounceLoadingList> createState() => _OaAnnounceLoadingListState();
}

class _OaAnnounceLoadingListState extends State<OaAnnounceLoadingList> with AutomaticKeepAliveClientMixin {
  int lastPage = 1;
  bool isFetching = false;
  late List<OaAnnounceRecord> announcements =
      // Class2ndInit.activityStorage.getActivities(widget.cat)??
      <OaAnnounceRecord>[];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) async {
      await loadMore();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return NotificationListener<ScrollNotification>(
      onNotification: (event) {
        if (event.metrics.pixels >= event.metrics.maxScrollExtent) {
          loadMore();
        }
        return true;
      },
      child: CustomScrollView(
        // CAN'T USE ScrollController, and I don't know why
        // controller: scrollController,
        slivers: <Widget>[
          SliverOverlapInjector(
            // This is the flip side of the SliverOverlapAbsorber above.
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          SliverList.builder(
            itemCount: announcements.length,
            itemBuilder: (ctx, index) {
              return FilledCard(
                clip: Clip.hardEdge,
                child: OaAnnounceTile(announcements[index]),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> loadMore() async {
    if (isFetching) return;
    if (!mounted) return;
    setState(() {
      isFetching = true;
    });
    widget.onLoadingChanged(true);
    try {
      if (!mounted) return;
      setState(() {
        lastPage++;
        isFetching = false;
      });
      widget.onLoadingChanged(false);
    } catch (error, stackTrace) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: stackTrace);
      if (!mounted) return;
      setState(() {
        isFetching = false;
      });
      widget.onLoadingChanged(false);
    }
  }
}
