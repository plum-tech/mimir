import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

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
    final token = await BackendInit.auth.signInBySchoolId(
      school: school,
      schoolId: schoolId,
      password: password,
    );
    return true;
  }

  /// returns whether signing-up is success
  static Future<bool> signUpMimir(
    BuildContext context, {
    required SchoolCode school,
    required String schoolId,
    required String password,
  }) async {
    final token = await BackendInit.auth.signUpBySchoolId(
      school: school,
      schoolId: schoolId,
      password: password,
    );
    return true;
  }
}
