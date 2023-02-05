import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/contact.dart';
import '../init.dart';
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
    final service = YellowPagesInit.contactRemoteDao;
    final contacts = await service.getAllContacts();

    YellowPagesInit.contactStorageDao.clear();
    YellowPagesInit.contactStorageDao.addAll(contacts);
    return contacts;
  }

  @override
  void initState() {
    super.initState();
    _contacts = YellowPagesInit.contactStorageDao.getAllContacts();
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
        title: i18n.ftype_yellowPages.text(),
        actions: [
          if (contacts != null)
            IconButton(
                onPressed: () => showSearch(context: context, delegate: Search(contacts)),
                icon: const Icon(Icons.search)),
          _buildRefreshButton(),
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

  Widget _buildRefreshButton() {
    return IconButton(
      tooltip: i18n.refresh,
      icon: const Icon(Icons.refresh),
      onPressed: () {
        _fetchContactList().then((value) {
          if (!mounted) return;
          setState(() {
            _contacts = value;
          });
        });
      },
    );
  }
}
