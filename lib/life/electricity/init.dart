import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

import 'service/electricity.dart';
import 'storage/electricity.dart';

class ElectricityBalanceInit {
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
