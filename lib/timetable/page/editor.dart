import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sit/design/widgets/card.dart';
import 'package:sit/design/widgets/expansion_tile.dart';
import 'package:sit/l10n/extension.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/l10n/time.dart';
import 'package:sit/school/widgets/course.dart';
import 'package:sit/settings/settings.dart';

import '../entity/timetable.dart';
import '../i18n.dart';

class TimetableEditorPage extends StatefulWidget {
  final SitTimetable timetable;

  const TimetableEditorPage({
    super.key,
    required this.timetable,
  });

  @override
  State<TimetableEditorPage> createState() => _TimetableEditorPageState();
}

class _TimetableEditorPageState extends State<TimetableEditorPage> {
  final _formKey = GlobalKey<FormState>();
  late final $name = TextEditingController(text: widget.timetable.name);
  late final $selectedDate = ValueNotifier(widget.timetable.startDate);
  late final $signature = TextEditingController(text: widget.timetable.signature);
  late var courses = Map.of(widget.timetable.courses);
  late var lastCourseKey = widget.timetable.lastCourseKey;
  var index = 0;

  @override
  void dispose() {
    $name.dispose();
    $selectedDate.dispose();
    $signature.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            title: i18n.import.timetableInfo.text(),
            actions: [
              buildSaveAction(),
            ],
          ),
          if (index == 0) ...buildInfoTab() else ...buildAdvancedTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.info_outline),
            activeIcon: const Icon(Icons.info),
            label: "Info",
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_month_outlined),
            activeIcon: const Icon(Icons.calendar_month),
            label: "Advanced",
          ),
        ],
        onTap: (newIndex) {
          setState(() {
            index = newIndex;
          });
        },
      ),
    );
  }

  List<Widget> buildInfoTab() {
    return [
      SliverList.list(children: [
        buildDescForm(),
        buildStartDate(),
        buildSignature(),
      ]),
    ];
  }

  List<Widget> buildAdvancedTab() {
    final code2Courses = courses.values.groupListsBy((c) => c.courseCode).entries.toList();
    return [
      SliverList.list(children: [
        addCourseTile(),
        const Divider(thickness: 2),
      ]),
      SliverList.builder(
        itemCount: code2Courses.length,
        itemBuilder: (ctx, i) {
          final MapEntry(value: courses) = code2Courses[i];
          final template = courses.first;
          return TimetableEditableCourseCard(
            courses: courses,
            template: template,
            onCourseChanged: (newTemplate){
              setState(() {
                this.courses["${newTemplate.courseKey}"] = newTemplate;
              });
            },
          );
        },
      ),
    ];
  }

  Widget addCourseTile() {
    return ListTile(
      title: "Add course".text(),
      trailing: const Icon(Icons.add),
      onTap: () async {
        final result = await context.show$Sheet$((ctx) => const SitCourseEditorPage(course: null));
      },
    );
  }

  Widget buildStartDate() {
    return ListTile(
      leading: const Icon(Icons.alarm),
      title: i18n.startWith.text(),
      trailing: FilledButton(
        child: $selectedDate >> (ctx, value) => ctx.formatYmdText(value).text(),
        onPressed: () async {
          final date = await _pickTimetableStartDate(context, initial: $selectedDate.value);
          if (date != null) {
            $selectedDate.value = DateTime(date.year, date.month, date.day);
          }
        },
      ),
    );
  }

  Widget buildSignature() {
    return ListTile(
      isThreeLine: true,
      leading: const Icon(Icons.drive_file_rename_outline),
      title: i18n.signature.text(),
      subtitle: TextField(
        controller: $signature,
        decoration: InputDecoration(
          hintText: i18n.signaturePlaceholder,
        ),
      ),
    );
  }

  Widget buildSaveAction() {
    return PlatformTextButton(
      onPressed: () {
        final signature = $signature.text.trim();
        Settings.lastSignature = signature;
        context.pop(widget.timetable.copyWith(
          name: $name.text,
          signature: signature,
          startDate: $selectedDate.value,
        ));
      },
      child: i18n.save.text(),
    );
  }

  Widget buildDescForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: $name,
            maxLines: 1,
            decoration: InputDecoration(
              labelText: i18n.editor.name,
              border: const OutlineInputBorder(),
            ),
          ).padAll(10),
        ],
      ),
    );
  }
}

Future<DateTime?> _pickTimetableStartDate(
  BuildContext ctx, {
  required DateTime initial,
}) async {
  final now = DateTime.now();
  return await showDatePicker(
    context: ctx,
    initialDate: initial,
    currentDate: now,
    firstDate: DateTime(now.year - 2),
    lastDate: DateTime(now.year + 2),
    selectableDayPredicate: (DateTime dataTime) => dataTime.weekday == DateTime.monday,
  );
}

class TimetableEditableCourseCard extends StatelessWidget {
  final SitCourse template;
  final List<SitCourse> courses;
  final Color? color;
  final ValueChanged<SitCourse>? onCourseChanged;

  const TimetableEditableCourseCard({
    super.key,
    required this.template,
    required this.courses,
    this.color,
    this.onCourseChanged,
  });

