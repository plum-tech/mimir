import 'package:sit/life/electricity/init.dart';
import 'package:sit/settings/settings.dart';

class ElectricityAggregated {
  static void addSearchHistory(String room) {
    final storage = ElectricityBalanceInit.storage;
    final searchHistory = storage.searchHistory ?? <String>[];
    if (searchHistory.any((e) => e == room)) return;
    searchHistory.insert(0, room);
    storage.searchHistory = searchHistory;
  }

  static void selectNewRoom(String room) {
    Settings.life.electricity.selectedRoom = room;
    addSearchHistory(room);
    ElectricityBalanceInit.storage.lastUpdateTime = null;
  }

  static void clearSelectedRoom() {
    Settings.life.electricity.selectedRoom = null;
    ElectricityBalanceInit.storage.lastUpdateTime = null;
    ElectricityBalanceInit.storage.lastBalance = null;
  }
}
