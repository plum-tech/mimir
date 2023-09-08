import 'package:flutter/material.dart';
import 'package:mimir/design/widgets/card.dart';
import 'package:sliver_tools/sliver_tools.dart';

class GroupedSection<T> extends StatefulWidget {
  final bool initialExpanded;
  final Widget? title;
  final Widget? subtitle;
  final Widget Function(BuildContext context, int index, T item) itemBuilder;
  final List<T> items;

  const GroupedSection({
    super.key,
    this.title,
    this.subtitle,
    this.initialExpanded = true,
    required this.items,
    required this.itemBuilder,
  });

  @override
  State<GroupedSection<T>> createState() => _GroupedSectionState();
}

class _GroupedSectionState<T> extends State<GroupedSection<T>> {
  late var expanded = widget.initialExpanded;

  @override
  Widget build(BuildContext context) {
    return MultiSliver(
      pushPinnedChildren: true,
      children: [
        SliverPinnedHeader(
          child: ListTile(
            title: widget.title,
            subtitle: widget.subtitle,
            dense: true,
            onTap: () {
              setState(() {
                expanded = !expanded;
              });
            },
            trailing: IconButton(
              icon: expanded ? const Icon(Icons.expand_less) : const Icon(Icons.expand_more),
              onPressed: () {
                setState(() {
                  expanded = !expanded;
                });
              },
            ),
          ).inFilledCard(),
        ),
        SliverAnimatedPaintExtent(
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastLinearToSlowEaseIn,
          child: SliverList(
            delegate: !expanded
                ? const SliverChildListDelegate.fixed([])
                : SliverChildBuilderDelegate(
                    (ctx, i) {
                      final item = widget.items[i];
                      return widget.itemBuilder(ctx, i, item);
                    },
                    childCount: widget.items.length,
                  ),
          ),
        )
      ],
    );
  }
}
