// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'letter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WordleLetter _$WordleLetterFromJson(Map<String, dynamic> json) => WordleLetter(
      letter: json['letter'] as String,
      status: $enumDecode(_$LetterStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$WordleLetterToJson(WordleLetter instance) => <String, dynamic>{
      'letter': instance.letter,
      'status': _$LetterStatusEnumMap[instance.status]!,
    };

const _$LetterStatusEnumMap = {
  LetterStatus.neutral: 'neutral',
  LetterStatus.correct: 'correct',
  LetterStatus.dislocated: 'dislocated',
  LetterStatus.wrong: 'wrong',
};
