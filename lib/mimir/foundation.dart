part of 'mimir.dart';

abstract class MimirDebugOptions {
  bool get isDebug;
}

mixin _MimirDebugOptionsImpl implements MimirDebugOptions {
  @override
  bool isDebug = false;
}
