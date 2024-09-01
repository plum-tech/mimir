import 'package:flutter/widgets.dart';
import 'package:mimir/intent/deep_link/protocol.dart';
import 'package:mimir/intent/deep_link/utils.dart';
import 'package:mimir/r.dart';
import 'package:mimir/timetable/entity/timetable.dart';

import '../page/mine.dart';

class TimetableDeepLink implements DeepLinkHandlerProtocol {
  static const host = "timetable";

  const TimetableDeepLink();

  Uri encode(SitTimetable timetable) =>
      Uri(scheme: R.scheme, host: host, query: encodeBytesForUrl(SitTimetable.encodeByteList(timetable)));

  SitTimetable decode(Uri qrCodeData) => (SitTimetable.decodeByteList(decodeBytesFromUrl(qrCodeData.query)));

  @override
  bool match(Uri encoded) {
    // for backwards support
    if (encoded.host.isEmpty && encoded.path == "timetable") return true;
    return encoded.host == host && encoded.path.isEmpty;
  }

  @override
  Future<void> onHandle({
    required BuildContext context,
    required Uri data,
  }) async {
    final timetable = decode(data);
    await onTimetableFromFile(
      context: context,
      timetable: timetable,
    );
  }
}
