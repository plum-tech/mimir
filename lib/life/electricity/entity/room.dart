import 'package:easy_localization/easy_localization.dart';
import 'package:sit/utils/strings.dart';

class DormitoryRoom {
  final int building;
  final int floorWithRoomNumber;
  final int floorNumber;
  final int roomNumber;

  const DormitoryRoom(
      {required this.building, required this.floorWithRoomNumber, required this.floorNumber, required this.roomNumber});

  /// For buildings #1 through #10, their floors are all below 10.
  /// ## examples:
  /// - 101301: building #1, room #301
  /// - 10251524: building #25, room #1524
  factory DormitoryRoom.fromFullString(String full) {
    full = full.removePrefix("10");
    assert(full.length >= 4 && full.length <= 6, '"$full" is too long.');
    if (full.length < 4) {
      return const DormitoryRoom(building: 0, floorWithRoomNumber: 0, floorNumber: 0, roomNumber: 0);
    } else if (full.length == 4) {
      // building is in 1 digit, like 1 301
      final buildingRaw = full[0];
      final floorWithRoomNumberRaw = full.substring(1);
      final floorNumberRaw = full.substring(1, 2);
      final roomNumberRaw = full.substring(2);
      return DormitoryRoom(
          building: int.tryParse(buildingRaw) ?? 0,
          floorWithRoomNumber: int.tryParse(floorWithRoomNumberRaw) ?? 0,
          floorNumber: int.tryParse(floorNumberRaw) ?? 0,
          roomNumber: int.tryParse(roomNumberRaw) ?? 0);
    } else if (full.length == 5) {
      // building is in 2 digit,like 12 301
      final buildingRaw = full.substring(0, 2);
      final floorWithRoomNumber = full.substring(2);
      final floorNumberRaw = full.substring(2, 3);
      final roomNumberRaw = full.substring(3);
      return DormitoryRoom(
          building: int.tryParse(buildingRaw) ?? 0,
          floorWithRoomNumber: int.tryParse(floorWithRoomNumber) ?? 0,
          floorNumber: int.tryParse(floorNumberRaw) ?? 0,
          roomNumber: int.tryParse(roomNumberRaw) ?? 0);
    } else if (full.length == 6) {
      // building is in 2 digit,like 12 1301
      final buildingRaw = full.substring(0, 2);
      final floorWithRoomNumber = full.substring(2);
      final floorNumberRaw = full.substring(2, 4);
      final roomNumberRaw = full.substring(4);
      return DormitoryRoom(
          building: int.tryParse(buildingRaw) ?? 0,
          floorWithRoomNumber: int.tryParse(floorWithRoomNumber) ?? 0,
          floorNumber: int.tryParse(floorNumberRaw) ?? 0,
          roomNumber: int.tryParse(roomNumberRaw) ?? 0);
    }
    return const DormitoryRoom(building: 0, floorWithRoomNumber: 0, floorNumber: 0, roomNumber: 0);
  }

  @override
  String toString() {
    return "Building $building #$floorWithRoomNumber";
  }

  String l10n() {
    return "dormitoryRoom".tr(namedArgs: {
      "building": building.toString(),
      "room": floorWithRoomNumber.toString(),
    });
  }

  static void quickSort(List<int> rooms, int Function(int, int) compare) {
    if (rooms.length < 2) {
      return;
    }

    List<int> stack = [];
    stack.add(0);
    stack.add(rooms.length - 1);

    while (stack.isNotEmpty) {
      int end = stack.removeLast();
      int start = stack.removeLast();

      int pivotIndex = partition(rooms, start, end, compare);

      if (pivotIndex - 1 > start) {
        stack.add(start);
        stack.add(pivotIndex - 1);
      }

      if (pivotIndex + 1 < end) {
        stack.add(pivotIndex + 1);
        stack.add(end);
      }
    }
  }

  static int partition(List<int> rooms, int start, int end, int Function(int, int) compare) {
    int pivot = rooms[end];
    int i = start - 1;

    for (int j = start; j < end; j++) {
      if (compare(rooms[j], pivot) <= 0) {
        i++;
        _swap(rooms, i, j);
      }
    }

    _swap(rooms, i + 1, end);
    return i + 1;
  }

  static void _swap(List<int> rooms, int i, int j) {
    int temp = rooms[i];
    rooms[i] = rooms[j];
    rooms[j] = temp;
  }

  static int compare(int room1, int room2) {
    var dormitoryRoom1 = DormitoryRoom.fromFullString(room1.toString());
    var dormitoryRoom2 = DormitoryRoom.fromFullString(room2.toString());
    if (dormitoryRoom1.building < dormitoryRoom2.building) {
      return -1;
    } else if (dormitoryRoom1.building > dormitoryRoom2.building) {
      return 1;
    } else {
      if (dormitoryRoom1.floorNumber < dormitoryRoom2.floorNumber) {
        return -1;
      } else if (dormitoryRoom1.floorNumber > dormitoryRoom2.floorNumber) {
        return 1;
      } else {
        if (dormitoryRoom1.roomNumber < dormitoryRoom2.roomNumber) {
          return -1;
        } else if (dormitoryRoom1.roomNumber > dormitoryRoom2.roomNumber) {
          return 1;
        } else {
          return 0;
        }
      }
    }
  }
}

