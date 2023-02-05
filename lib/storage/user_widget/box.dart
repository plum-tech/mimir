import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:mimir/design/page/common.dart';
import 'package:mimir/design/user_widgets/view.dart';
import 'package:mimir/l10n/extension.dart';
import 'package:mimir/user_widget/page_grouper.dart';
import 'package:mimir/user_widget/placeholder_future_builder.dart';
import 'package:rettulf/rettulf.dart';

import '../using.dart';

class BoxSection extends StatefulWidget {
  final String boxName;
  final Box<dynamic>? box;

  const BoxSection({super.key, this.box, required this.boxName});

  @override
  State<StatefulWidget> createState() => _BoxSectionState();
}

class _BoxSectionState extends State<BoxSection> {
  String get boxName => widget.boxName;

  Box<dynamic>? get box => widget.box;

  Widget buildTitle(BuildContext ctx) {
    final b = box;
    final boxNameStyle = ctx.textTheme.displayLarge;
    final title = Text(boxName, style: boxNameStyle);
    if (b != null && kDebugMode) {
      return CupertinoContextMenu(
        actions: [
          CupertinoContextMenuAction(
            trailingIcon: CupertinoIcons.clear,
            onPressed: () async {
              ctx.navigator.pop();
              final confirm = await _showDeleteBoxRequest(ctx);
              if (confirm == true) {
                b.clear();
                // Add a delay to ensure the box is really empty.
                await Future.delayed(const Duration(milliseconds: 500));
                if (!mounted) return;
                setState(() {});
              }
            },
            isDestructiveAction: true,
            child: i18n.clear.text(),
          )
        ],
        previewBuilder: (ctx, ani, child) => child.padSymmetric(h: 40, v: 20).inCard(),
        child: title,
      );
    } else {
      return title;
    }
  }

  @override
  Widget build(BuildContext context) {
    final curBox = box;
    return [
      buildTitle(context),
      if (curBox == null) Placeholders.loading() else BoxItemList(box: curBox),
    ].column(mas: MainAxisSize.min).sized(w: double.infinity).padAll(20).inCard();
  }
}

class BoxItemList extends StatefulWidget {
  final Box<dynamic> box;

  const BoxItemList({super.key, required this.box});

  @override
  State<BoxItemList> createState() => _BoxItemListState();
}

class _BoxItemListState extends State<BoxItemList> {
  int currentPage = 0;
  static const pageSize = 6;

  @override
  Widget build(BuildContext context) {
    final box = widget.box;
    if (box.isEmpty) {
      return i18n.emptyContent.text(style: context.textTheme.displayMedium).padAll(10);
    } else {
      return buildList(context);
    }
  }

  Widget buildList(BuildContext ctx) {
    final keys = widget.box.keys.toList();
    final length = keys.length;
    if (length < pageSize) {
      return buildBoxItems(ctx, keys);
    } else {
      final start = currentPage * pageSize;
      var totalPages = length ~/ pageSize;
      if (length % pageSize != 0) {
        totalPages++;
      }
      final end = min(start + pageSize, length);
      return [
        buildPaginated(ctx, totalPages).padAll(10),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastLinearToSlowEaseIn,
          child: buildBoxItems(ctx, keys.sublist(start, end)),
        ),
      ].column();
    }
  }

  Widget buildBoxItems(BuildContext ctx, List<dynamic> keys) {
    final routeStyle = context.textTheme.titleMedium;
    final typeStyle = context.textTheme.bodySmall;
    final contentStyle = context.textTheme.bodyText2;
    return keys
        .map((e) => BoxItem(
              boxKey: e,
              box: widget.box,
              routeStyle: routeStyle,
              typeStyle: typeStyle,
              contentStyle: contentStyle,
              onBoxChanged: () {
                if (!mounted) return;
                setState(() {});
              },
            ))
        .toList()
        .column();
  }

  Widget buildPaginated(BuildContext ctx, int totalPage) {
    return PageGrouper(
      paginateButtonStyles: PageBtnStyles(),
      preBtnStyles: SkipBtnStyle(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
      ),
      onPageChange: (number) {
        setState(() {
          currentPage = number - 1;
        });
      },
      totalPage: totalPage,
      btnPerGroup: (ctx.mediaQuery.size.width / 50.w).round().clamp(1, totalPage),
      currentPageIndex: currentPage + 1,
    );
  }
}

