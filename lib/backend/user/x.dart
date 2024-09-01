import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/credentials/init.dart';
import 'package:mimir/utils/error.dart';

import '../init.dart';
import 'entity/user.dart';

class XMimirUser {
  static Future<void> signIn(BuildContext context) async {
    await context.push("/mimir/sign-in");
  }

  /// returns whether signing-in is success
  static Future<bool> signInMimir(
    BuildContext context, {
    required SchoolCode school,
    required String schoolId,
    required String password,
  }) async {
    try {
      await BackendInit.auth.signInBySchoolId(
        school: school,
        schoolId: schoolId,
        password: password,
      );
      CredentialsInit.storage.mimir.signedIn = true;
      CredentialsInit.storage.mimir.lastAuthTime = DateTime.now();
      return true;
    } catch (error, stackTrace) {
      debugPrintError(error, stackTrace);
      return false;
    }
  }

  /// returns whether signing-up is success
  static Future<bool> signUpMimir(
    BuildContext context, {
    required SchoolCode school,
    required String schoolId,
    required String password,
  }) async {
    try {
      await BackendInit.auth.signUpBySchoolId(
        school: school,
        schoolId: schoolId,
        password: password,
      );
      CredentialsInit.storage.mimir.signedIn = true;
      CredentialsInit.storage.mimir.lastAuthTime = DateTime.now();
      return true;
    } catch (error, stackTrace) {
      debugPrintError(error, stackTrace);
      return false;
    }
  }

  /// returns whether signing-up is success
  static Future<bool> verifyAuth(BuildContext context) async {
    try {
      final authorized = await BackendInit.auth.verify();
      CredentialsInit.storage.mimir.signedIn = authorized;
      return true;
    } catch (error, stackTrace) {
      debugPrintError(error, stackTrace);
      return false;
    }
  }
}
