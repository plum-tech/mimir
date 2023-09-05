import 'dart:async';

Timer runPeriodically(
  Duration duration,
  void Function(Timer timer) callback,
) {
  final timer = Timer.periodic(duration, callback);
  Timer.run(() => callback(timer));
  return timer;
}
