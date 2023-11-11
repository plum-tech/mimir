import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/design/widgets/card.dart';
import 'package:text_scroll/text_scroll.dart';

enum EntryActionType {
  edit,
  share,
  other;
}

class EntryAction {
  final IconData? icon;
  final IconData? cupertinoIcon;
  final bool main;
  final String label;
  final EntryActionType type;
  final bool oneShot;
  final bool delayContextMenu;
  final Future<void> Function()? action;

  EntryAction({
    required this.label,
    this.main = false,
    this.icon,
    this.delayContextMenu = true,
    this.oneShot = false,
    this.cupertinoIcon,
    this.action,
    this.type = EntryActionType.other,
  });
}

class EntrySelectAction {
  final String selectLabel;
  final String selectedLabel;
  final Future<void> Function()? action;

  EntrySelectAction({
    required this.selectLabel,
    required this.selectedLabel,
    required this.action,
  });
}

class EntryDeleteAction {
  final String label;
  final Future<void> Function()? action;
  final bool delayContextMenu;

  EntryDeleteAction({
    required this.label,
    required this.action,
    this.delayContextMenu = true,
  });
}

class EntryDetailsAction {
  final String label;
  final IconData? icon;

  EntryDetailsAction({
    required this.label,
    this.icon,
  });
}

class EntryCard extends StatelessWidget {
  final bool selected;
  final String title;
  final List<Widget> Function(BuildContext context, Animation<double>? animation) itemBuilder;
  final Widget Function(BuildContext context)? detailsBuilder;
  final List<EntryAction> Function(BuildContext context) actions;
  final EntrySelectAction Function(BuildContext context) selectAction;
  final EntryDeleteAction Function(BuildContext context)? deleteAction;
  final EntryDetailsAction Function(BuildContext context) detailsAction;

  const EntryCard({
    super.key,
    required this.title,
    required this.selected,
    required this.itemBuilder,
    required this.actions,
    required this.selectAction,
    required this.detailsAction,
    this.detailsBuilder,
    this.deleteAction,
  });

  @override
  Widget build(BuildContext context) {
    return isCupertino ? buildCupertinoCard(context) : buildMaterialCard(context);
  }

  Widget buildMaterialCard(BuildContext context) {
    final actions = this.actions(context);
    final body = [
      ...itemBuilder(context, null),
      OverflowBar(
        alignment: MainAxisAlignment.spaceBetween,
        children: [
          buildMaterialMainActions(context, actions.where((action) => action.main).toList()),
          buildMaterialActionPopup(context, actions.where((action) => !action.main).toList()),
        ],
      ),
    ].column(caa: CrossAxisAlignment.start).padSymmetric(v: 10, h: 15);
    return selected
        ? body.inFilledCard(
            clip: Clip.hardEdge,
          )
        : body.inOutlinedCard(
            clip: Clip.hardEdge,
          );
  }

  Widget buildCupertinoCard(BuildContext context) {
    return Builder(
      builder: (context) {
        final actions = this.actions(context);
        final deleteAction = this.deleteAction?.call(context);
        return CupertinoContextMenu.builder(
          enableHapticFeedback: true,
          actions: buildContextMenuActions(
            context,
            actions: actions,
            selectAction: selectAction(context),
            deleteAction: deleteAction,
          ),
          builder: (context, animation) {
            return buildCupertinoCardBody(
              context,
              animation: animation,
            );
          },
        );
      },
    );
  }

  Widget buildCupertinoCardBody(
    BuildContext context, {
    required Animation<double> animation,
  }) {
    Widget body = [
      ...itemBuilder(context, animation),
      if (animation.value <= 0)
        OverflowBar(
          alignment: MainAxisAlignment.end,
          children: [
            CupertinoButton(
              onPressed: selected ? null : selectAction(context).action,
              child: selected
                  ? Icon(CupertinoIcons.check_mark, color: context.colorScheme.primary)
                  : const Icon(CupertinoIcons.square),
            ),
          ],
        ),
    ].column(caa: CrossAxisAlignment.start).padOnly(t: 15, l: 15, r: 15);
    if (animation.value <= 0) {
      body = body.inkWell(onTap: () async {
        if (animation.value <= 0) {
          await context.show$Sheet$(
            (ctx) => EntryCupertinoDetailsPage(
              title: title,
              itemBuilder: (ctx) => itemBuilder(ctx, null),
              detailsBuilder: detailsBuilder,
              selected: selected,
              selectAction: selectAction,
              actions: actions,
              deleteAction: deleteAction,
            ),
          );
        }
      });
    }
    final widget = selected
        ? body.inFilledCard(
            clip: Clip.hardEdge,
          )
        : body.inOutlinedCard(
            clip: Clip.hardEdge,
          );
    return widget;
  }

