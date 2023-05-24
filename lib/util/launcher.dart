// 返回执行结果，如果false表示失败
typedef OnLaunchCallback = Future<bool> Function(String);

class LaunchScheme {
  final bool Function(String scheme) matcher;
  final OnLaunchCallback onLaunch;

  const LaunchScheme({
    required this.matcher,
    required this.onLaunch,
  });
}

class SchemeLauncher {
  List<LaunchScheme> schemes;
  OnLaunchCallback? onNotFound;

  SchemeLauncher({
    this.schemes = const [],
    this.onNotFound,
  });

  Future<bool> launch(String schemeText) async {
    for (final scheme in schemes) {
      // 如果被接受且执行成功，那么直接return掉
      if (scheme.matcher(schemeText)) {
        return await scheme.onLaunch(schemeText);
      }
    }

    if (onNotFound != null) {
      onNotFound!(schemeText);
    }
    return false;
  }
}
