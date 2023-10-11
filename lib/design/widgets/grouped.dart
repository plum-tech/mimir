import 'package:flutter/material.dart';
import 'package:sit/design/widgets/card.dart';
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
  State<GroupedSection<T>> createState() => _GroupedSectionState<T>();
}

class _GroupedSectionState<T> extends State<GroupedSection<T>> {
  late var expanded = widget.initialExpanded;

  @override
  Widget build(BuildContext context) {
    return MultiSliver(
      pushPinnedChildren: true,
      children: [
        SliverPinnedHeader(
          child: FilledCard(
            clip: Clip.hardEdge,
            child: ListTile(
              title: widget.title,
              subtitle: widget.subtitle,
              dense: true,
              onTap: () {
                setState(() {
                  expanded = !expanded;
                });
              },
              trailing: expanded ? const Icon(Icons.expand_less) : const Icon(Icons.expand_more),
            ),
          ),
        ),
        SliverAnimatedPaintExtent(
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastEaseInToSlowEaseOut,
          child: SliverList(
            delegate: !expanded
                ? const SliverChildListDelegate.fixed([])
                : SliverChildBuilderDelegate(
                    childCount: widget.items.length,
                    (ctx, i) {
                      final item = widget.items[i];
                      return widget.itemBuilder(ctx, i, item);
                    },
                  ),
          ),
        )
      ],
    );
  }
}

class AsyncGroupSection<T> extends StatefulWidget {
  final bool initialExpanded;
  final Widget? title;
  final Widget? subtitle;
  final Future<List<T>> Function() fetch;
  final Widget Function(BuildContext context, int index, T item) itemBuilder;

  const AsyncGroupSection({
    super.key,
    this.title,
    this.subtitle,
    this.initialExpanded = true,
    required this.fetch,
    required this.itemBuilder,
  });

  @override
  State<AsyncGroupSection<T>> createState() => _AsyncGroupSectionState<T>();
}

class _AsyncGroupSectionState<T> extends State<AsyncGroupSection<T>> {
  late var expanded = widget.initialExpanded;
  List<T>? items;
  bool isFetching = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialExpanded) {
      fetchData();
    }
  }

  Future<void> fetchData() async {
    if (items != null) return;
    setState(() {
      isFetching = true;
    });
    final data = await widget.fetch();
    setState(() {
      items = data;
      isFetching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = this.items;
    return MultiSliver(
      pushPinnedChildren: true,
      children: [
        SliverPinnedHeader(
          child: FilledCard(
            clip: Clip.hardEdge,
            child: ListTile(
              title: widget.title,
              subtitle: widget.subtitle,
              dense: true,
              onTap: () async {
                setState(() {
                  expanded = !expanded;
                });
                await fetchData();
              },
              trailing: isFetching
                  ? const CircularProgressIndicator()
                  : expanded
                      ? const Icon(Icons.expand_less)
                      : const Icon(Icons.expand_more),
            ),
          ),
        ),
        SliverAnimatedPaintExtent(
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastEaseInToSlowEaseOut,
          child: SliverList(
            delegate: !expanded || items == null
                ? const SliverChildListDelegate.fixed([])
                : SliverChildBuilderDelegate(
                    childCount: items.length,
                    (ctx, i) {
                      final item = items[i];
                      return widget.itemBuilder(ctx, i, item);
                    },
                  ),
          ),
        )
      ],
    );
  }
}
