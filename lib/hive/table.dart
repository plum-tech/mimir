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

  /// notify if selected row was changed.
  final $selected = Notifier();

  /// notify if any row was changed.
  final $any = Notifier();

  /// The delegate of getting row
  final T? Function(int id, T? Function(int id) builtin)? get;

  /// The delegate of setting row
  final void Function(int id, T? newV, void Function(int id, T? newV) builtin)? set;

  HiveTable({
    required this.base,
    required this.box,
    this.get,
    this.set,
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
    $any.notifier();
  }

  T? get selectedRow {
    final id = selectedId;
    if (id == null) {
      return null;
    }
    return this[id];
  }

  T? operator [](int id) {
    final get = this.get;
    if (get != null) {
      return get(id, _get);
    }
    return _get(id);
  }

  T? _get(int id) {
    final row = box.get("$_rowsK/$id");
    final useJson = this.useJson;
    if (useJson == null || row == null) {
      return row;
    } else {
      return useJson.fromJson(jsonDecode(row));
    }
  }

  void operator []=(int id, T? newValue) {
    final set = this.set;
    if (set != null) {
      set(id, newValue, _set);
    }
    return _set(id, newValue);
  }

  void _set(int id, T? newValue) {
    final useJson = this.useJson;
    if (useJson == null || newValue == null) {
      box.put("$_rowsK/$id", newValue);
    } else {
      box.put("$_rowsK/$id", jsonEncode(useJson.toJson(newValue)));
    }
    if (selectedId == id) {
      $selected.notifier();
    }
    $any.notifier();
  }

  /// Return a new ID for the [row].
  int add(T row) {
    final curId = lastId++;
    final ids = idList ?? <int>[];
    ids.add(curId);
    this[curId] = row;
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
      box.delete("$_rowsK/$id");
      $any.notifier();
    }
  }

  void drop() {
    final ids = idList;
    if (ids == null) return;
    for (final id in ids) {
      box.delete("$_rowsK/$id");
    }
    box.delete(_idListK);
    box.delete(_selectedIdK);
    box.delete(_lastIdK);
    $selected.notifier();
    $any.notifier();
  }

  // TODO: Row delegate?
  /// ignore null row
  List<({int id, T row})> getRows() {
    final ids = idList;
    final res = <({int id, T row})>[];
    if (ids == null) return res;
    for (final id in ids) {
      final row = this[id];
      if (row != null) {
        res.add((id: id, row: row));
      }
    }
    return res;
  }
}
