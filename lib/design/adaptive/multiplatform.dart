import 'package:mimir/r.dart';
import 'package:universal_platform/universal_platform.dart';

bool get isCupertino => R.debugCupertino || UniversalPlatform.isIOS || UniversalPlatform.isMacOS;
