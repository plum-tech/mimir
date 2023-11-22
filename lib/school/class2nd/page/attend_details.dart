import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/school/class2nd/widgets/score.dart';
import 'package:text_scroll/text_scroll.dart';

import '../entity/attended.dart';
import '../utils.dart';

class Class2ndAttendDetailsPage extends StatefulWidget {
  final Class2ndAttendedActivity activity;

  const Class2ndAttendDetailsPage(
    this.activity, {
    super.key,
  });

  @override
  State<Class2ndAttendDetailsPage> createState() => _Class2ndAttendDetailsPageState();
}

class _Class2ndAttendDetailsPageState extends State<Class2ndAttendDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final (:title, :tags) = separateTagsFromTitle(widget.activity.title);
    final scores = widget.activity.scores;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: TextScroll(title),
          ),
          SliverList.builder(
            itemCount: scores.length,
            itemBuilder: (ctx, i) {
              return Class2ndScoreTile(scores[i]);
            },
          ),
        ],
      ),
    );
  }
}
