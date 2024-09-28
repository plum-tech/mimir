import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mimir/design/widget/grouped.dart';
import 'package:mimir/school/yellow_pages/init.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/contact.dart';
import 'contact.dart';

class SchoolContactList extends ConsumerStatefulWidget {
  final List<SchoolDeptContact> contacts;
  final bool Function(int index, int length)? isInitialExpanded;

  const SchoolContactList(
    this.contacts, {
    super.key,
    this.isInitialExpanded,
  });

  @override
  ConsumerState<SchoolContactList> createState() => _SchoolContactListState();
}

class _SchoolContactListState extends ConsumerState<SchoolContactList> {
  // Dispose? screenShotDispose;
  // final scrollAreaKey = GlobalKey();
  // final scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    // screenShotDispose = fitSystemScreenshot.attachToPage(
    //   scrollAreaKey,
    //   scrollController,
    //   scrollController.jumpTo,
    // );
  }

  @override
  void dispose() {
    // screenShotDispose?.call();
    // scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final history = ref.watch(YellowPagesInit.storage.$interactHistory);
    return CustomScrollView(
      // key: scrollAreaKey,
      // controller: scrollController,
      slivers: widget.contacts
          .mapIndexed(
            (i, entry) => GroupedSection(
              headerBuilder: (context, expanded, toggleExpand, defaultTrailing) {
                return ListTile(
                  title: entry.department.text(),
                  titleTextStyle: context.textTheme.titleMedium,
                  onTap: toggleExpand,
                  trailing: defaultTrailing,
                );
              },
              initialExpanded: widget.isInitialExpanded?.call(i, entry.contacts.length) ?? true,
              itemCount: entry.contacts.length,
              itemBuilder: (ctx, i) {
                final contact = entry.contacts[i];
                final inHistory = history?.any((e) => e == contact);
                return SchoolContactTile(contact: contact, inHistory: inHistory);
              },
            ),
          )
          .toList(),
    );
  }
}
