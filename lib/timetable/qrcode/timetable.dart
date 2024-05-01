import 'package:flutter/widgets.dart';
import 'package:sit/qrcode/protocol.dart';
import 'package:sit/qrcode/utils.dart';
import 'package:sit/r.dart';
import 'package:sit/timetable/entity/timetable.dart';

import '../page/mine.dart';

class TimetableDeepLink implements DeepLinkHandlerProtocol {
  static const path = "timetable";

  const TimetableDeepLink();

  Uri encode(SitTimetable entry) =>
      Uri(scheme: R.scheme, path: path, query: encodeBytesForUrl(SitTimetable.encodeByteList(entry)));

  SitTimetable decode(Uri qrCodeData) => (SitTimetable.decodeByteList(decodeBytesFromUrl(qrCodeData.query)));

  @override
  bool match(Uri encoded) {
    return encoded.path == path;
  }

  @override
  Future<void> onHandle({
    required BuildContext context,
    required Uri qrCodeData,
  }) async {
    final timetable = decode(qrCodeData);
    await onTimetableFromFile(
      context: context,
      timetable: timetable,
    );
  }
}
