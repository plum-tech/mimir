import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/design/widgets/card.dart';

class EntryAction {
  final IconData? icon;
  final IconData? cupertinoIcon;
  final bool main;
  final String label;
  final Future<void> Function()? action;

  EntryAction({
    required this.label,
    this.main = false,
    this.icon,
    this.cupertinoIcon,
    this.action,
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

  EntryDeleteAction({
    required this.label,
    required this.action,
  });
}

class EntryCard extends StatelessWidget {
  final bool selected;
  final List<Widget> children;
  final List<EntryAction> Function(BuildContext context) actions;
  final EntrySelectAction Function(BuildContext context) selectAction;
  final EntryDeleteAction Function(BuildContext context)? deleteAction;

  const EntryCard({
    super.key,
    required this.selected,
    required this.children,
    required this.actions,
    required this.selectAction,
    this.deleteAction,
  });

  @override
  Widget build(BuildContext context) {
    return isCupertino ? buildCupertinoCard(context) : buildMaterialCard(context);
  }

  Widget buildMaterialCard(BuildContext context) {
    final actions = this.actions(context);
    final body = [
      ...children,
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
        final selectAction = this.selectAction(context);
        final deleteAction = this.deleteAction?.call(context);
        return CupertinoContextMenu.builder(
          enableHapticFeedback: true,
          actions: buildContextMenuActions(
            context,
            actions: actions,
            selectAction: selectAction,
            deleteAction: deleteAction,
          ),
          builder: (context, animation) {
            return buildCupertinoCardBody(
              context,
              selectAction: selectAction,
              showMoreAction: animation.value <= 0,
            );
          },
        );
      },
    );
  }

  Widget buildCupertinoCardBody(
    BuildContext context, {
    required bool showMoreAction,
    required EntrySelectAction selectAction,
  }) {
    final body = [
      ...children,
      if (showMoreAction)
        OverflowBar(
          alignment: MainAxisAlignment.end,
          children: [
            CupertinoButton(
              onPressed: selected ? null : selectAction.action,
              child: selected
                  ? Icon(CupertinoIcons.check_mark, color: context.colorScheme.primary)
                  : const Icon(CupertinoIcons.square),
            ),
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
            child: ListTile(
              leading: Icon(action.icon),
              title: action.label.text(),
              enabled: callback != null,
              onTap: callback == null
                  ? null
                  : () async {
                      ctx.navigator.pop();
                      await callback();
                    },
            ),
          ));
        }
        final deleteAction = this.deleteAction;
        if (deleteAction != null) {
          final deleteActionWidget = deleteAction(context);
          all.add(PopupMenuItem(
            child: ListTile(
              leading: const Icon(Icons.delete, color: Colors.redAccent),
              title: deleteActionWidget.label.text(style: const TextStyle(color: Colors.redAccent)),
              onTap: () async {
                ctx.navigator.pop();
                await deleteActionWidget.action?.call();
              },
            ),
          ));
        }
        return all;
      },
    );
  }
}
