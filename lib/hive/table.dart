import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

const _kLastId = "lastId";
const _kIdList = "idList";
const _kRows = "rows";
const _kSelectedId = "selectedId";
const _kLastIdStart = 0;

class Notifier with ChangeNotifier {
  void notifier() => notifyListeners();
}

class HiveTable<T> {
  final String base;
  final Box box;

  final String _lastIdK;
  final String _idListK;
  final String _rowsK;
  final String _selectedIdK;
  final ({T Function(Map<String, dynamic> json) fromJson, Map<String, dynamic> Function(T row) toJson})? useJson;
  final $selected = Notifier();

  HiveTable({
    required this.base,
    required this.box,
    this.useJson,
  })  : _lastIdK = "$base/$_kLastId",
        _idListK = "$base/$_kIdList",
        _rowsK = "$base/$_kRows",
        _selectedIdK = "$base/$_kSelectedId";

  bool get hasAny => idList?.isNotEmpty ?? false;

  int get lastId => box.get(_lastIdK) ?? _kLastIdStart;

  set lastId(int newValue) => box.put(_lastIdK, newValue);

  List<int>? get idList => box.get(_idListK);

  set idList(List<int>? newValue) => box.put(_idListK, newValue);

  int? get selectedId => box.get(_selectedIdK);

  set selectedId(int? newValue) {
    box.put(_selectedIdK, newValue);
    $selected.notifier();
  }

  T? get selectedRow {
    final id = selectedId;
    if (id == null) {
      return null;
    }
    return getOf(id);
  }

  T? getOf(int id) {
    final row = box.get("$_rowsK/$id");
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
      box.put("$_rowsK/$id", row);
    } else {
      box.put("$_rowsK/$id", jsonEncode(useJson.toJson(row)));
    }
    if (selectedId == id) {
      $selected.notifier();
    }
  }

  void _deleteOf(int id) {
    box.delete("$_rowsK/$id");
  }

  /// Return a new ID for the [row].
  int add(T row) {
    final curId = lastId++;
    final ids = idList ?? <int>[];
    ids.add(curId);
    setOf(curId, row);
    idList = ids;
    return curId;
  }

  /// Delete the timetable by [id].
  /// If [selectedId] is deleted, an available timetable would be switched to.
  void delete(int id) {
    final ids = idList;
    if (ids == null) return;
    if (ids.remove(id)) {
      idList = ids;
      if (selectedId == id) {
        if (ids.isNotEmpty) {
          selectedId = ids.first;
        } else {
          selectedId = null;
        }
      }
      _deleteOf(id);
    }
  }

  void drop() {
    final ids = idList;
    if (ids == null) return;
    for (final id in ids) {
      _deleteOf(id);
    }
    box.delete(_idListK);
    box.delete(_selectedIdK);
    box.delete(_lastIdK);
  }

  List<({int id, T row})> getRows() {
    final ids = idList;
    final res = <({int id, T row})>[];
    if (ids == null) return res;
    for (final id in ids) {
      final row = getOf(id);
      if (row != null) {
        res.add((id: id, row: row));
      }
    }
    return res;
  }
}
