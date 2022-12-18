import 'package:permission_handler/permission_handler.dart';

Future<bool> ensurePermission(Permission permission) async {
  PermissionStatus status = await permission.status;

  if (status != PermissionStatus.granted) {
    status = await Permission.storage.request();
  }
  return status == PermissionStatus.granted;
}
