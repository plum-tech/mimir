import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mimir/design/widgets/common.dart';
import 'package:mimir/network/session.dart';
import 'package:mimir/school/oa_announce/widget/tile.dart';
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
      recordList.sort((a, b) => -b.dateTime.compareTo(a.dateTime));
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
                  return OaAnnounceTile(record)
                      .inCard(
                        clip: Clip.hardEdge,
                      )
                      .hero(record.uuid);
                },
              )
        ],
      ),
    );
  }

  Future<List<OaAnnounceRecord>> _queryAnnounceListInAllCategory(int page) async {
    // Make sure login.
    await OaAnnounceInit.session.request('https://myportal.sit.edu.cn/', ReqMethod.get);

    final service = OaAnnounceInit.service;

    // 获取所有分类
    final catalogues = await service.fetchCatalogues();

    // 获取所有分类中的第一页
    final futureResult = await Future.wait(catalogues.map((e) => service.queryAnnounceList(page, e.id)));
    // 合并所有分类的第一页的公告项
    final List<OaAnnounceRecord> records = futureResult.whereNotNull().fold(
      <OaAnnounceRecord>[],
      (List<OaAnnounceRecord> previousValue, OaAnnounceListPayload page) => previousValue + page.bulletinItems,
    ).toList();
    return records;
  }
}
