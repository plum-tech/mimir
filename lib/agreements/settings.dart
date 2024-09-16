import 'package:hive/hive.dart';
import 'package:mimir/utils/hive.dart';

import 'entity/agreements.dart';

class _AgreementsK {
  static const ns = "/agreements";

  static String acceptanceKeyOf(AgreementsType type) => "$ns/acceptance/${type.name}";
}

class AgreementsSettings {
  final Box box;

  AgreementsSettings(this.box);

  bool? getAgreementsAcceptanceOf(AgreementsType type) => box.safeGet<bool>(_AgreementsK.acceptanceKeyOf(type));

  Future<void> setAgreementsAcceptanceOf(AgreementsType type, bool? newV) async =>
      await box.safePut<bool>(_AgreementsK.acceptanceKeyOf(type), newV);

  late final $AgreementsAcceptanceOf = box.providerFamily<bool, AgreementsType>(
    _AgreementsK.acceptanceKeyOf,
    get: getAgreementsAcceptanceOf,
    set: setAgreementsAcceptanceOf,
  );
}
