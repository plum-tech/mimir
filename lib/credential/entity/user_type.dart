import '../symbol.dart';
import '../using.dart';

part 'user_type.g.dart';

/// Note: In the new UserType, freshman isn't a valid UserType.
/// If you want to determine whether the user is a freshman, please check [Auth.freshmanCredential].
///
/// Offline isn't not different from others.
/// Instead, you should check the credentials to determine whether the function is open for them.
@HiveType(typeId: HiveTypeId.userType)
enum UserType {
  /// 本、专科生（10位学号）
  @HiveField(0)
  undergraduate,

  /// 研究生（9位学号）
  @HiveField(1)
  postgraduate,

  /// 教师（4位工号）
  @HiveField(2)
  teacher,
}
