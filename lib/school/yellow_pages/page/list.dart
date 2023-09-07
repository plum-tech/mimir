import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mimir/design/widgets/card.dart';

import '../entity/contact.dart';
import '../widgets/contact.dart';

class SchoolContactList extends StatefulWidget {
  final List<SchoolContact> contacts;

  const SchoolContactList(this.contacts, {super.key});

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
    final contacts = widget.contacts;
    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (ctx, i) {
        final contact = contacts[i];
        return ContactTile(contact).inOutlinedCard();
      },
    );
  }
}