  List<Widget> buildContextMenuActions(
    BuildContext context, {
    required List<EntryAction> actions,
    required EntrySelectAction selectAction,
    required EntryDeleteAction? deleteAction,
  }) {
    final all = <Widget>[];
    if (!selected) {
      final selectCallback = selectAction.action;
      all.add(CupertinoContextMenuAction(
        trailingIcon: CupertinoIcons.check_mark,
        onPressed: selectCallback == null
            ? null
            : () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Future.delayed(const Duration(milliseconds: 336));
                await selectCallback();
              },
        child: selectAction.selectLabel.text(),
      ));
    }
    for (final action in actions) {
      final callback = action.action;
      all.add(CupertinoContextMenuAction(
        trailingIcon: action.cupertinoIcon,
        onPressed: callback == null
            ? null
            : () async {
                Navigator.of(context, rootNavigator: true).pop();
                if (action.delayContextMenu) {
                  await Future.delayed(const Duration(milliseconds: 336));
                }
                await callback();
              },
        child: action.label.text(),
      ));
    }
    if (deleteAction != null) {
      all.add(CupertinoContextMenuAction(
        trailingIcon: CupertinoIcons.delete,
        onPressed: () async {
          Navigator.of(context, rootNavigator: true).pop();
          if (deleteAction.delayContextMenu) {
            await Future.delayed(const Duration(milliseconds: 336));
          }
          await deleteAction.action?.call();
        },
        isDestructiveAction: true,
        child: deleteAction.label.text(),
      ));
    }
    assert(all.isNotEmpty, "CupertinoContextMenuActions can't be empty");
    return all;
  }

  Widget buildMaterialMainActions(BuildContext context, List<EntryAction> mainActions) {
    final all = <Widget>[];
    all.add(buildMaterialSelectAction(context));
    for (final action in mainActions) {
      all.add(OutlinedButton(
        onPressed: action.action,
        child: action.label.text(),
      ));
    }
    return all.wrap(spacing: 4);
  }

  Widget buildMaterialSelectAction(BuildContext context) {
    final selectAction = this.selectAction(context);
    if (selected) {
      return FilledButton.icon(
        icon: const Icon(Icons.check),
        onPressed: null,
        label: selectAction.selectedLabel.text(),
      );
    } else {
      return FilledButton(
        onPressed: selectAction.action,
        child: selectAction.selectLabel.text(),
      );
    }
  }

  Widget buildMaterialActionPopup(BuildContext context, List<EntryAction> secondaryActions) {
    final detailsAction = this.detailsAction(context);
    return PopupMenuButton(
      position: PopupMenuPosition.under,
      padding: EdgeInsets.zero,
      itemBuilder: (ctx) {
        final all = <PopupMenuEntry>[];
        all.add(PopupMenuItem(
          child: ListTile(
            leading: Icon(detailsAction.icon),
            title: detailsAction.label.text(),
          ),
          onTap: () async {
            await context.navigator.push(
              MaterialPageRoute(
                builder: (ctx) => EntryDetailsPage(
                  title: title,
                  itemBuilder: (ctx) => itemBuilder(ctx, null),
                  detailsBuilder: detailsBuilder,
                  selected: selected,
                ),
              ),
            );
          },
        ));
        for (final action in secondaryActions) {
          final callback = action.action;
          all.add(PopupMenuItem(
            onTap: callback == null
                ? null
                : () async {
                    await callback();
                  },
            child: ListTile(
              leading: Icon(action.icon),
              title: action.label.text(),
              enabled: callback != null,
            ),
          ));
        }
        final deleteAction = this.deleteAction;
        if (deleteAction != null) {
          final deleteActionWidget = deleteAction(context);
          all.add(PopupMenuItem(
            onTap: () async {
              await deleteActionWidget.action?.call();
            },
            child: ListTile(
              leading: const Icon(Icons.delete, color: Colors.redAccent),
              title: deleteActionWidget.label.text(style: const TextStyle(color: Colors.redAccent)),
            ),
          ));
        }
        return all;
      },
    );
  }
}

