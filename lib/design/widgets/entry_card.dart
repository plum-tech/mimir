import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/design/widgets/card.dart';
import 'package:super_context_menu/super_context_menu.dart';

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
  final SingleActivator? activator;
  final Future<void> Function() action;

  const EntryAction({
    required this.label,
    this.main = false,
    this.icon,
    this.oneShot = false,
    this.cupertinoIcon,
    required this.action,
    this.activator,
    this.type = EntryActionType.other,
  });

  const EntryAction.edit({
    required this.label,
    this.main = true,
    this.icon = Icons.edit,
    this.cupertinoIcon = CupertinoIcons.pencil,
    required this.action,
    this.activator,
  })  : oneShot = true,
        type = EntryActionType.edit;
}

class EntrySelectAction {
  final String selectLabel;
  final String selectedLabel;
  final Future<void> Function() action;

  EntrySelectAction({
    required this.selectLabel,
    required this.selectedLabel,
    required this.action,
  });
}

class EntryDeleteAction {
  final String label;
  final Future<void> Function() action;

  EntryDeleteAction({
    required this.label,
    required this.action,
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
  final List<Widget> Function(BuildContext context) itemBuilder;
  final Widget Function(BuildContext context, List<Widget> Function(BuildContext context)? actionsBuilder)
      detailsBuilder;
  final List<EntryAction> Function(BuildContext context) actions;
  final EntrySelectAction? Function(BuildContext context) selectAction;
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
    return supportContextMenu ? buildCardWithContextMenu(context) : buildCardWithDropMenu(context);
  }

  Widget buildCardWithDropMenu(BuildContext context) {
    final actions = this.actions(context);
    final mainActions = actions.where((action) => action.main).toList();
    final secondaryActions = actions.where((action) => !action.main).toList();
    final selectAction = this.selectAction(context);

    Widget buildMaterialMainActions() {
      final all = <Widget>[];
      if (selectAction != null) {
        all.add(
          selected
              ? FilledButton.icon(
                  icon: const Icon(Icons.check),
                  onPressed: null,
                  label: selectAction.selectedLabel.text(),
                )
              : FilledButton(
                  onPressed: selectAction.action,
                  child: selectAction.selectLabel.text(),
                ),
        );
      }
      for (final action in mainActions) {
        all.add(OutlinedButton(
          onPressed: action.action,
          child: action.label.text(),
        ));
      }
      return all.wrap(spacing: 4);
    }

    Widget buildSecondaryActionPopup() {
      return PopupMenuButton(
        position: PopupMenuPosition.under,
        padding: EdgeInsets.zero,
        itemBuilder: (ctx) {
          final all = <PopupMenuEntry>[];
          for (final action in secondaryActions) {
            final callback = action.action;
            all.add(PopupMenuItem(
              onTap: () async {
                await callback();
              },
              child: ListTile(
                leading: Icon(action.icon),
                title: action.label.text(),
              ),
            ));
          }
          final deleteAction = this.deleteAction;
          if (deleteAction != null) {
            final deleteActionWidget = deleteAction(context);
            all.add(PopupMenuItem(
              onTap: () async {
                await deleteActionWidget.action();
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

    final body = InkWell(
      child: [
        ...itemBuilder(context),
        OverflowBar(
          alignment: MainAxisAlignment.spaceBetween,
          children: [
            buildMaterialMainActions(),
            buildSecondaryActionPopup(),
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

  Widget buildCardWithContextMenu(BuildContext context) {
    return Builder(
      builder: (context) {
        final actions = this.actions(context);
        final deleteAction = this.deleteAction?.call(context);
        return ContextMenuWidget(
          menuProvider: (MenuRequest request) {
            return Menu(
              children: buildMenuActions(
                context,
                actions: actions,
                selectAction: selectAction(context),
                deleteAction: deleteAction,
              ),
            );
          },
          child: buildCardWithContextMenuBody(
            context,
            selectAction: selectAction(context),
          ),
        );
      },
    );
  }

  Widget buildCardWithContextMenuBody(
    BuildContext context, {
    required EntrySelectAction? selectAction,
  }) {
    Widget body = [
      ...itemBuilder(context),
      OverflowBar(
        alignment: MainAxisAlignment.end,
        children: [
          if (selectAction != null)
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: selected ? null : selectAction.action,
              child: selected
                  ? Icon(CupertinoIcons.check_mark, color: context.colorScheme.primary)
                  : const Icon(CupertinoIcons.square),
            ),
        ],
      ),
    ].column(caa: CrossAxisAlignment.start).padOnly(t: 12, l: 12, r: 8, b: 4);
    final widget = selected
        ? body.inFilledCard(
            clip: Clip.hardEdge,
          )
        : body.inOutlinedCard(
            clip: Clip.hardEdge,
          );
    return widget.onTap(() async {
      await context.show$Sheet$((ctx) => detailsBuilder(context, buildDetailsActions));
    });
  }

  List<MenuAction> buildMenuActions(
    BuildContext context, {
    required List<EntryAction> actions,
    required EntrySelectAction? selectAction,
    required EntryDeleteAction? deleteAction,
  }) {
    final all = <MenuAction>[];
    if (selectAction != null && !selected) {
      final selectCallback = selectAction.action;
      all.add(MenuAction(
        image: MenuImage.icon(CupertinoIcons.check_mark),
        title: selectAction.selectLabel,
        callback: selectCallback,
      ));
    }
    for (final action in actions) {
      final callback = action.action;
      final icon = action.cupertinoIcon ?? action.icon;
      all.add(MenuAction(
        image: icon == null ? null : MenuImage.icon(icon),
        title: action.label,
        activator: action.activator,
        callback: callback,
      ));
    }
    if (deleteAction != null) {
      all.add(MenuAction(
        image: MenuImage.icon(CupertinoIcons.delete),
        title: deleteAction.label,
        attributes: const MenuActionAttributes(destructive: true),
        activator: const SingleActivator(LogicalKeyboardKey.delete),
        callback: deleteAction.action,
      ));
    }
    assert(all.isNotEmpty, "CupertinoContextMenuActions can't be empty");
    return all;
  }

  List<Widget> buildDetailsActions(BuildContext context) {
    final all = <Widget>[];
    final actions = this.actions(context);
    final selectAction = this.selectAction.call(context);
    final deleteAction = this.deleteAction?.call(context);
    final editAction = actions.firstWhereOrNull((action) => action.type == EntryActionType.edit);
    if (editAction != null) {
      all.add(CupertinoButton(
        onPressed: () async {
          if (!context.mounted) return;
          context.navigator.pop();
          await editAction.action();
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
        onPressed: () async {
          await selectAction.action();
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
            onTap: () async {
              if (action.oneShot) {
                if (!context.mounted) return;
                context.navigator.pop();
              }
              await action.action();
            },
          ),
        ),
        if (deleteAction != null) ...[
          const PullDownMenuDivider.large(),
          PullDownMenuItem(
            icon: CupertinoIcons.delete,
            title: deleteAction.label,
            onTap: () async {
              await deleteAction.action();
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
