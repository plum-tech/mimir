import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

void debugPrintError(Object error, [StackTrace? stackTrace]) {
  if (error is DioException) {
    debugPrint(error.toString());
    debugPrintStack(stackTrace: error.stackTrace, maxFrames: 10);
  } else {
    debugPrint(error.toString());
    debugPrintStack(stackTrace: stackTrace);
  }
}