  @override
  Widget build(BuildContext context) {
    return FilledCard(
      clip: Clip.hardEdge,
      color: color,
      child: AnimatedExpansionTile(
        leading: CourseIcon(courseName: template.courseName),
        title: template.courseName.text(),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () async {
            final newTemplate = await context.show$Sheet$((context) => SitCourseEditorPage.template(course: template));
            onCourseChanged?.call(newTemplate);
          },
        ),
        rotateTrailing: false,
        subtitle: [
          "${i18n.course.courseCode} ${template.courseCode}".text(),
          "${i18n.course.classCode} ${template.classCode}".text(),
        ].column(caa: CrossAxisAlignment.start),
        children: courses.mapIndexed((i, course) {
          final weekNumbers = course.weekIndices.l10n();
          final (:begin, :end) = course.calcBeginEndTimePoint();
          return ListTile(
            isThreeLine: true,
            title: course.place.text(),
            subtitle: [
              course.teachers.join(", ").text(),
              "${Weekday.fromIndex(course.dayIndex).l10n()} ${begin.l10n(context)}–${end.l10n(context)}".text(),
              ...weekNumbers.map((n) => n.text()),
            ].column(mas: MainAxisSize.min, caa: CrossAxisAlignment.start),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                final newItem = await context.show$Sheet$((context) => SitCourseEditorPage.item(course: course));
                onCourseChanged?.call(newItem);
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}

class SitCourseEditorPage extends StatefulWidget {
  final SitCourse? course;
  final bool courseNameEditable;
  final bool courseCodeEditable;
  final bool classCodeEditable;
  final bool campusEditable;
  final bool placeEditable;
  final bool weekIndicesEditable;
  final bool timeslotsEditable;
  final bool courseCreditEditable;
  final bool dayIndexEditable;
  final bool teachersEditable;

  const SitCourseEditorPage({
    super.key,
    required this.course,
    this.courseNameEditable = true,
    this.courseCodeEditable = true,
    this.classCodeEditable = true,
    this.campusEditable = true,
    this.placeEditable = true,
    this.weekIndicesEditable = true,
    this.timeslotsEditable = true,
    this.courseCreditEditable = true,
    this.dayIndexEditable = true,
    this.teachersEditable = true,
  });

  const SitCourseEditorPage.item({
    super.key,
    required this.course,
    this.placeEditable = true,
    this.weekIndicesEditable = true,
    this.timeslotsEditable = true,
    this.dayIndexEditable = true,
    this.teachersEditable = true,
  })  : courseNameEditable = false,
        courseCodeEditable = false,
        classCodeEditable = false,
        campusEditable = false,
        courseCreditEditable = false;

  const SitCourseEditorPage.template({
    super.key,
    required this.course,
  })  : courseNameEditable = true,
        courseCodeEditable = true,
        classCodeEditable = true,
        campusEditable = true,
        courseCreditEditable = true,
        placeEditable = false,
        weekIndicesEditable = false,
        timeslotsEditable = false,
        dayIndexEditable = false,
        teachersEditable = false;

  @override
  State<SitCourseEditorPage> createState() => _SitCourseEditorPageState();
}

class _SitCourseEditorPageState extends State<SitCourseEditorPage> {
  late final $courseName = TextEditingController(text: widget.course?.courseName);
  late final $courseCode = TextEditingController(text: widget.course?.courseCode);
  late final $classCode = TextEditingController(text: widget.course?.classCode);
  late var campus = widget.course?.campus ?? Settings.campus;
  late final $place = TextEditingController(text: widget.course?.place);
  late var weekIndices = widget.course?.weekIndices ?? const TimetableWeekIndices([]);
  late var timeslots = widget.course?.timeslots ?? (start: 0, end: 0);
  late var courseCredit = widget.course?.courseCredit ?? 0.0;
  late var dayIndex = widget.course?.dayIndex ?? 0;
  late var teachers = widget.course?.teachers ?? <String>[];

  @override
  void dispose() {
    $courseName.dispose();
    $courseCode.dispose();
    $classCode.dispose();
    $place.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            title: "Course info".text(),
            actions: [
              PlatformTextButton(
                onPressed: () {
                  context.pop(SitCourse(
                    courseKey: widget.course?.courseKey ?? 0,
                    courseName: $courseName.text,
                    courseCode: $courseCode.text,
                    classCode: $classCode.text,
                    campus: campus,
                    place: $place.text,
                    weekIndices: weekIndices,
                    timeslots: timeslots,
                    courseCredit: courseCredit,
                    dayIndex: dayIndex,
                    teachers: teachers,
                  ));
                },
                child: i18n.done.text(),
              ),
            ],
          ),
          SliverList.list(children: [
            buildTextField(
              controller: $courseName,
              title: "Course name",
              readonly: !widget.courseNameEditable,
            ),
            buildTextField(
              controller: $courseCode,
              readonly: !widget.courseNameEditable,
              title: "Course code",
            ),
            buildTextField(
              controller: $classCode,
              readonly: !widget.courseNameEditable,
              title: "Class code",
            ),
            if (widget.placeEditable)
              buildTextField(
                controller: $place,
                title: "Place",
              ),
          ]),
        ],
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String title,
    bool readonly = false,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: 1,
      readOnly: readonly,
      decoration: InputDecoration(
        labelText: title,
        enabled: !readonly,
        border: const OutlineInputBorder(),
      ),
    ).padAll(10);
  }
}
