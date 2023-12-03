import 'package:html/parser.dart';
import 'package:sit/school/entity/school.dart';

import 'entity/result.ug.dart';
import 'entity/result.pg.dart';

// TODO: calculate GPA
double calcGPA(Iterable<ExamResultUg> scoreList) {
  double totalCredits = 0.0;
  double sum = 0.0;

  for (final s in scoreList) {
    assert(s.score >= 0, "Exam score should be >= 0");
    totalCredits += s.credit;
    sum += s.credit * s.score;
  }
  final res = sum / totalCredits / 10.0 - 5.0;
  return res.isNaN ? 0 : res;
}

List<ExamResultPgRaw> parsePostgraduateScoreRawFromScoresHtml(String scoresHtmlContent) {
  List<ExamResultPgRaw> all = [];

  final htmlDocument = parse(scoresHtmlContent);
  final table = htmlDocument
      .querySelectorAll('table.t_table')[1]
      .querySelector("tbody")!
      .querySelectorAll("tr")[1]
      .querySelector("td");
  final tbody = table!.querySelector("tbody");
  final trList = tbody!.querySelectorAll("tr");
  for (var tr in trList) {
    if (tr.className == "tr_fld_v") {
      final tdList = tr.querySelectorAll("td");
      var courseClass = mapChinesePunctuations(tdList[0].text.trim());
      var courseCode = tdList[1].text.trim();
      var courseName = mapChinesePunctuations(tdList[2].text.trim());
      var courseCredit = tdList[3].text.trim();
      var teacher = tdList[4].text.trim();
      var score = tdList[5].text.trim();
      var isPassed = tdList[6].text.trim();
      var examNature = tdList[7].text.trim();
      var examForm = tdList[8].text.trim();
      var examTime = tdList[9].text.trim();
      var notes = tdList[9].text.trim();
      final scoresRaw = ExamResultPgRaw(
          courseClass: courseClass,
          courseCode: courseCode,
          courseName: courseName,
          courseCredit: courseCredit,
          teacher: teacher,
          score: score,
          passStatus: isPassed,
          examType: examNature,
          examForm: examForm,
          examTime: examTime,
          notes: notes);
      all.add(scoresRaw);
    }
  }
  return all;
}
