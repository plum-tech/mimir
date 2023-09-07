import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mimir/design/widgets/card.dart';
import 'package:mimir/school/yellow_pages/init.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sliver_tools/sliver_tools.dart';

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
    final isInHistory =
        history == null ? null : (SchoolContact contact) => history.any((e) => e.phone == contact.phone);
    return CustomScrollView(
      slivers: department2contacts.entries
          .mapIndexed(
            (i, entry) => DepartmentSection(
              department: entry.key,
              contacts: entry.value,
              isInHistory: isInHistory,
              initialExpanded: widget.isInitialExpanded?.call(i, department2contacts.length) ?? true,
            ),
          )
          .toList(),
    );
  }
}

class DepartmentSection extends StatefulWidget {
  final bool initialExpanded;
  final String department;
  final List<SchoolContact> contacts;
  final bool Function(SchoolContact contact)? isInHistory;

  const DepartmentSection({
    super.key,
    this.initialExpanded = true,
    required this.department,
    required this.contacts,
    this.isInHistory,
  });

  @override
  State<DepartmentSection> createState() => _DepartmentSectionState();
}

class _DepartmentSectionState extends State<DepartmentSection> {
  late var expanded = widget.initialExpanded;

  @override
  Widget build(BuildContext context) {
    final isInHistory = widget.isInHistory;
    return MultiSliver(
      pushPinnedChildren: true,
      children: [
        SliverPinnedHeader(
          child: ListTile(
            title: widget.department.text(),
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
          duration: const Duration(milliseconds: 150),
          child: SliverList(
            delegate: !expanded
                ? const SliverChildListDelegate.fixed([])
                : SliverChildBuilderDelegate(
                    (ctx, i) {
                      final contact = widget.contacts[i];
                      final inHistory = isInHistory == null ? null : isInHistory(contact);
                      return ContactTile(contact, inHistory: inHistory).inOutlinedCard();
                    },
                    childCount: widget.contacts.length,
                  ),
          ),
        )
      ],
    );
  }
}
