import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';

Future<Set<String>> generateDictionary() async {
  final dicContents = await rootBundle.loadString("assets/game/wordle/all.json");
  final list = (jsonDecode(dicContents) as List).cast<String>();
  return list.toSet();
}

Future<List<String>> generateQuestionSet({required String dicName}) async {
  String dicContents = await rootBundle.loadString("assets/game/wordle/$dicName.json");
  final database = <String>[];
  final list = (jsonDecode(dicContents) as List).cast<String>();
  for (final word in list) {
    database.add(word);
  }
  return database;
}

Future<String> fetchOnlineWord() async {
  await Future.delayed(const Duration(seconds: 2));
  return "BINGO";
}

final _rand = Random();

String getNextWord(List<String> database) {
  return database[_rand.nextInt(database.length)];
}
