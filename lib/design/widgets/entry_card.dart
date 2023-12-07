import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/design/widgets/card.dart';

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

  const EntryAction({
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
  final Widget Function(BuildContext context, List<Widget> Function(BuildContext context)? actionsBuilder)
      detailsBuilder;
  final List<EntryAction> Function(BuildContext context) actions;
  final EntrySelectAction Function(BuildContext context) selectAction;
  final EntryDeleteAction Function(BuildContext context)? deleteAction;

  const EntryCard({
    super.key,
    required this.title,
    required this.selected,
    required this.itemBuilder,
    required this.actions,
    required this.selectAction,
    required this.detailsBuilder,
    this.deleteAction,
  });

  @override
  Widget build(BuildContext context) {
    return isCupertino ? buildCupertinoCard(context) : buildMaterialCard(context);
  }

  Widget buildMaterialCard(BuildContext context) {
    final actions = this.actions(context);
    final body = InkWell(
      child: [
        ...itemBuilder(context, null),
        OverflowBar(
          alignment: MainAxisAlignment.spaceBetween,
          children: [
            buildMaterialMainActions(context, actions.where((action) => action.main).toList()),
            buildMaterialActionPopup(context, actions.where((action) => !action.main).toList()),
          ],
        ),
      ].column(caa: CrossAxisAlignment.start).padSymmetric(v: 10, h: 15),
      onTap: () async {
        await context.show$Sheet$((ctx) => detailsBuilder(context, null));
      },
    );
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
      OverflowBar(
        alignment: MainAxisAlignment.end,
        children: [
          if (animation.value <= 0)
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: selected ? null : selectAction(context).action,
              child: selected
                  ? Icon(CupertinoIcons.check_mark, color: context.colorScheme.primary)
                  : const Icon(CupertinoIcons.square),
            ),
        ],
      ),
    ].column(caa: CrossAxisAlignment.start).padOnly(t: 12, l: 12, r: 8, b: 4);
    if (animation.value <= 0) {
      body = body.inkWell(onTap: () async {
        if (animation.value <= 0) {
          await context.show$Sheet$((ctx) => detailsBuilder(context, buildDetailsActions));
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
        trailingIcon: action.cupertinoIcon ?? action.icon,
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
    return PopupMenuButton(
      position: PopupMenuPosition.under,
      padding: EdgeInsets.zero,
      itemBuilder: (ctx) {
        final all = <PopupMenuEntry>[];
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

  List<Widget> buildDetailsActions(BuildContext context) {
    final all = <Widget>[];
    final actions = this.actions(context);
    final selectAction = this.selectAction.call(context);
    final deleteAction = this.deleteAction?.call(context);
    final editAction = actions.firstWhereOrNull((action) => action.type == EntryActionType.edit);
    if (editAction != null) {
      all.add(CupertinoButton(
        onPressed: editAction.action == null
            ? null
            : () async {
                await editAction.action?.call();
              },
        child: editAction.label.text(),
      ));
      // remove edit action
      actions.retainWhere((action) => action.type != EntryActionType.edit);
      if (!selected) {
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
    } else if (!selected) {
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
            icon: action.cupertinoIcon ?? action.icon,
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
}
