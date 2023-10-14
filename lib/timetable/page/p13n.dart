import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/timetable/entity/platte.dart';

class TimetableP13nPage extends StatefulWidget {
  const TimetableP13nPage({super.key});

  @override
  State<TimetableP13nPage> createState() => _TimetableP13nPageState();
}

class _TimetableP13nPageState extends State<TimetableP13nPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: "Personalization".text(),
          ),
        ],
      ),
    );
  }
}

class PaletteCard extends StatelessWidget {
  final TimetablePalette palette;

  const PaletteCard({
    super.key,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: palette.name.text(),
    );
  }

  Widget buildColor() {
    return const Placeholder();
  }
}
