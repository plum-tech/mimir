import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

const _kLastId = "lastId";
const _kIdList = "idList";
const _kRows = "rows";
const _kSelectedId = "selectedId";

class Notifier with ChangeNotifier {
  void notifier() => notifyListeners();
}

class HiveTable<T> {
  final String base;
  final Box<dynamic> box;

  final String _lastId;
  final String _idList;
  final String _rows;
  final String _selectedId;
  final ({T Function(Map<String, dynamic> json) fromJson, Map<String, dynamic> Function(T row) toJson})? useJson;
  final $selectedId = Notifier();

  HiveTable({
    required this.base,
    required this.box,
    this.useJson,
  })  : _lastId = "$base/$_kLastId",
        _idList = "$base/$_kIdList",
        _rows = "$base/$_kRows",
        _selectedId = "$base/$_kSelectedId";

  bool get hasAny => idList.isNotEmpty;

  int get lastId => box.get(_lastId) ?? 0;

  set lastId(int newValue) => box.put(_lastId, newValue);

  List<int> get idList => box.get(_idList) ?? <int>[];

  set idList(List<int> newValue) => box.put(_idList, newValue);

  int? get selectedId => box.get(_selectedId) ?? 0;

  set selectedId(int? newValue) {
    box.put(_selectedId, newValue);
    $selectedId.notifier();
  }

  T? get selectedRow {
    final id = selectedId;
    if (id == null) {
      return null;
    }
    return getOf(id);
  }

  T? getOf(int id) {
    final row = box.get("$_rows/$id");
    final useJson = this.useJson;
    if (useJson == null || row == null) {
      return row;
    } else {
      return useJson.fromJson(jsonDecode(row));
    }
  }

  void setOf(int id, T? newValue) {
    dynamic row = newValue;
    final useJson = this.useJson;
    if (useJson == null || row == null) {
      box.put("$_rows/$id", row);
    } else {
      box.put("$_rows/$id", jsonEncode(useJson.toJson(row)));
    }
  }

  /// Return a new ID for the [row].
  int add(T row) {
    final curId = lastId++;
    final ids = idList;
    ids.add(curId);
    setOf(curId, row);
    idList = ids;
    return curId;
  }

  /// Delete the timetable by [id].
  /// If [selectedId] is deleted, an available timetable would be switched to.
  void delete(int id) {
    final ids = idList;
    if (ids.remove(id)) {
      idList = ids;
      if (selectedId == id) {
        if (idList.isNotEmpty) {
          selectedId = ids.first;
        } else {
          selectedId = null;
        }
      }
      setOf(id, null);
    }
  }

  List<({int id, T row})> getRows() {
    final ids = idList;
    final res = <({int id, T row})>[];
    for (final id in ids) {
      final row = getOf(id);
      if (row != null) {
        res.add((id: id, row: row));
      }
    }
    return res;
  }
}
