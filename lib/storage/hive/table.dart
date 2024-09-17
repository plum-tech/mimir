import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mimir/entity/uuid.dart';
import 'package:mimir/utils/hive.dart';
import 'package:mimir/utils/riverpod.dart';

const _kLastId = "lastId";
const _kIdList = "idList";
const _kRows = "rows";
const _kSelectedId = "selectedId";
const _kLastIdStart = 0;

class Notifier with ChangeNotifier {
  void notifier() => notifyListeners();
}

abstract class IdGenerator<TId, T> {
  const IdGenerator();

  TId alloc(T row);

  FutureOr<void> clear();
}

class IncrementalIdGenerator<T> implements IdGenerator<int, T> {
  final String key;
  final Box box;

  const IncrementalIdGenerator({
    required this.key,
    required this.box,
  });

  @override
  int alloc(T row) {
    final lastId = box.safeGet<int>(key) ?? _kLastIdStart;
    box.safePut<int>(key, lastId + 1);
    return lastId;
  }

  @override
  FutureOr<void> clear() async {
    await box.delete(key);
  }
}

class WithUuidGenerator<T extends WithUuid> implements IdGenerator<String, T> {
  const WithUuidGenerator();

  @override
  String alloc(T row) {
    return row.uuid;
  }

  @override
  void clear() {}
}

typedef GetDelegate<TId, T> = T? Function(TId id, T? Function(TId id) builtin);
typedef SetDelegate<TId, T> = FutureOr<void> Function(TId id, T? newV, Future<void> Function(TId id, T? newV) builtin);
typedef UseJson<T> = ({T Function(Map<String, dynamic> json) fromJson, Map<String, dynamic> Function(T row) toJson});

class HiveTable<TId, T> {
  final String base;
  final Box box;

  final String _idListK;
  final String _rowsK;
  final String _selectedIdK;
  final IdGenerator<TId, T> idAllocator;

  final UseJson<T>? useJson;

  /// notify if selected row was changed.
  final $selected = Notifier();

  /// notify if any row was changed.
  final $any = Notifier();

  /// The delegate of getting row
  final GetDelegate<TId, T>? getDelegate;

  /// The delegate of setting row
  final SetDelegate<TId, T>? setDelegate;

  HiveTable({
    required this.base,
    required this.box,
    required this.idAllocator,
    this.getDelegate,
    this.setDelegate,
    this.useJson,
  })  : _idListK = "$base/$_kIdList",
        _rowsK = "$base/$_kRows",
        _selectedIdK = "$base/$_kSelectedId";

  static HiveTable<int, T> incremental<T>({
    required String base,
    required Box box,
    GetDelegate<int, T>? getDelegate,
    SetDelegate<int, T>? setDelegate,
    UseJson<T>? useJson,
  }) {
    return HiveTable(
      base: base,
      box: box,
      getDelegate: getDelegate,
      setDelegate: setDelegate,
      useJson: useJson,
      idAllocator: IncrementalIdGenerator(box: box, key: "$base/$_kLastId"),
    );
  }

  static HiveTable<String, T> withUuid<T extends WithUuid>({
    required String base,
    required Box box,
    GetDelegate<String, T>? getDelegate,
    SetDelegate<String, T>? setDelegate,
    UseJson<T>? useJson,
  }) {
    return HiveTable(
      base: base,
      box: box,
      getDelegate: getDelegate,
      setDelegate: setDelegate,
      useJson: useJson,
      idAllocator: WithUuidGenerator<T>(),
    );
  }

  bool get hasAny => idList?.isNotEmpty ?? false;

  List<TId>? get idList => box.safeGet<List>(_idListK)?.cast<TId>();

  set idList(List<TId>? newValue) => box.safePut<List<TId>>(_idListK, newValue);

  TId? get selectedId => box.safeGet(_selectedIdK);

  bool get isEmpty => idList?.isEmpty != false;

  bool get isNotEmpty => !isEmpty;

  String _rowK(TId id) => "$_rowsK/$id";

  set selectedId(TId? newValue) {
    box.safePut<TId>(_selectedIdK, newValue);
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

  T? _getBuiltin(TId id) {
    final row = box.safeGet<dynamic>(_rowK(id));
    final useJson = this.useJson;
    if (useJson == null || row == null) {
      return row;
    } else {
      return useJson.fromJson(jsonDecode(row));
    }
  }

  T? get(TId id) {
    final get = this.getDelegate;
    if (get != null) {
      return get(id, _getBuiltin);
    }
    return _getBuiltin(id);
  }

  T? operator [](TId id) => get(id);

  Future<void> _setBuiltin(TId id, T? newValue) async {
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

  Future<void> set(TId id, T? newValue) async {
    final set = this.setDelegate;
    if (set != null) {
      await set(id, newValue, _setBuiltin);
    }
    return _setBuiltin(id, newValue);
  }

  void operator []=(TId id, T? newValue) => set(id, newValue);

  /// Return a new ID for the [row].
  TId add(T row) {
    final curId = idAllocator.alloc(row);
    final ids = idList ?? <TId>[];
    ids.add(curId);
    this[curId] = row;
    idList = ids;
    return curId;
  }

  /// Delete the timetable by [id].
  /// If [selectedId] is deleted, an available timetable would be switched to.
  void delete(TId id) {
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
    idAllocator.clear();
    $selected.notifier();
    $any.notifier();
  }

  // TODO: Row delegate?
  /// ignore null row
  List<({TId id, T row})> getRowsWithId() {
    final ids = idList;
    final res = <({TId id, T row})>[];
    if (ids == null) return res;
    for (final id in ids) {
      final row = this[id];
      if (row != null) {
        res.add((id: id, row: row));
      }
    }
    return res;
  }

  // TODO: Row delegate?
  /// ignore null row
  List<T> getRows() {
    final ids = idList;
    final res = <T>[];
    if (ids == null) return res;
    for (final id in ids) {
      final row = this[id];
      if (row != null) {
        res.add(row);
      }
    }
    return res;
  }

  Listenable listenRowChange(TId id) => box.listenable(keys: [_rowK(id)]);

  late final $rowOf = box.providerFamily<T, TId>(
    (id) => _rowK(id),
    get: (id) => this[id],
    set: (id, v) => this[id] = v,
  );

  late final $rows = $any.provider<List<T>>(
    get: getRows,
  );
  late final $rowsWithId = $any.provider<List<({TId id, T row})>>(
    get: getRowsWithId,
  );
  late final $selectedId = $selected.provider<TId?>(
    get: () => selectedId,
  );
  late final $selectedRow = $selected.provider<T?>(
    get: () => selectedRow,
  );
// TODO: compose them
// late final $selectedRowWithId = Provider((ref){
//   return (id: ref.watch<int?>($selectedId));
// });
}
