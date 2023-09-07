import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mimir/design/widgets/card.dart';

import '../entity/contact.dart';
import '../widgets/contact.dart';

class GroupedContactList extends StatefulWidget {
  final Map<String, List<SchoolContact>> contacts;

  const GroupedContactList(this.contacts, {super.key});

  @override
  State<GroupedContactList> createState() => _GroupedContactListState();
}

class _GroupedContactListState extends State<GroupedContactList> {
  @override
  Widget build(BuildContext context) {
    final contacts = widget.contacts.values.flattened.toList();
    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (ctx, i) {
        final contact = contacts[i];
        return ContactTile(contact).inOutlinedCard();
      },
    );
  }
}
