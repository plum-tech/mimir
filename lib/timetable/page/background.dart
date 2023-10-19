import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

class TimetableBackgroundEditor extends StatefulWidget {
  const TimetableBackgroundEditor({super.key});

  @override
  State<TimetableBackgroundEditor> createState() => _TimetableBackgroundEditorState();
}

class _TimetableBackgroundEditorState extends State<TimetableBackgroundEditor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: "Background".text(),
          ),
        ],
      ),
    );
  }
  Widget buildImage(){
    return const Placeholder();
  }
}
