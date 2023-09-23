import 'package:easy_localization/easy_localization.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mimir/hive/type_id.dart';

part 'message.g.dart';

enum YwbApplicationType {
  todo,
  running,
  complete,
}

final _tsFormat = DateFormat("yyyy-MM-dd hh:mm");

DateTime _parseTimestamp(dynamic ts) {
  return _tsFormat.parse(ts);
}

@JsonSerializable(createToJson: false)
@HiveType(typeId: HiveTypeYwb.message)
class YwbApplication {
  @JsonKey(name: 'WorkID')
  @HiveField(0)
  final int workId;
  @JsonKey(name: 'FK_Flow')
  @HiveField(1)
  final String functionId;
  @JsonKey(name: 'FlowName')
  @HiveField(2)
  final String name;
  @JsonKey(name: 'FlowNote')
  @HiveField(3)
  final String note;
  @JsonKey(name: 'RDT', fromJson: _parseTimestamp)
  @HiveField(4)
  final DateTime startTs;
  @JsonKey(includeFromJson: false, includeToJson: false)
  @HiveField(5)
  final List<YwbApplicationTrack> track;

  const YwbApplication({
    required this.workId,
    required this.functionId,
    required this.name,
    required this.note,
    required this.startTs,
    this.track = const [],
  });

  YwbApplication copyWith({
    int? workId,
    String? functionId,
    String? name,
    String? note,
    DateTime? startTs,
    List<YwbApplicationTrack>? track,
  }) {
    return YwbApplication(
      workId: workId ?? this.workId,
      functionId: functionId ?? this.functionId,
      name: name ?? this.name,
      note: note ?? this.note,
      startTs: startTs ?? this.startTs,
      track: track ?? this.track,
    );
  }

  factory YwbApplication.fromJson(Map<String, dynamic> json) => _$YwbApplicationFromJson(json);
}

@JsonSerializable(createToJson: false)
class YwbApplicationTrack {
  @JsonKey(name: "ActionTypeText")
  final String action;
  @JsonKey(name: "EmpFrom")
  final String senderId;
  @JsonKey(name: "EmpFromT")
  final String senderName;
  @JsonKey(name: "EmpTo")
  final String receiverId;
  @JsonKey(name: "EmpToT")
  final String receiverName;
  @JsonKey(name: "Msg")
  final String message;
  @JsonKey(name: "RDT", fromJson: _parseTimestamp)
  final DateTime timestamp;
  @JsonKey(name: "NDFromT")
  final String step;

  const YwbApplicationTrack({
    required this.action,
    required this.senderId,
    required this.senderName,
    required this.receiverId,
    required this.receiverName,
    required this.message,
    required this.timestamp,
    required this.step,
  });

  factory YwbApplicationTrack.fromJson(Map<String, dynamic> json) => _$YwbApplicationTrackFromJson(json);
}

typedef MyYwbApplications = ({
  List<YwbApplication> todo,
  List<YwbApplication> running,
  List<YwbApplication> complete,
});
