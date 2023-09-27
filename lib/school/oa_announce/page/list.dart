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
  List<OaAnnounceRecord>? records;

  @override
  void initState() {
    super.initState();
    _queryAnnounceListInAllCategory(1).then((value) {
      if (!mounted) return;
      if (value != null) {
        // 公告项按时间排序
        value.sort((a, b) => b.dateTime.difference(a.dateTime).inSeconds);
        setState(() {
          records = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final records = this.records;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: i18n.title.text(),
            bottom: records != null
                ? null
                : const PreferredSize(
                    preferredSize: Size.fromHeight(4),
                    child: LinearProgressIndicator(),
                  ),
          ),
          if (records != null)
            if (records.isEmpty)
              SliverFillRemaining(
                child: LeavingBlank(
                  icon: Icons.inbox_outlined,
                  desc: i18n.noOaAnnouncesTip,
                ),
              )
            else
              SliverList.builder(
                itemCount: records.length,
                itemBuilder: (ctx, i) {
                  final record = records[i];
                  return OaAnnounceTile(record).inCard().hero(record.uuid);
                },
              )
        ],
      ),
    );
  }

  Future<List<OaAnnounceRecord>?> _queryAnnounceListInAllCategory(int page) async {
    // Make sure login.
    await OaAnnounceInit.session.request('https://myportal.sit.edu.cn/', ReqMethod.get);

    final service = OaAnnounceInit.service;

    // 获取所有分类
    final catalogues = await service.getAllCatalogues();
    if (catalogues == null) return null;

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
