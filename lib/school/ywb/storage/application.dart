import 'package:hive/hive.dart';

import '../entity/application.dart';

class _K {
  static const ns = "/application";
  static const todo = "$ns/todo";
  static const running = "$ns/running";
  static const complete = "$ns/complete";
}

class YwbApplicationStorage {
  final Box<dynamic> box;

  const YwbApplicationStorage(this.box);

  List<YwbApplication>? get todo => (box.get(_K.todo) as List?)?.cast<YwbApplication>();

  set todo(List<YwbApplication>? newV) => box.put(_K.todo, newV);

  List<YwbApplication>? get running => (box.get(_K.running) as List?)?.cast<YwbApplication>();

  set running(List<YwbApplication>? newV) => box.put(_K.running, newV);

  List<YwbApplication>? get complete => (box.get(_K.complete) as List?)?.cast<YwbApplication>();

  set complete(List<YwbApplication>? newV) => box.put(_K.complete, newV);
}

extension YwbApplicationStorageX on YwbApplicationStorage {
  MyYwbApplications? get myApplications {
    final todo = this.todo;
    final running = this.running;
    final complete = this.complete;
    if (todo == null || running == null || complete == null) {
      return null;
    }
    return (
      todo: todo,
      running: running,
      complete: complete,
    );
  }

  set myApplications(MyYwbApplications? newV) {
    if (newV == null) {
      todo = null;
      running = null;
      complete = null;
    } else {
      todo = newV.todo;
      running = newV.running;
      complete = newV.complete;
    }
  }
}
