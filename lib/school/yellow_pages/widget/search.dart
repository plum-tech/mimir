import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:mimir/design/adaptive/multiplatform.dart';

import '../entity/contact.dart';
import '../utils.dart';
import 'list.dart';

class YellowPageSearchDelegate extends SearchDelegate<SchoolContact> {
  final List<SchoolDeptContact> contacts;

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
    if (query.isEmpty) return const SizedBox.shrink();
    final matched = matchSchoolContacts(contacts,query);
    return SchoolContactList(matched);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) return const SizedBox.shrink();
    final matched = matchSchoolContacts(contacts,query);
    return SchoolContactList(matched);
  }
}
