import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sit/utils/hive.dart';
import 'package:sit/utils/riverpod.dart';

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
  final T? Function(int id, T? Function(int id) builtin)? getDelegate;

  /// The delegate of setting row
  final FutureOr<void> Function(int id, T? newV, Future<void> Function(int id, T? newV) builtin)? setDelegate;

  HiveTable({
    required this.base,
    required this.box,
    this.getDelegate,
    this.setDelegate,
    this.useJson,
  })  : _lastIdK = "$base/$_kLastId",
        _idListK = "$base/$_kIdList",
        _rowsK = "$base/$_kRows",
        _selectedIdK = "$base/$_kSelectedId";

  bool get hasAny => idList?.isNotEmpty ?? false;

  int get lastId => box.safeGet<int>(_lastIdK) ?? _kLastIdStart;

  set lastId(int newValue) => box.safePut<int>(_lastIdK, newValue);

  List<int>? get idList => box.safeGet<List<int>>(_idListK)?.cast<int>();

  set idList(List<int>? newValue) => box.safePut<List<int>>(_idListK, newValue);

  int? get selectedId => box.safeGet(_selectedIdK);

  bool get isEmpty => idList?.isEmpty != false;

  bool get isNotEmpty => !isEmpty;

  String _rowK(int id) => "$_rowsK/$id";

  set selectedId(int? newValue) {
    box.safePut<int>(_selectedIdK, newValue);
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

  T? _getBuiltin(int id) {
    final row = box.safeGet<dynamic>(_rowK(id));
    final useJson = this.useJson;
    if (useJson == null || row == null) {
      return row;
    } else {
      return useJson.fromJson(jsonDecode(row));
    }
  }

  T? get(int id) {
    final get = this.getDelegate;
    if (get != null) {
      return get(id, _getBuiltin);
    }
    return _getBuiltin(id);
  }

  T? operator [](int id) => get(id);

  Future<void> _setBuiltin(int id, T? newValue) async {
    final useJson = this.useJson;
    if (useJson == null || newValue == null) {
      await box.safePut<T>(_rowK(id), newValue);
    } else {
      await box.safePut<String>(_rowK(id), jsonEncode(useJson.toJson(newValue)));
    }
    if (selectedId == id) {
      $selected.notifier();
    }
    $any.notifier();
  }

  Future<void> set(int id, T? newValue) async {
    final set = this.setDelegate;
    if (set != null) {
      await set(id, newValue, _setBuiltin);
    }
    return _setBuiltin(id, newValue);
  }

  void operator []=(int id, T? newValue) => set(id, newValue);

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
      box.delete(_rowK(id));
      $any.notifier();
    }
  }

  void drop() {
    final ids = idList;
    if (ids == null) return;
    for (final id in ids) {
      box.delete(_rowK(id));
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

  Listenable listenRowChange(int id) => box.listenable(keys: [_rowK(id)]);

  late final $row = box.providerFamily<T, int>(
    (id) => _rowK(id),
    get: (id) => this[id],
    set: (id, v) => this[id] = v,
  );

  late final $rows = $any.provider<List<({int id, T row})>>(
    get: getRows,
  );
  late final $selectedId = $selected.provider<int?>(
    get: () => selectedId,
  );
  late final $selectedRow = $selected.provider<T?>(
    get: () => selectedRow,
  );
}