class BoxItem extends StatefulWidget {
  final TextStyle? routeStyle;

  final TextStyle? typeStyle;
  final TextStyle? contentStyle;
  final dynamic boxKey;
  final Box<dynamic> box;
  final VoidCallback? onBoxChanged;

  const BoxItem({
    super.key,
    this.routeStyle,
    this.typeStyle,
    this.contentStyle,
    required this.boxKey,
    required this.box,
    this.onBoxChanged,
  });

  @override
  State<BoxItem> createState() => _BoxItemState();

  static Widget skeleton(TextStyle? routeStyle, TextStyle? typeStyle, TextStyle? contentStyle) => [
        Text(
          "...",
          style: routeStyle,
        ),
        Text("...", style: typeStyle),
        Text(
          '.........',
          maxLines: 3,
          style: contentStyle,
        ),
      ].column(caa: CrossAxisAlignment.start).align(at: Alignment.topLeft).padAll(10).inCard(elevation: 5);
}

class _BoxItemState extends State<BoxItem> {
  @override
  Widget build(BuildContext context) {
    final key = widget.boxKey.toString();
    final value = widget.box.get(widget.boxKey);
    final type = value.runtimeType.toString();
    Widget res = [
      Text(
        key,
        style: widget.routeStyle,
      ),
      Text(type, style: widget.typeStyle?.copyWith(color: Editor.isSupport(value) ? Colors.green : null)),
      Text(
        '$value',
        maxLines: 5,
        style: widget.contentStyle?.copyWith(overflow: TextOverflow.ellipsis),
      ),
    ].column(caa: CrossAxisAlignment.start).align(at: Alignment.topLeft).padAll(10).inCard(elevation: 5);
    if (value != null) {
      if (kDebugMode) {
        res = res.on(tap: () async => showContentDialog(context, widget.box, key, value));
        //res = buildContextMenu(context, res, key, widget.box);
        res = buildSwipe(context, res, key, value);
      } else {
        res = res.on(tap: () async => showContentDialog(context, widget.box, key, value, readonly: true));
      }
    }
    return res;
  }

  Widget buildSwipe(BuildContext ctx, Widget w, String key, dynamic value) {
    final DismissDirection dir;
    if (value == null) {
      dir = DismissDirection.none;
    } else if (_canEmptyValue(value)) {
      dir = DismissDirection.horizontal;
    } else {
      dir = DismissDirection.endToStart;
    }
    return Dismissible(
      key: ValueKey(key),
      direction: dir,
      confirmDismiss: (dir) async {
        if (dir == DismissDirection.startToEnd) {
          // Empty the value
          final confirm = await context.showRequest(
              title: i18n.warning,
              desc: i18n.localStorageEmptyValueDesc,
              yes: i18n.confirm,
              no: i18n.cancel,
              highlight: true);
          if (confirm == true) {
            widget.box.put(key, _emptyValue(value));
            if (!mounted) return false;
            setState(() {});
          }
          return false;
        } else if (dir == DismissDirection.endToStart) {
          // Delete the item.
          final confirm = await _showDeleteItemRequest(ctx);
          if (confirm == true) {
            widget.box.delete(key);
            widget.onBoxChanged?.call();
            return true;
          }
        }
        return false;
      },
      child: w,
    );
  }

  Future<void> showContentDialog(BuildContext context, Box<dynamic> box, String key, dynamic value,
      {bool readonly = false}) async {
    if (readonly || !Editor.isSupport(value)) {
      await Editor.showReadonlyEditor(context, key, value);
    } else {
      final newValue = await Editor.showAnyEditor(context, value, desc: key);
      bool isModified = value != newValue;
      if (isModified) {
        box.put(key, newValue);
        if (!mounted) return;
        setState(() {});
      }
    }
  }
}

class StorageBox extends StatefulWidget {
  final Map<String, Future<Box<dynamic>>> name2box;

  const StorageBox(this.name2box, {super.key});

  @override
  State<StorageBox> createState() => _StorageBoxState();
}

