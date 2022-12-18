import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/contact.dart';
import '../page/list.dart';

class Search extends SearchDelegate<String> {
  final List<ContactData> contacts;

  Search(this.contacts) : super();

  @override
  List<Widget>? buildActions(BuildContext context) {
    return <Widget>[IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear))];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    final searched = contacts.where((e) => _search(query, e)).toList();
    return context.isPortrait ? GroupedContactList(searched) : NavigationContactList(searched);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isNotEmpty) {
      final searched = contacts.where((e) => _search(query, e)).toList();
      if (searched.isNotEmpty) {
        return context.isPortrait ? GroupedContactList(searched) : NavigationContactList(searched);
      }
    }
    return const SizedBox();
  }

  bool _search(String query, ContactData contactData) {
    query = query.toLowerCase();
    final name = contactData.name?.toLowerCase();
    final department = contactData.department.toLowerCase();
    final description = contactData.description?.toLowerCase();
    return department.contains(query) ||
        (name != null && name.contains(query)) ||
        (description != null && description.contains(query)) ||
        contactData.phone.contains(query);
  }
}
