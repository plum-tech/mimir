import 'package:flutter/widgets.dart';
import 'package:mimir/credential/entity/credential.dart';

import '../entity/login_status.dart';
import '../init.dart';

extension OaAuthEx on BuildContext {
  OaAuth get auth => OaAuth.of(this);
}

class OaAuthManager extends StatefulWidget {
  final Widget child;

  const OaAuthManager({super.key, required this.child});

  @override
  State<OaAuthManager> createState() => _OaAuthManagerState();
}

class _OaAuthManagerState extends State<OaAuthManager> {
  final onOaChanged = CredentialInit.storage.onOaChanged;

  @override
  void initState() {
    super.initState();
    onOaChanged.addListener(_anyChange);
  }

  @override
  void dispose() {
    onOaChanged.removeListener(_anyChange);
    super.dispose();
  }

  void _anyChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final storage = CredentialInit.storage;
    return OaAuth(
      credential: storage.oaCredential,
      lastAuthTime: storage.oaLastAuthTime,
      loginStatus: storage.oaLoginStatus ?? LoginStatus.never,
      child: widget.child,
    );
  }
}

class OaAuth extends InheritedWidget {
  final OaCredential? credential;
  final DateTime? lastAuthTime;
  final LoginStatus loginStatus;

  const OaAuth({
    super.key,
    this.credential,
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
    return credential != oldWidget.credential ||
        lastAuthTime != oldWidget.lastAuthTime ||
        loginStatus != oldWidget.loginStatus;
  }

  setOaCredential(OaCredential? newV) {
    CredentialInit.storage.oaCredential = newV;
    if (newV != null) {
      CredentialInit.storage.oaLoginStatus = LoginStatus.validated;
      CredentialInit.storage.oaLastAuthTime = DateTime.now();
    } else {
      CredentialInit.storage.oaLoginStatus = LoginStatus.offline;
    }
  }

  setLastOaAuthTime(DateTime? newV) {
    CredentialInit.storage.oaLastAuthTime = newV;
  }

  setLoginStatus(LoginStatus status) {
    CredentialInit.storage.oaLoginStatus = status;
  }
}
