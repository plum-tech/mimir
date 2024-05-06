import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:sit/design/adaptive/multiplatform.dart';

import '../entity/contact.dart';
import 'list.dart';

class YellowPageSearchDelegate extends SearchDelegate<SchoolContact> {
  final List<SchoolContact> contacts;

  YellowPageSearchDelegate(this.contacts) : super();

  @override
  List<Widget>? buildActions(BuildContext context) {
    return <Widget>[
      PlatformIconButton(
        icon: Icon(context.icons.clear),
        onPressed: () => query = "",
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) return const SizedBox();
    final matched = contacts.where((e) => predicate(query, e)).toList();
    return SchoolContactList(matched);
  }

  @override
  void showResults(BuildContext context) {
    super.showResults(context);
    final matched = contacts.where((e) => predicate(query, e)).toList();
    if (matched.length == 1) {
      close(context, matched[0]);
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) return const SizedBox();
    final searched = contacts.where((e) => predicate(query, e)).toList();
    return SchoolContactList(searched);
  }

  bool predicate(String query, SchoolContact contact) {
    query = query.toLowerCase();
    final name = contact.name?.toLowerCase();
    final department = contact.department.toLowerCase();
    final description = contact.description?.toLowerCase();
    return department.contains(query) ||
        (name != null && name.contains(query)) ||
        (description != null && description.contains(query)) ||
        contact.phone.contains(query);
  }
}
