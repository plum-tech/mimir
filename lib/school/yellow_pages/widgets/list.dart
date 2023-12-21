import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:sit/design/widgets/card.dart';
import 'package:sit/design/widgets/grouped.dart';
import 'package:sit/school/yellow_pages/init.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/contact.dart';
import 'contact.dart';

class SchoolContactList extends StatefulWidget {
  final List<SchoolContact> contacts;
  final bool Function(int index, int length)? isInitialExpanded;

  const SchoolContactList(
    this.contacts, {
    super.key,
    this.isInitialExpanded,
  });

  @override
  State<SchoolContactList> createState() => _SchoolContactListState();
}

class _SchoolContactListState extends State<SchoolContactList> {
  late Map<String, List<SchoolContact>> department2contacts;

  @override
  void initState() {
    super.initState();
    updateGroupedContacts();
  }

  @override
  void didUpdateWidget(covariant SchoolContactList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.contacts.equals(oldWidget.contacts)) {
      updateGroupedContacts();
    }
  }

  void updateGroupedContacts() {
    department2contacts = widget.contacts.groupListsBy((contact) => contact.department);
  }

  @override
  Widget build(BuildContext context) {
    final history = YellowPagesInit.storage.interactHistory;
    return CustomScrollView(
      slivers: department2contacts.entries
          .mapIndexed(
            (i, entry) => GroupedSection(
              headerBuilder: (expanded, toggleExpand, defaultTrailing) {
                return ListTile(
                  title: entry.key.text(),
                  titleTextStyle: context.textTheme.titleMedium,
                  onTap: toggleExpand,
                  trailing: defaultTrailing,
                );
              },
              initialExpanded: widget.isInitialExpanded?.call(i, department2contacts.length) ?? true,
              itemCount: entry.value.length,
              itemBuilder: (ctx, i) {
                final contact = entry.value[i];
                final inHistory = history?.any((e) => e == contact);
                return ContactTile(contact, inHistory: inHistory).inFilledCard();
              },
            ),
          )
          .toList(),
    );
  }
}
