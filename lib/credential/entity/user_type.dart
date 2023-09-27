import 'package:mimir/hive/type_id.dart';

part 'user_type.g.dart';

typedef UserCapability = ({bool enableClass2nd});

@HiveType(typeId: HiveTypeCredentials.oaUserType)
enum OaUserType {
  @HiveField(0)
  undergraduate((enableClass2nd: true,)),
  @HiveField(1)
  postgraduate((enableClass2nd: false,)),
  @HiveField(2)
  other((enableClass2nd: false,));

  final UserCapability capability;

  const OaUserType(this.capability);
}
