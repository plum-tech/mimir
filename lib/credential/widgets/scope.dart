import 'package:flutter/widgets.dart';
import 'package:mimir/credential/entity/credential.dart';

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
    CredentialInit.credential.$OaCredential.addListener(_anyChange);
    CredentialInit.credential.$LastOaAuthTime.addListener(_anyChange);
  }

  @override
  void dispose() {
    CredentialInit.credential.$OaCredential.removeListener(_anyChange);
    CredentialInit.credential.$LastOaAuthTime.removeListener(_anyChange);
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
      child: widget.child,
    );
  }
}

class Auth extends InheritedWidget {
  final OACredential? oaCredential;
  final DateTime? lastOaAuthTime;

  const Auth({
    super.key,
    this.oaCredential,
    this.lastOaAuthTime,
    required super.child,
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
        CredentialInit.credential.lastOaAuthTime = DateTime.now();
      }
    }
  }

  setLastOaAuthTime(DateTime? newV) {
    CredentialInit.credential.lastOaAuthTime = newV;
  }
}
