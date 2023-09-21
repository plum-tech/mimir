import 'package:flutter/widgets.dart';
import 'package:mimir/credential/entity/credential.dart';

import '../entity/login_status.dart';
import '../init.dart';

extension OaAuthX on BuildContext {
  OaAuth get auth => OaAuth.of(this);
}

class OaAuthManager extends StatefulWidget {
  final Widget child;

  const OaAuthManager({super.key, required this.child});

  @override
  State<OaAuthManager> createState() => _OaAuthManagerState();
}

class _OaAuthManagerState extends State<OaAuthManager> {
  final onOaChanged = CredentialInit.storage.listenOaChange();

  @override
  void initState() {
    super.initState();
    onOaChanged.addListener(anyChange);
  }

  @override
  void dispose() {
    onOaChanged.removeListener(anyChange);
    super.dispose();
  }

  void anyChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final storage = CredentialInit.storage;
    return OaAuth(
      credentials: storage.oaCredentials,
      lastAuthTime: storage.oaLastAuthTime,
      loginStatus: storage.oaLoginStatus ?? LoginStatus.never,
      child: widget.child,
    );
  }
}

class OaAuth extends InheritedWidget {
  final OaCredentials? credentials;
  final DateTime? lastAuthTime;
  final LoginStatus loginStatus;

  const OaAuth({
    super.key,
    this.credentials,
    this.lastAuthTime,
    required super.child,
    required this.loginStatus,
  });

  static OaAuth of(BuildContext context) {
    final OaAuth? result = context.dependOnInheritedWidgetOfExactType<OaAuth>();
    assert(result != null, 'No AuthScope found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(OaAuth oldWidget) {
    return credentials != oldWidget.credentials ||
        lastAuthTime != oldWidget.lastAuthTime ||
        loginStatus != oldWidget.loginStatus;
  }
}
