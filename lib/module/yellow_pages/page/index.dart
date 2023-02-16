import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/contact.dart';
import '../using.dart';
import 'list.dart';
import 'search.dart';

class YellowPagesPage extends StatefulWidget {
  const YellowPagesPage({super.key});

  @override
  State<YellowPagesPage> createState() => _YellowPagesPageState();
}

class _YellowPagesPageState extends State<YellowPagesPage> {
  List<ContactData>? _contacts;

  Future<List<ContactData>> _fetchContactList() async {
    String jsonData = await rootBundle.loadString("assets/yellow_pages.json");
    List list = await jsonDecode(jsonData);
    return list.map((e) => ContactData.fromJson(e)).toList().cast<ContactData>();
  }

  @override
  void initState() {
    super.initState();
    _fetchContactList().then((value) {
      if (!mounted) return;
      setState(() {
        _contacts = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final contacts = _contacts;
    return Scaffold(
      appBar: AppBar(
        title: FType.yellowPages.l10nName().text(),
        actions: [
          if (contacts != null)
            IconButton(
              onPressed: () => showSearch(context: context, delegate: Search(contacts)),
              icon: const Icon(Icons.search),
            ),
        ],
      ),
      body: context.isPortrait ? buildBodyPortrait(context) : buildBodyLandscape(context),
    );
  }

  Widget buildBodyPortrait(BuildContext ctx) {
    final contacts = _contacts;
    if (contacts == null || contacts.isEmpty) {
      return Placeholders.loading();
    } else {
      return GroupedContactList(contacts);
    }
  }

  Widget buildBodyLandscape(BuildContext ctx) {
    final contacts = _contacts;
    if (contacts == null || contacts.isEmpty) {
      return Placeholders.loading();
    } else {
      return NavigationContactList(contacts);
    }
  }
}
