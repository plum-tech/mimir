import 'package:easy_localization/easy_localization.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mimir/hive/type_id.dart';

part 'message.g.dart';

enum YwbApplicationType {
  todo,
  running,
  complete,
}

// @JsonSerializable()
// @HiveType(typeId: HiveTypeYwb.messageCount)
// class ApplicationMessageCount {
//   @JsonKey(name: 'myFlow_complete_count')
//   @HiveField(0)
//   final int completed;
//   @JsonKey(name: 'myFlow_runing_count')
//   @HiveField(1)
//   final int inProgress;
//   @JsonKey(name: 'myFlow_todo_count')
//   @HiveField(2)
//   final int inDraft;
//
//   const ApplicationMessageCount(this.completed, this.inProgress, this.inDraft);
//
//   factory ApplicationMessageCount.fromJson(Map<String, dynamic> json) => _$ApplicationMessageCountFromJson(json);
// }

@JsonSerializable()
@HiveType(typeId: HiveTypeYwb.message)
class YwbApplication {
  @JsonKey(name: 'WorkID')
  @HiveField(0)
  final int flowId;
  @JsonKey(name: 'FK_Flow')
  @HiveField(1)
  final String functionId;
  @JsonKey(name: 'FlowName')
  @HiveField(2)
  final String name;
  @JsonKey(name: 'NodeName')
  @HiveField(3)
  final String recentStep;
  @JsonKey(name: 'FlowNote')
  @HiveField(4)
  final String status;

  const YwbApplication(this.flowId, this.functionId, this.name, this.recentStep, this.status);

  factory YwbApplication.fromJson(Map<String, dynamic> json) => _$YwbApplicationFromJson(json);
}

final _tsFormat = DateFormat("yyyy-MM-dd hh:mm:ss");

DateTime _parseTimestamp(dynamic ts) {
  return _tsFormat.parse(ts);
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
  final String recieverId;
  @JsonKey(name: "EmpToT")
  final String recieverName;
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
    required this.recieverId,
    required this.recieverName,
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
