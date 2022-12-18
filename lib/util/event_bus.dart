import 'dart:async';

/// 订阅者回调签名
typedef EventCallback<T> = void Function(T? arg);

/// 事件总线工具类
/// E为事件类型，一般使用枚举类型，也可使用其他类型
class EventBus<E> {
  /// 保存事件订阅者队列，key:事件名(id)，value: 对应事件的订阅者队列
  final _eventMap = <E, List<EventCallback>?>{};

  /// 监听事件
  Future<T?> listen<T>(E eventName) {
    final completer = Completer<T>();

    void subscriber(T? arg) {
      completer.complete(arg);
      off(eventName, subscriber);
    }

    on<T>(eventName, subscriber);
    return completer.future;
  }

  /// 添加订阅者
  void on<T>(E eventName, EventCallback<T> callback) {
    // 如果对应事件的队列不存在，就新建一个新队列
    _eventMap[eventName] ??= <EventCallback>[];
    // 为队列追加元素，由于类型不统一，所以需要单独嵌套做类型转换
    _eventMap[eventName]!.add((arg) => callback(arg));
  }

  /// 判定订阅者是否存在
  bool contain<T>(E eventName, [EventCallback<T>? f]) {
    // 获取队列，若该事件不存在，那直接退出函数
    final list = _eventMap[eventName];
    if (list == null) {
      return false;
    }
    // 若回调为空，则删除队列所有值
    if (f == null) {
      return false;
    } else {
      return list.contains(f);
    }
  }

  /// 移除订阅者
  void off<T>(E eventName, [EventCallback<T>? f]) {
    // 获取队列，若该事件不存在，那直接退出函数
    final list = _eventMap[eventName];
    if (list == null) {
      return;
    }
    // 若回调为空，则删除队列所有值
    if (f == null) {
      _eventMap[eventName] = null;
    } else {
      // 不为空时，删除特定回调
      list.remove(f);
    }
  }

  /// 触发事件，事件触发后该事件所有订阅者会被调用
  /// T为发布参数类型
  void emit<T>(E eventName, [T? arg]) {
    final list = _eventMap[eventName];
    if (list == null) {
      return;
    }
    // 队列队尾元素为先进元素，需要先调用
    for (final element in list.reversed) {
      element(arg);
    }
  }
}
