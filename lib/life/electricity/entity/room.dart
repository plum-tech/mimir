import 'package:sit/utils/strings.dart';

class Room {
  final int building;
  final int roomNumber;

  const Room({required this.building, required this.roomNumber});

  /// ## examples:
  /// - 101301: building #1, room #301
  /// - 10251524: building #25, room #1524
  factory Room.fromFullString(String full) {
    full = full.removePrefix("10");
    if (full.length < 4) {
      return const Room(building: 0, roomNumber: 0);
    } else if (full.length == 4) {
      // building is in 1 digit, like 1 301
      final buildingRaw = full[0];
      final roomNumberRaw = full.substring(1);
      return Room(building: int.tryParse(buildingRaw) ?? 0, roomNumber: int.tryParse(roomNumberRaw) ?? 0);
    } else if(full.length == 5){
      // building is in 2 digit,
    }
    return Room(building: 0, roomNumber: 0);
  }
}
