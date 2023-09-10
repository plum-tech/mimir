import 'package:json_annotation/json_annotation.dart';
import 'package:mimir/hive/type_id.dart';

part 'message.g.dart';

@HiveType(typeId: HiveTypeYwb.messageType)
enum ApplicationMessageType {
  @HiveField(0)
  todo,
  @HiveField(1)
  doing,
  @HiveField(2)
  done,
}

@JsonSerializable()
@HiveType(typeId: HiveTypeYwb.messageCount)
class ApplicationMessageCount {
  @JsonKey(name: 'myFlow_complete_count')
  @HiveField(0)
  final int completed;
  @JsonKey(name: 'myFlow_runing_count')
  @HiveField(1)
  final int inProgress;
  @JsonKey(name: 'myFlow_todo_count')
  @HiveField(2)
  final int inDraft;

  const ApplicationMessageCount(this.completed, this.inProgress, this.inDraft);

  factory ApplicationMessageCount.fromJson(Map<String, dynamic> json) => _$ApplicationMessageCountFromJson(json);
}

@JsonSerializable()
@HiveType(typeId: HiveTypeYwb.message)
class ApplicationMessage {
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

  const ApplicationMessage(this.flowId, this.functionId, this.name, this.recentStep, this.status);

  factory ApplicationMessage.fromJson(Map<String, dynamic> json) => _$ApplicationMessageFromJson(json);
}

@HiveType(typeId: HiveTypeYwb.messagePage)
class ApplicationMessagePage {
  @HiveField(0)
  final int totalNum;
  @HiveField(1)
  final int totalPage;
  @HiveField(2)
  final int currentPage;
  @HiveField(3)
  final List<ApplicationMessage> msgList;

  const ApplicationMessagePage(this.totalNum, this.totalPage, this.currentPage, this.msgList);
}
