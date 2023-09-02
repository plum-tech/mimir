import 'package:flutter/widgets.dart';
import 'package:mimir/credential/entity/credential.dart';

import '../entity/login_status.dart';
import '../init.dart';

extension AuthEx on BuildContext {
  Auth get auth => Auth.of(this);
}

class AuthManager extends StatefulWidget {
  final Widget child;

  const AuthManager({super.key, required this.child});

  @override
  State<AuthManager> createState() => _AuthManagerState();
}

class _AuthManagerState extends State<AuthManager> {
  @override
  void initState() {
    super.initState();
    CredentialInit.credential.onAnyChanged.addListener(_anyChange);
  }

  @override
  void dispose() {
    CredentialInit.credential.onAnyChanged.removeListener(_anyChange);
    super.dispose();
  }

  void _anyChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final storage = CredentialInit.credential;
    return Auth(
      oaCredential: storage.oaCredential,
      lastOaAuthTime: storage.lastOaAuthTime,
      loginStatus: storage.loginStatus ?? LoginStatus.never,
      child: widget.child,
    );
  }
}

class Auth extends InheritedWidget {
  final OACredential? oaCredential;
  final DateTime? lastOaAuthTime;
  final LoginStatus loginStatus;

  const Auth({
    super.key,
    this.oaCredential,
    this.lastOaAuthTime,
    required super.child,
    required this.loginStatus,
  });

  static Auth of(BuildContext context) {
    final Auth? result = context.dependOnInheritedWidgetOfExactType<Auth>();
    assert(result != null, 'No AuthScope found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(Auth oldWidget) {
    return oaCredential != oldWidget.oaCredential || lastOaAuthTime != oldWidget.lastOaAuthTime;
  }

  setOaCredential(OACredential? newV) {
    if (CredentialInit.credential.oaCredential != newV) {
      CredentialInit.credential.oaCredential = newV;
      if (newV != null) {
        CredentialInit.credential.loginStatus = LoginStatus.validated;
        CredentialInit.credential.lastOaAuthTime = DateTime.now();
      } else {
        CredentialInit.credential.loginStatus = LoginStatus.offline;
      }
    }
  }

  setLastOaAuthTime(DateTime? newV) {
    CredentialInit.credential.lastOaAuthTime = newV;
  }

  setLoginStatus(LoginStatus status) {
    CredentialInit.credential.loginStatus = status;
  }
}
