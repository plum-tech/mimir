import 'using.dart';

const i18n = _I18n();

class _I18n with CommonI18nMixin {
  const _I18n();

  static const ns = "examResult";

  String get teacherEvalTitle => "$ns.teacherEvalTitle".tr();

  String get lessonEvaluationBtn => "$ns.lessonEvaluationBtn".tr();

  String get noResult => "$ns.noResult".tr();

  String get lessonNotEvaluated => "$ns.lessonNotEvaluated".tr();

  String gpaSelectedAndTotalLabel(String point, String count) => "$ns.gpaSelectedAndTotalLabel".tr(namedArgs: {
        "point": point,
        "count": count,
      });

  String gpaPointLabel(String type, String point) => "$ns.gpaPointLabel".tr(namedArgs: {
        "type": type,
        "point": point,
      });

  String get compulsory => "$ns.compulsory".tr();

  String get credit => "$ns.credit".tr();

  String get elective => "$ns.elective".tr();
}
