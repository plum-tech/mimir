import 'dart:math';

import 'package:auto_animated/auto_animated.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mimir/design/animation/livelist.dart';
import 'package:mimir/l10n/extension.dart';
import 'package:mimir/network/session.dart';
import 'package:mimir/school/oa_announce/widget/announce.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/announce.dart';
import '../entity/page.dart';
import '../init.dart';
import '../i18n.dart';
import 'detail.dart';

class OaAnnouncePage extends StatefulWidget {
  const OaAnnouncePage({super.key});

  @override
  State<OaAnnouncePage> createState() => _OaAnnouncePageState();
}

class _OaAnnouncePageState extends State<OaAnnouncePage> {
  List<AnnounceRecord>? _records;

  @override
  void initState() {
    super.initState();
    _queryBulletinListInAllCategory(1).then((value) {
      if (!mounted) return;
      if (value != null) {
        setState(() {
          // 公告项按时间排序
          value.sort((a, b) => b.dateTime.difference(a.dateTime).inSeconds);
          _records = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final records = _records;
    return Scaffold(
      appBar: AppBar(title: i18n.title.text()),
      body: records == null
          ? const SizedBox()
          : ListView.builder(
              itemCount: records.length,
              itemBuilder: (context, index) {
                final record = records[index];
                return OaAnnounceTile(record);
              },
            ),
    );
  }

  Future<List<AnnounceRecord>?> _queryBulletinListInAllCategory(int page) async {
    // Make sure login.
    await OaAnnounceInit.session.request('https://myportal.sit.edu.cn/', ReqMethod.get);

    final service = OaAnnounceInit.service;

    // 获取所有分类
    final catalogues = await service.getAllCatalogues();
    if (catalogues == null) return null;

    // 获取所有分类中的第一页
    final futureResult = await Future.wait(catalogues.map((e) => service.queryAnnounceList(page, e.id)));
    // 合并所有分类的第一页的公告项
    final List<AnnounceRecord> records = futureResult.whereNotNull().fold(
      <AnnounceRecord>[],
      (List<AnnounceRecord> previousValue, AnnounceListPage page) => previousValue + page.bulletinItems,
    ).toList();
    return records;
  }
}
