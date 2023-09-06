import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mimir/design/colors.dart';
import 'package:mimir/design/widgets/placeholder.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/balance.dart';
import '../init.dart';
import '../widgets/card.dart';
import '../i18n.dart';

class Dashboard extends StatefulWidget {
  final String selectedRoom;

  const Dashboard({super.key, required this.selectedRoom});

  @override
  State<StatefulWidget> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with AutomaticKeepAliveClientMixin {
  final service = ElectricityBalanceInit.service;
  final updateTimeFormatter = DateFormat('MM/dd HH:mm');
  ElectricityBalance? _balance;
  final _scrollController = ScrollController();
  final _portraitRefreshController = RefreshController();
  final _landscapeRefreshController = RefreshController();

  RefreshController getCurrentRefreshController(BuildContext ctx) =>
      ctx.isPortrait ? _portraitRefreshController : _landscapeRefreshController;

  Future<List> getRoomList() async {
    String jsonData = await rootBundle.loadString("assets/room_list.json");
    List list = await jsonDecode(jsonData);
    return list;
  }

  @override
  void initState() {
    super.initState();
    _onRefresh();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _portraitRefreshController.dispose();
    _landscapeRefreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return context.isPortrait ? buildPortrait(context) : buildLandscape(context);
  }

  Widget buildPortrait(BuildContext context) {
    return SmartRefresher(
      controller: _portraitRefreshController,
      scrollDirection: Axis.vertical,
      onRefresh: _onRefresh,
      header: const ClassicHeader(),
      scrollController: _scrollController,
      child: buildBodyPortrait(context),
    );
  }

  Widget buildLandscape(BuildContext context) {
    return SmartRefresher(
      controller: _landscapeRefreshController,
      scrollDirection: Axis.vertical,
      onRefresh: _onRefresh,
      header: const ClassicHeader(),
      scrollController: _scrollController,
      child: buildBodyLandscape(context),
    ).padAll(10);
  }

  Future<void> _onRefresh() async {
    final selectedRoom = widget.selectedRoom;
    setState(() {
      _balance = null;
    });
    final newBalance = await service.getBalance(selectedRoom);
    setState(() {
      _balance = newBalance;
    });
    if (!mounted) return;
    getCurrentRefreshController(context).refreshCompleted();
  }

  Widget buildBodyPortrait(BuildContext ctx) {
    return [
      const SizedBox(height: 5),
      ElectricityBalanceCard(balance: _balance),
      const SizedBox(height: 5),
    ].column().scrolled().padSymmetric(v: 8, h: 20);
  }

  Widget buildBodyLandscape(BuildContext ctx) {
    return [
      [
        i18n.title(widget.selectedRoom).text(style: ctx.textTheme.displayLarge).padFromLTRB(10, 0, 10, 40),
        const SizedBox(height: 5),
        ElectricityBalanceCard(balance: _balance),
      ].column().align(at: Alignment.topCenter).expanded(),
      SizedBox(width: 10.w),
    ].row().scrolled();
  }

  Widget buildUpdateTime(BuildContext ctx, DateTime? time) {
    final outOfDateColor = time != null && time.difference(DateTime.now()).inDays > 1 ? Colors.redAccent : null;
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              const Icon(Icons.update),
              const SizedBox(width: 10),
              Text(i18n.updateTime, style: TextStyle(color: outOfDateColor), overflow: TextOverflow.ellipsis),
            ]),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(time != null ? updateTimeFormatter.format(time.toLocal()) : "...", overflow: TextOverflow.ellipsis),
            ]),
          ],
        )).center();
  }

  @override
  bool get wantKeepAlive => true;
}