class EntryCupertinoDetailsPage extends StatelessWidget {
  final String title;
  final bool selected;
  final List<EntryAction> Function(BuildContext context) actions;
  final EntrySelectAction Function(BuildContext context)? selectAction;
  final EntryDeleteAction Function(BuildContext context)? deleteAction;
  final List<Widget> Function(BuildContext context) itemBuilder;
  final Widget Function(BuildContext context)? detailsBuilder;

  const EntryCupertinoDetailsPage({
    super.key,
    required this.title,
    required this.itemBuilder,
    this.detailsBuilder,
    required this.actions,
    required this.selectAction,
    required this.selected,
    this.deleteAction,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextScroll(title),
        centerTitle: isCupertino,
        actions: buildActions(context),
      ),
      body: buildBody(context),
    );
  }

  List<Widget> buildActions(BuildContext context) {
    final all = <Widget>[];
    final actions = this.actions(context);
    final selectAction = this.selectAction?.call(context);
    final deleteAction = this.deleteAction?.call(context);
    final editAction = actions.firstWhereOrNull((action) => action.type == EntryActionType.edit);
    if (editAction != null) {
      all.add(CupertinoButton(
        onPressed: editAction.action == null
            ? null
            : () async {
                if (editAction.oneShot) {
                  if (!context.mounted) return;
                  context.navigator.pop();
                }
                await editAction.action?.call();
              },
        child: editAction.label.text(),
      ));
      // remove edit action
      actions.retainWhere((action) => action.type != EntryActionType.edit);
      if (selectAction != null && !selected) {
        actions.insert(
          0,
          EntryAction(
            label: selectAction.selectLabel,
            oneShot: true,
            cupertinoIcon: CupertinoIcons.check_mark,
            action: selectAction.action,
          ),
        );
      }
    } else if (selectAction != null && !selected) {
      all.add(CupertinoButton(
        onPressed: selectAction.action == null
            ? null
            : () async {
                await selectAction.action?.call();
                if (!context.mounted) return;
                context.navigator.pop();
              },
        child: selectAction.selectLabel.text(),
      ));
    }
    all.add(PullDownButton(
      itemBuilder: (context) => [
        ...actions.map(
          (action) => PullDownMenuItem(
            icon: action.cupertinoIcon,
            title: action.label,
            onTap: action.action == null
                ? null
                : () async {
                    if (action.oneShot) {
                      if (!context.mounted) return;
                      context.navigator.pop();
                    }
                    await action.action?.call();
                  },
          ),
        ),
        if (deleteAction != null) ...[
          const PullDownMenuDivider.large(),
          PullDownMenuItem(
            icon: CupertinoIcons.delete,
            title: deleteAction.label,
            onTap: () async {
              await deleteAction.action?.call();
              if (!context.mounted) return;
              context.navigator.pop();
            },
            isDestructive: true,
          ),
        ],
      ],
      buttonBuilder: (context, showMenu) => CupertinoButton(
        onPressed: showMenu,
        padding: EdgeInsets.zero,
        child: const Icon(CupertinoIcons.ellipsis_circle),
      ),
    ));
    return all;
  }

  Widget buildBody(BuildContext context) {
    final detailsBuilder = this.detailsBuilder;
    if (detailsBuilder != null) {
      return detailsBuilder.call(context);
    }
    return itemBuilder(context).column(mas: MainAxisSize.min).padSymmetric(v: 10, h: 15).inFilledCard().center();
  }
}

class EntryDetailsPage extends StatelessWidget {
  final String title;
  final bool selected;
  final List<Widget> Function(BuildContext context) itemBuilder;
  final Widget Function(BuildContext context)? detailsBuilder;

  const EntryDetailsPage({
    super.key,
    required this.title,
    required this.itemBuilder,
    this.detailsBuilder,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextScroll(title),
        centerTitle: isCupertino,
      ),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    final detailsBuilder = this.detailsBuilder;
    if (detailsBuilder != null) {
      return detailsBuilder.call(context);
    }
    return itemBuilder(context).column(mas: MainAxisSize.min).padSymmetric(v: 10, h: 15).inFilledCard().center();
  }
}