class _StorageBoxState extends State<StorageBox> {
  String? selectedBoxName;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: i18n.localStorageTitle.text(),
          elevation: 0,
        ),
        body: [
          buildBoxIntroduction(ctx).expanded(),
          const VerticalDivider(
            thickness: 5,
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: buildBoxContentView(ctx),
          ).padAll(10).flexible(flex: 2)
        ].row());
  }

  Widget buildBoxIntroduction(BuildContext ctx) {
    final boxNameStyle = context.textTheme.headlineMedium;
    final list = widget.name2box.entries.map((e) {
      final name2Box = e;
      final color = name2Box.key == selectedBoxName ? ctx.theme.secondaryHeaderColor : null;
      Widget preview = name2Box.key.text(style: boxNameStyle).padAll(10).inCard(elevation: 3, color: color).on(tap: () {
        if (selectedBoxName != name2Box.key) {
          setState(() {
            selectedBoxName = name2Box.key;
          });
        }
      });
      if (kDebugMode) {
        preview = Dismissible(
          key: ValueKey(e.key),
          direction: DismissDirection.startToEnd,
          confirmDismiss: (dir) async {
            final box = await name2Box.value;
            if (!mounted) return true;
            final confirm = await _showDeleteBoxRequest(ctx);
            if (confirm == true) {
              if (!mounted) return true;
              setState(() {
                box.clear();
              });
            }
            return true;
          },
          child: preview,
        );
      }
      return preview;
    }).toList();
    return list.scrolledWithBar();
  }

  Widget buildBoxContentView(BuildContext ctx) {
    final name = selectedBoxName;
    if (name == null) {
      return _buildUnselectBoxTip(ValueKey(name), ctx);
    } else {
      final boxGetter = widget.name2box[name];
      final key = ValueKey(name);
      if (boxGetter == null) {
        return _buildUnselectBoxTip(key, ctx);
      } else {
        final routeStyle = context.textTheme.titleMedium;
        final typeStyle = context.textTheme.bodySmall;
        final contentStyle = context.textTheme.bodyMedium;
        return PlaceholderFutureBuilder<Box<dynamic>>(
            key: key,
            future: boxGetter,
            builder: (ctx, box, _) {
              final Widget res;
              if (box == null) {
                res = [
                  BoxItem.skeleton(routeStyle, typeStyle, contentStyle),
                  BoxItem.skeleton(routeStyle, typeStyle, contentStyle),
                  BoxItem.skeleton(routeStyle, typeStyle, contentStyle),
                ].column();
              } else {
                if (box.isEmpty) {
                  res = _buildEmptyBoxTip(key, ctx);
                } else {
                  res = box.keys
                      .map((e) => BoxItem(
                            boxKey: e,
                            box: box,
                            routeStyle: routeStyle,
                            typeStyle: typeStyle,
                            contentStyle: contentStyle,
                            onBoxChanged: () {
                              if (!mounted) return;
                              setState(() {});
                            },
                          ))
                      .toList()
                      .scrolledWithBar();
                }
              }
              return res.align(
                at: Alignment.topCenter,
              );
            });
      }
    }
  }

  Widget _buildUnselectBoxTip(Key? key, BuildContext ctx) {
    return LeavingBlank(key: key, icon: Icons.unarchive_outlined, desc: i18n.settingsStorageSelectTip);
  }

  Widget _buildEmptyBoxTip(Key? key, BuildContext ctx) {
    return LeavingBlank(key: key, icon: Icons.inbox_outlined, desc: i18n.emptyContent).sized(h: 300);
  }
}

/// THIS IS VERY DANGEROUS!!!
dynamic _emptyValue(dynamic value) {
  if (value is String) {
    return "";
  } else if (value is bool) {
    return false;
  } else if (value is int) {
    return 0;
  } else if (value is double) {
    return 0.0;
  } else if (value is List) {
    value.clear();
    return value;
  } else if (value is Set) {
    value.clear();
    return value;
  } else if (value is Map) {
    value.clear();
    return value;
  } else {
    return value;
  }
}

dynamic _canEmptyValue(dynamic value) {
  return value is String ||
      value is bool ||
      value is int ||
      value is double ||
      value is List ||
      value is Set ||
      value is Map;
}

Future<bool?> _showDeleteBoxRequest(BuildContext ctx) async {
  return await ctx.showRequest(
      title: i18n.delete, desc: i18n.localStorageClearBoxDesc, yes: i18n.confirm, no: i18n.cancel, highlight: true);
}

Future<bool?> _showDeleteItemRequest(BuildContext ctx) async {
  return await ctx.showRequest(
      title: i18n.delete, desc: i18n.localStorageDeleteItemDesc, yes: i18n.delete, no: i18n.cancel, highlight: true);
}
