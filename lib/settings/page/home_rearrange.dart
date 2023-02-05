import 'dart:math';

import 'package:animations/animations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';
import 'package:mimir/global/global.dart';
import 'package:mimir/home/brick_maker.dart';
import 'package:mimir/home/entity/home.dart';
import 'package:mimir/module/activity/using.dart';
import 'package:mimir/util/vibration.dart';
import 'package:rettulf/rettulf.dart';
import 'package:rnd/rnd.dart';

class HomeRearrangePage extends StatefulWidget {
  const HomeRearrangePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomeRearrangePageState();
}

class _HomeRearrangePageState extends State<HomeRearrangePage> {
  List<FType> defaultOrder = const [];
  List<FType> homeItemsA = const [];
  List<FType> homeItemsB = const [];
  bool isA = true;

  List<FType> get currentHomeItems => isA ? homeItemsA : homeItemsB;

  set currentHomeItems(List<FType> newList) => isA ? homeItemsA = newList : homeItemsB = newList;
  ValueKey<int> _homeItemsAKey = const ValueKey(1);
  ValueKey<int> _homeItemsBKey = const ValueKey(-1);

  ValueKey<int> get currentKey => isA ? _homeItemsAKey : _homeItemsBKey;

  set currentKey(ValueKey<int> newKey) => isA ? _homeItemsAKey = newKey : _homeItemsBKey = newKey;

  void nextKey() {
    if (isA) {
      currentKey = ValueKey(currentKey.value + 1);
    } else {
      currentKey = ValueKey(currentKey.value - 1);
    }
  }

  @override
  void initState() {
    super.initState();
    defaultOrder = BrickMaker.makeDefaultBricks();
    homeItemsA = Kv.home.homeItems ?? [...defaultOrder];
    homeItemsB = [...homeItemsA];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
          appBar: AppBar(
            title: i18n.settingsHomepageRearrangeTitle.text(),
            actions: [buildResetButton()],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: buildBody(context),
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add_outlined),
            onPressed: () {
              setState(() {
                currentHomeItems.insert(0, FType.separator);
              });
            },
          )),
      onWillPop: () async {
        Kv.home.homeItems = currentHomeItems;
        Global.eventBus.emit(EventNameConstants.onHomeItemReorder);
        return true;
      },
    );
  }

  Widget buildBody(BuildContext ctx) {
    return AnimatedSwitcher(
        duration: const Duration(milliseconds: 600),
        switchInCurve: Curves.fastLinearToSlowEaseIn,
        switchOutCurve: Curves.fastLinearToSlowEaseIn,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeScaleTransition(animation: animation, child: child);
        },
        child: buildReorderableList(ctx, currentHomeItems, key: currentKey));
  }

  void _onReorder(List<FType> items, int oldIndex, int newIndex) {
    setState(() {
      // 交换数据
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = items.removeAt(oldIndex);
      items.insert(newIndex, item);
    });
  }

  int? reorderingIndex;

  Future<void> _onReorderStart(int index) async {
    setState(() {
      reorderingIndex = index;
    });
    await const Vibration(milliseconds: 100).emit();
  }

  Future<void> _onReorderEnd(int index) async {
    setState(() {
      reorderingIndex = null;
    });
    await const Vibration(milliseconds: 100).emit();
  }

  Widget buildResetButton() {
    return IconButton(
      icon: const Icon(Icons.replay),
      onPressed: () async {
        if (!listEquals(currentHomeItems, defaultOrder)) {
          final confirm = await context.showRequest(
              title: i18n.settingsHomeRearrangeResetRequest,
              desc: i18n.settingsHomeRearrangeResetRequestDesc,
              yes: i18n.yes,
              no: i18n.no);
          if (confirm == true) {
            setState(() {
              isA = !isA;
              currentHomeItems = [...defaultOrder];
            });
          }
        }
      },
    );
  }

  Widget buildReorderableList(BuildContext ctx, List<FType> items, {Key? key}) {
    return ReorderableListView(
      key: key,
      onReorder: (oldIndex, newIndex) => _onReorder(items, oldIndex, newIndex),
      onReorderStart: _onReorderStart,
      onReorderEnd: _onReorderEnd,
      proxyDecorator: (child, index, animation) {
        return DecoratedBoxTransition(
          decoration: DecorationTween(
                  begin: BoxDecoration(
                      boxShadow: const [BoxShadow(color: Colors.transparent, blurRadius: 8)],
                      borderRadius: BorderRadius.circular(12)),
                  end: BoxDecoration(
                      boxShadow: [BoxShadow(color: context.fgColor, blurRadius: 8)],
                      borderRadius: BorderRadius.circular(12)))
              .animate(animation),
          child: child,
        );
      },
      children: buildWidgetItems(ctx, items),
    );
  }

  List<Widget> buildWidgetItems(BuildContext ctx, List<FType> homeItems) {
    final List<Widget> listItems = [];
    for (int i = 0; i < homeItems.length; ++i) {
      Widget card = Card(
        key: ValueKey(i),
        child: _buildFType(i, homeItems[i]),
      );
      if (reorderingIndex != null) {
        card = card.shaking(
          key: ValueKey(i),
          i,
        );
      }
      /* TODO: index will cause the same key issue, try to make another personalization system
      final ftype = homeItems[i];
      if (ftype == FType.separator) {
        card = Dismissible(
          key: ValueKey(i),
          child: card,
          onDismissed: (dir) {
            setState(() {
              homeItems.removeAt(i);
            });
          },
        );
      }*/

      listItems.add(card);
    }
    return listItems;
  }

  Widget _buildFType(i, FType type) {
    if (type == FType.separator) {
      return const ListTile(
        title: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          child: Divider(thickness: 12),
        ),
      );
    } else {
      return ListTile(
        trailing: const Icon(Icons.menu),
        title: Text(
          type.localized(),
        ),
      );
    }
  }
}

extension _Shaking on Widget {
  Widget shaking(int i, {Key? key}) {
    return ShakeWidget(
      key: key,
      duration: Duration(seconds: rnd.getInt(5, 8)),
      shakeConstant: allLittleShaking[Random(i).nextInt(allLittleShaking.length)],
      autoPlay: true,
      enableWebMouseHover: true,
      child: this,
    );
  }
}
