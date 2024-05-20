import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';

Future<Set<String>> generateDictionary() async {
  final dicContents = await rootBundle.loadString("assets/game/wordle/all.json");
  final list = (jsonDecode(dicContents) as List).cast<String>();
  return list.toSet();
}

Future<Map<String, List<String>>> generateQuestionSet({required String dicName}) async {
  String dicContents = await rootBundle.loadString("assets/game/wordle/$dicName.json");
  Map<String, List<String>> database = {};
  final list = (jsonDecode(dicContents) as List).cast<String>();
  for (final word in list) {
    database[word] = [];
  }
  return database;
}

Future<String> fetchOnlineWord() async {
  await Future.delayed(const Duration(seconds: 2));
  return "BINGO";
}

String getNextWord(Map<String, List<String>> database) {
  var rng = Random();
  return database.keys.elementAt(rng.nextInt(database.length));
}
