import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import '../i18n.dart';

class EduEmailOutboxPage extends StatefulWidget {
  const EduEmailOutboxPage({super.key});

  @override
  State<EduEmailOutboxPage> createState() => _EduEmailOutboxPageState();
}

class _EduEmailOutboxPageState extends State<EduEmailOutboxPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: i18n.outbox.title.text(),
          ),
        ],
      ),
    );
  }
}
