import 'package:easy_localization/easy_localization.dart';
import 'package:sit/credentials/i18n.dart';
import 'package:sit/l10n/common.dart';

const i18n = _I18n();

class _I18n with CommonI18nMixin {
  const _I18n();

  static const ns = "library";
  final login = const _Login();
  final info = const _Info();
  final action = const _Action();
  final searching = const _Search();
  final borrowing = const _Borrowing();
  final history = const _BorrowingHistory();

  String get title => "$ns.title".tr();

  String get hotPost => "$ns.hotPost".tr();

  String get readerId => "$ns.readerId".tr();

  String get noBooks => "$ns.noBooks".tr();

  String get collectionStatus => "$ns.collectionStatus".tr();
}

class _Action {
  const _Action();

  static const ns = "${_I18n.ns}.action";

  String get login => "$ns.login".tr();

  String get searchBooks => "$ns.searchBooks".tr();

  String get borrowing => "$ns.borrowing".tr();
}

class _Login {
  const _Login();

  final credentials = const CredentialsI18n();

  static const ns = "${_I18n.ns}.login";

  String get title => "$ns.title".tr();

  String get readerIdHint => "$ns.readerIdHint".tr();

  String get passwordHint => "$ns.passwordHint".tr();

  String get failedWarn => "$ns.failedWarn.title".tr();

  String get failedWarnDesc => "$ns.failedWarn.desc".tr();
}

class _Info {
  const _Info();

  static const ns = "${_I18n.ns}.info";

  String get title => "$ns.title".tr();

  String get author => "$ns.author".tr();

  String get isbn => "$ns.isbn".tr();

  String get publisher => "$ns.publisher".tr();

  String get publishDate => "$ns.publishDate".tr();

  String get callNumber => "$ns.callNumber".tr();

  String get bookId => "$ns.bookId".tr();

  String get barcode => "$ns.barcode".tr();

  String availableCollection(String available, String collection) => "$ns.availableCollection".tr(
        namedArgs: {
          "available": available,
          "collection": collection,
        },
      );
}

class _Search {
  const _Search();

  static const ns = "${_I18n.ns}.search";

  String get searchHistory => "$ns.searchHistory".tr();

  String get trending => "$ns.trending".tr();

  String get mostPopular => "$ns.mostPopular".tr();
}

class _Borrowing {
  const _Borrowing();

  static const ns = "${_I18n.ns}.borrowing";

  String get title => "$ns.title".tr();

  String get history => "$ns.history".tr();

  String get renew => "$ns.renew".tr();
}

class _BorrowingHistory {
  const _BorrowingHistory();

  static const ns = "${_I18n.ns}.history";

  String get title => "$ns.title".tr();
}
