import 'package:hive/hive.dart';
import 'package:mimir/utils/hive.dart';

import 'entity/agreements.dart';

class _AgreementsK {
  static const ns = "/agreements";

  static String acceptanceKeyOf(AgreementType type) => "$ns/acceptance/${type.name}";
}

class AgreementsSettings {
  final Box box;

  AgreementsSettings(this.box);

  bool? getAgreementsAcceptanceOf(AgreementType type) => box.safeGet<bool>(_AgreementsK.acceptanceKeyOf(type));

  Future<void> setAgreementsAcceptanceOf(AgreementType type, bool? newV) async =>
      await box.safePut<bool>(_AgreementsK.acceptanceKeyOf(type), newV);

  late final $agreementsAcceptanceOf = box.providerFamily<bool, AgreementType>(
    _AgreementsK.acceptanceKeyOf,
    get: getAgreementsAcceptanceOf,
    set: setAgreementsAcceptanceOf,
  );
}
