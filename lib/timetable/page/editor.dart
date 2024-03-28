import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/design/adaptive/editor.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/design/adaptive/swipe.dart';
import 'package:sit/design/widgets/expansion_tile.dart';
import 'package:sit/l10n/extension.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/l10n/time.dart';
import 'package:sit/school/widgets/course.dart';
import 'package:sit/settings/dev.dart';
import 'package:sit/settings/settings.dart';

import '../entity/timetable.dart';
import '../i18n.dart';
import '../widgets/style.dart';
import 'preview.dart';

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
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            title: i18n.import.timetableInfo.text(),
            actions: [
              PlatformTextButton(
                onPressed: onPreview,
                child: i18n.preview.text(),
              ),
              PlatformTextButton(
                onPressed: onSave,
                child: i18n.save.text(),
              ),
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
            label: i18n.editor.infoTab,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_month_outlined),
            activeIcon: const Icon(Icons.calendar_month),
            label: i18n.editor.advancedTab,
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
    code2Courses.sortBy((p) => p.key);
    for (var p in code2Courses) {
      p.value.sortBy((l) => l.courseCode);
    }
    return [
      SliverList.list(children: [
        addCourseTile(),
        const Divider(thickness: 2),
      ]),
      SliverList.builder(
        itemCount: code2Courses.length,
        itemBuilder: (ctx, i) {
          final MapEntry(key: courseKey, value: courses) = code2Courses[i];
          final template = courses.first;
          return TimetableEditableCourseCard(
            key: ValueKey(courseKey),
            courses: courses,
            template: template,
            onCourseChanged: onCourseChanged,
            onCourseAdded: onCourseAdded,
            onCourseRemoved: onCourseRemoved,
          );
        },
      ),
    ];
  }

  Widget addCourseTile() {
    return ListTile(
      title: i18n.editor.addCourse.text(),
      trailing: Icon(context.icons.add),
      onTap: () async {
        final newCourse = await context.show$Sheet$<SitCourse>((ctx) => SitCourseEditorPage(
              title: i18n.editor.newCourse,
              course: null,
            ));
        if (newCourse == null) return;
        onCourseAdded(newCourse);
      },
    );
  }

  void onCourseChanged(SitCourse old, SitCourse newValue) {
    final key = "${newValue.courseKey}";
    if (courses.containsKey(key)) {
      setState(() {
        courses[key] = newValue;
      });
    }
    // check if shared fields are changed.
    if (old.courseCode != newValue.courseCode ||
        old.classCode != newValue.classCode ||
        old.courseName != newValue.courseName) {
      for (final MapEntry(:key, value: course) in courses.entries.toList()) {
        if (course.courseCode == old.courseCode) {
          // change the shared fields simultaneously
          courses[key] = course.copyWith(
            courseCode: newValue.courseCode,
            classCode: newValue.classCode,
            courseName: newValue.courseName,
          );
        }
      }
    }
  }

  void onCourseAdded(SitCourse course) {
    course = course.copyWith(
      courseKey: lastCourseKey++,
    );
    setState(() {
      courses["${course.courseKey}"] = course;
    });
  }

  void onCourseRemoved(SitCourse course) {
    final key = "${course.courseKey}";
    if (courses.containsKey(key)) {
      setState(() {
        courses.remove("${course.courseKey}");
      });
    }
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

  SitTimetable buildTimetable() {
    final signature = $signature.text.trim();
    return widget.timetable.copyWith(
      name: $name.text,
      signature: signature,
      startDate: $selectedDate.value,
      courses: courses,
      lastCourseKey: lastCourseKey,
    );
  }

  void onSave() {
    final signature = $signature.text.trim();
    Settings.lastSignature = signature;
    final timetable = buildTimetable();
    context.pop(timetable);
  }

  Future<void> onPreview() async {
    await context.show$Sheet$(
      (context) => TimetableStyleProv(
        child: TimetablePreviewPage(
          timetable: buildTimetable(),
        ),
      ),
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
  final void Function(SitCourse old, SitCourse newValue)? onCourseChanged;
  final void Function(SitCourse)? onCourseAdded;
  final void Function(SitCourse)? onCourseRemoved;

  const TimetableEditableCourseCard({
    super.key,
    required this.template,
    required this.courses,
    this.color,
    this.onCourseChanged,
    this.onCourseAdded,
    this.onCourseRemoved,
  });

  @override
  Widget build(BuildContext context) {
    final onCourseRemoved = this.onCourseRemoved;
    return Card(
      color: color,
      clipBehavior: Clip.hardEdge,
      child: AnimatedExpansionTile(
        leading: CourseIcon(courseName: template.courseName),
        title: template.courseName.text(),
        trailing: [
          IconButton.filledTonal(
            icon: Icon(context.icons.add),
            padding: EdgeInsets.zero,
            onPressed: () async {
              final tempItem = template.createSubItem(courseKey: 0);
              final newItem = await context.show$Sheet$(
                (context) => SitCourseEditorPage.item(
                  title: i18n.editor.newCourse,
                  course: tempItem,
                ),
              );
              if (newItem == null) return;
              onCourseAdded?.call(newItem);
            },
          ),
          IconButton.filledTonal(
            icon: Icon(context.icons.edit),
            padding: EdgeInsets.zero,
            onPressed: () async {
              final newTemplate = await context.show$Sheet$<SitCourse>((context) => SitCourseEditorPage.template(
                    title: i18n.editor.editCourse,
                    course: template,
                  ));
              if (newTemplate == null) return;
              onCourseChanged?.call(template, newTemplate);
            },
          ),
        ].row(mas: MainAxisSize.min),
        rotateTrailing: false,
        subtitle: [
          if (template.courseCode.isNotEmpty) "${i18n.course.courseCode} ${template.courseCode}".text(),
          if (template.classCode.isNotEmpty) "${i18n.course.classCode} ${template.classCode}".text(),
        ].column(caa: CrossAxisAlignment.start),
        children: courses.mapIndexed((i, course) {
          final weekNumbers = course.weekIndices.l10n();
          final (:begin, :end) = course.calcBeginEndTimePoint();
          return SwipeToDismiss(
            childKey: ValueKey(course.courseKey),
            right: onCourseRemoved == null
                ? null
                : SwipeToDismissAction(
                    icon: Icon(context.icons.delete),
                    action: () async {
                      onCourseRemoved(course);
                    },
                  ),
            child: ListTile(
              isThreeLine: true,
              leading: Dev.on ? "${course.courseKey}".text() : null,
              title: course.place.text(),
              subtitle: [
                course.teachers.join(", ").text(),
                "${Weekday.fromIndex(course.dayIndex).l10n()} ${begin.l10n(context)}–${end.l10n(context)}".text(),
                ...weekNumbers.map((n) => n.text()),
              ].column(mas: MainAxisSize.min, caa: CrossAxisAlignment.start),
              trailing: IconButton.filledTonal(
                icon: Icon(context.icons.edit),
                padding: EdgeInsets.zero,
                onPressed: () async {
                  final newItem = await context.show$Sheet$<SitCourse>((context) => SitCourseEditorPage.item(
                        title: i18n.editor.editCourse,
                        course: course,
                      ));
                  if (newItem == null) return;
                  onCourseChanged?.call(course, newItem);
                },
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

extension _SitCourseX on SitCourse {
  SitCourse createSubItem({
    required int courseKey,
  }) {
    return SitCourse(
      courseKey: courseKey,
      courseName: courseName,
      courseCode: courseCode,
      classCode: classCode,
      campus: campus,
      place: "",
      weekIndices: const TimetableWeekIndices([]),
      timeslots: (start: 0, end: 0),
      courseCredit: courseCredit,
      dayIndex: 0,
      teachers: teachers,
    );
  }
}

class SitCourseEditorPage extends StatefulWidget {
  final String? title;
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
    this.title,
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
    this.title,
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
    this.title,
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
  late var teachers = List.of(widget.course?.teachers ?? <String>[]);

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
            title: widget.title?.text(),
            actions: [
              PlatformTextButton(
                onPressed: onSave,
                child: i18n.done.text(),
              ),
            ],
          ),
          SliverList.list(children: [
            buildTextField(
              controller: $courseName,
              title: i18n.course.courseName,
              readonly: !widget.courseNameEditable,
            ),
            buildTextField(
              controller: $courseCode,
              title: i18n.course.courseCode,
              readonly: !widget.courseNameEditable,
            ),
            buildTextField(
              controller: $classCode,
              title: i18n.course.classCode,
              readonly: !widget.courseNameEditable,
            ),
            if (widget.placeEditable)
              buildTextField(
                title: i18n.course.place,
                controller: $place,
              ),
            if (widget.dayIndexEditable)
              buildWeekdays().inCard(
                clip: Clip.hardEdge,
              ),
            if (widget.timeslotsEditable)
              buildTimeslots().inCard(
                clip: Clip.hardEdge,
              ),
            if (widget.weekIndicesEditable)
              buildRepeating().inCard(
                clip: Clip.hardEdge,
              ),
            if (widget.teachersEditable)
              buildTeachers().inCard(
                clip: Clip.hardEdge,
              ),
          ]),
        ],
      ),
    );
  }

  Widget buildWeekdays() {
    return ListTile(
      title: i18n.editor.daysOfWeek.text(),
      isThreeLine: true,
      subtitle: [
        ...Weekday.values.map(
          (w) => ChoiceChip(
            showCheckmark: false,
            label: w.l10n().text(),
            selected: dayIndex == w.index,
            onSelected: (value) {
              setState(() {
                dayIndex = w.index;
              });
            },
          ),
        ),
      ].wrap(spacing: 4),
    );
  }

  Widget buildTimeslots() {
    return ListTile(
      title: (timeslots.start == timeslots.end
              ? i18n.editor.timeslotsSpanSingle("${timeslots.start + 1}")
              : i18n.editor.timeslotsSpanMultiple(from: "${timeslots.start + 1}", to: "${timeslots.end + 1}"))
          .text(),
      subtitle: [
        const Icon(Icons.light_mode),
        RangeSlider(
          values: RangeValues(timeslots.start.toDouble(), timeslots.end.toDouble()),
          max: 10,
          divisions: 10,
          labels: RangeLabels(
            "${timeslots.start.round() + 1}",
            "${timeslots.end.round() + 1}",
          ),
          onChanged: (RangeValues values) {
            final newStart = values.start.toInt();
            final newEnd = values.end.toInt();
            if (timeslots.start != newStart || timeslots.end != newEnd) {
              setState(() {
                timeslots = (start: newStart, end: newEnd);
              });
            }
          },
        ).expanded(),
        const Icon(Icons.dark_mode),
      ].row(mas: MainAxisSize.min),
    );
  }

  Widget buildRepeating() {
    return [
      ListTile(
        title: i18n.editor.repeating.text(),
        trailing: IconButton.filledTonal(
          icon: Icon(context.icons.add),
          onPressed: () {
            final newIndices = List.of(weekIndices.indices);
            newIndices.add(const TimetableWeekIndex.all((start: 0, end: 1)));
            setState(() {
              weekIndices = TimetableWeekIndices(newIndices);
            });
          },
        ),
      ),
      ...weekIndices.indices.mapIndexed((i, index) {
        return RepeatingItemEditor(
          childKey: ValueKey(i),
          index: index,
          onChanged: (value) {
            final newIndices = List.of(weekIndices.indices);
            newIndices[i] = value;
            setState(() {
              weekIndices = TimetableWeekIndices(newIndices);
            });
          },
          onDeleted: () {
            setState(() {
              weekIndices = TimetableWeekIndices(
                List.of(weekIndices.indices)..removeAt(i),
              );
            });
          },
        );
      })
    ].column();
  }

  Widget buildTeachers() {
    return ListTile(
      title: i18n.course.teacher(2).text(),
      isThreeLine: true,
      trailing: IconButton(
        icon: Icon(context.icons.add),
        onPressed: () async {
          final newTeacher = await Editor.showStringEditor(
            context,
            desc: i18n.course.teacher(2),
            initial: "",
          );
          if (newTeacher != null && !teachers.contains(newTeacher)) {
            if (!mounted) return;
            setState(() {
              teachers.add(newTeacher);
            });
          }
        },
      ),
      subtitle: [
        ...teachers.map((teacher) => InputChip(
              label: teacher.text(),
              onDeleted: () {
                setState(() {
                  teachers.remove(teacher);
                });
              },
            )),
      ].wrap(spacing: 4),
    );
  }

  void onSave() {
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

class RepeatingItemEditor extends StatelessWidget {
  final Key childKey;
  final TimetableWeekIndex index;
  final ValueChanged<TimetableWeekIndex>? onChanged;
  final void Function()? onDeleted;

  const RepeatingItemEditor({
    super.key,
    required this.index,
    required this.childKey,
    this.onChanged,
    this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    final onDeleted = this.onDeleted;
    return SwipeToDismiss(
      childKey: childKey,
      right: onDeleted == null
          ? null
          : SwipeToDismissAction(
              icon: Icon(context.icons.delete),
              action: () async {
                onDeleted();
              },
            ),
      child: ListTile(
        title: index.l10n().text(),
        isThreeLine: true,
        subtitle: [
          RangeSlider(
            values: RangeValues(index.range.start.toDouble(), index.range.end.toDouble()),
            max: 19,
            divisions: 19,
            labels: RangeLabels(
              "${index.range.start.round() + 1}",
              "${index.range.end.round() + 1}",
            ),
            onChanged: (RangeValues values) {
              final newStart = values.start.toInt();
              final newEnd = values.end.toInt();
              if (index.range.start != newStart || index.range.end != newEnd) {
                onChanged?.call(index.copyWith(
                  range: (start: newStart, end: newEnd),
                ));
              }
            },
          ),
          [
            ...TimetableWeekIndexType.values.map((type) => ChoiceChip(
                  label: type.l10n().text(),
                  selected: index.type == type,
                  onSelected: type != TimetableWeekIndexType.all && index.isSingle
                      ? null
                      : (value) {
                          onChanged?.call(index.copyWith(
                            type: type,
                          ));
                        },
                )),
          ].wrap(spacing: 4),
        ].column(mas: MainAxisSize.min, caa: CrossAxisAlignment.start),
      ),
    );
  }
}
