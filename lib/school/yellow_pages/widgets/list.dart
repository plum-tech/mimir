import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mimir/design/widgets/card.dart';
import 'package:mimir/design/widgets/grouped.dart';
import 'package:mimir/school/yellow_pages/init.dart';
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
              initialExpanded: widget.isInitialExpanded?.call(i, department2contacts.length) ?? true,
              title: entry.key.text(),
              items: entry.value,
              itemBuilder: (ctx, i, contact) {
                final inHistory = history?.any((e) => e.phone == contact.phone);
                return ContactTile(contact, inHistory: inHistory).inOutlinedCard();
              },
            ),
          )
          .toList(),
    );
  }
}
