import 'package:event_bus/event_bus.dart';

final _homepage = EventBus();
final _global = EventBus();
final _expenseTracker = EventBus();

class On {
  static void home<T>(void Function(T event)? onFire) {
    _homepage.on<T>().listen(onFire);
  }

  static void global<T>(void Function(T event)? onFire) {
    _global.on<T>().listen(onFire);
  }

  static void expenseTracker<T>(void Function(T event) onFire) {
    _expenseTracker.on<T>().listen(onFire);
  }
}

class FireOn {
  static void homepage<T>(T event) {
    _homepage.fire(event);
  }

  static void global<T>(T event) {
    _global.fire(event);
  }

  static void expenseTracker<T>(T event) {
    _homepage.fire(event);
  }
}
