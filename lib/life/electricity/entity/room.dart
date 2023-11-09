import 'package:easy_localization/easy_localization.dart';
import 'package:sit/utils/strings.dart';

class DormitoryRoom {
  final int building;
  final int roomNumber;

  const DormitoryRoom({
    required this.building,
    required this.roomNumber,
  });

  /// For buildings #1 through #10, their floors are all below 10.
  /// ## examples:
  /// - 101301: building #1, room #301
  /// - 10251524: building #25, room #1524
  factory DormitoryRoom.fromFullString(String full) {
    full = full.removePrefix("10");
    assert(full.length >= 4 && full.length <= 6, '"$full" is too long.');
    if (full.length < 4) {
      return const DormitoryRoom(building: 0, roomNumber: 0);
    } else if (full.length == 4) {
      // building is in 1 digit, like 1 301
      final buildingRaw = full[0];
      final roomNumberRaw = full.substring(1);
      return DormitoryRoom(building: int.tryParse(buildingRaw) ?? 0, roomNumber: int.tryParse(roomNumberRaw) ?? 0);
    } else if (full.length == 5 || full.length == 6) {
      // building is in 2 digit,like 12 301
      final buildingRaw = full.substring(0, 2);
      final roomNumberRaw = full.substring(2);
      return DormitoryRoom(building: int.tryParse(buildingRaw) ?? 0, roomNumber: int.tryParse(roomNumberRaw) ?? 0);
    }
    return const DormitoryRoom(building: 0, roomNumber: 0);
  }

  @override
  String toString() {
    return "Building $building #$roomNumber";
  }

  String l10n() {
    return "dormitoryRoom".tr(namedArgs: {
      "building": building.toString(),
      "room": roomNumber.toString(),
    });
  }
}
