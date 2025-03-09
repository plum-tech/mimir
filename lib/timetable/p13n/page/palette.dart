import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:mimir/design/entity/dual_color.dart';

import '../../i18n.dart';
import '../builtin.dart';
import '../widget/style.dart';
import '../../widget/timetable/weekly.dart';

class TimetableP13nLivePreview extends StatelessWidget {
  const TimetableP13nLivePreview({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, box) {
      final height = box.maxHeight.isFinite ? box.maxHeight : context.mediaQuery.size.height / 2;
      return buildLivePreview(context, fullSize: Size(box.maxWidth, height));
    });
  }

  Widget buildLivePreview(
    BuildContext context, {
    required Size fullSize,
  }) {
    final style = TimetableStyle.of(context);
    final cellStyle = style.cellStyle;
    final palette = style.platte;
    final cellSize = Size(fullSize.width / 5, fullSize.height / 3);
    final themeColor = context.colorScheme.primary;
    Widget buildCell({
      required int colorId,
      required String name,
      required String place,
      required List<String> teachers,
      bool grayOut = false,
    }) {
      final colorEntry = palette.safeGetColor(colorId);
      final textColor = colorEntry.textColorBy(context);
      var color = colorEntry.colorBy(context);
      color = cellStyle.decorateColor(color, themeColor: themeColor, isLessonTaken: grayOut);
      return TweenAnimationBuilder(
        tween: ColorTween(begin: color, end: color),
        duration: const Duration(milliseconds: 300),
        builder: (ctx, value, child) => CourseCell(
          courseName: name,
          color: value!,
          textColor: textColor,
          place: place,
          teachers: cellStyle.showTeachers ? teachers : null,
        ),
      );
    }

    Widget livePreview(
      int index, {
      required int colorId,
      bool grayOut = false,
    }) {
      final data = i18n.p13n.livePreview(index);
      return buildCell(
        colorId: colorId,
        name: data.name,
        place: data.place,
        teachers: data.teachers,
        grayOut: grayOut,
      );
    }

    final grayOut = cellStyle.grayOutTakenLessons;
    return CarouselSlider.builder(
      itemCount: palette.colors.length,
      options: CarouselOptions(
        height: cellSize.height,
        viewportFraction: 0.24,
        enableInfiniteScroll: true,
        padEnds: false,
        autoPlay: true,
        autoPlayInterval: const Duration(milliseconds: 1500),
        autoPlayCurve: Curves.fastEaseInToSlowEaseOut,
      ),
      itemBuilder: (BuildContext context, int i, int pageViewIndex) {
        return livePreview(i % 4, colorId: i, grayOut: grayOut && i % 4 < 2).padH(8);
      },
    );
  }
}
