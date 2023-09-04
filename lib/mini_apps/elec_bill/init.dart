import 'package:dio/dio.dart';

import 'service/electricity.dart';
import 'storage/electricity.dart';
import 'using.dart';

class ElectricityBillInit {
  static late ElectricityStorage storage;
  static late ElectricityService service;

  static void init({
    required Dio dio,
    required Box<dynamic> electricityBox,
  }) {
    service = ElectricityService(dio);
    storage = ElectricityStorage(electricityBox);
  }
}
