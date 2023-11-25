import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/credentials/init.dart';
import 'package:sit/design/widgets/app.dart';

import './i18n.dart';
import 'page/search.dart';

class LibraryAppCard extends StatefulWidget {
  const LibraryAppCard({super.key});

  @override
  State<LibraryAppCard> createState() => _LibraryAppCardState();
}

class _LibraryAppCardState extends State<LibraryAppCard> {
  final $credentials = CredentialInit.storage.listenLibraryChange();

  @override
  void initState() {
    $credentials.addListener(onCredentialsChanged);
    super.initState();
  }

  @override
  void dispose() {
    $credentials.removeListener(onCredentialsChanged);
    super.dispose();
  }

  void onCredentialsChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final credentials = CredentialInit.storage.libraryCredentials;
    return AppCard(
      title: i18n.title.text(),
      leftActions: [
        FilledButton.icon(
          onPressed: () async {
            await showSearch(context: context, delegate: LibrarySearchDelegate());
          },
          icon: const Icon(Icons.search),
          label: i18n.search.text(),
        ),
        if (credentials == null)
          OutlinedButton(
            onPressed: () async {
              await context.push("/library/login");
            },
            child: "Login".text(),
          )
        else
          OutlinedButton.icon(
            onPressed: () async {
              await context.push("/library/my-borrowed");
            },
            icon: const Icon(Icons.person),
            label: "Me".text(),
          )
      ],
    );
  }
}
