import 'package:json_annotation/json_annotation.dart';

part 'collection.g.dart';

class BookCollection {
  /// 图书记录号(同一本书可能有多本，该参数用于标识同一本书的不同本)
  final int bookRecordId;

  /// 图书编号(用于标识哪本书)
  final int bookId;

  /// 馆藏状态类型名称
  final String stateTypeName;

  /// 条码号
  final String barcode;

  /// 索书号
  final String callNumber;

  /// 文献所属馆
  final String originLibrary;

  /// 所属馆位置
  final String originLocation;

  /// 文献所在馆
  final String currentLibrary;

  /// 所在馆位置
  final String currentLocation;

  /// 流通类型名称
  final String circulateTypeName;

  /// 流通类型描述
  final String circulateTypeDescription;

  /// 注册日期
  final DateTime registerDate;

  /// 入馆日期
  final DateTime inDate;

  /// 单价
  final double singlePrice;

  /// 总价
  final double totalPrice;

  const BookCollection({
    required this.bookRecordId,
    required this.bookId,
    required this.stateTypeName,
    required this.barcode,
    required this.callNumber,
    required this.originLibrary,
    required this.originLocation,
    required this.currentLibrary,
    required this.currentLocation,
    required this.circulateTypeName,
    required this.circulateTypeDescription,
    required this.registerDate,
    required this.inDate,
    required this.singlePrice,
    required this.totalPrice,
  });

  @override
  String toString() {
    return {
      "bookRecordId": bookRecordId,
      "bookId": bookId,
      "stateTypeName": stateTypeName,
      "barcode": barcode,
      "callNumber": callNumber,
      "originLibrary": originLibrary,
      "originLocation": originLocation,
      "currentLibrary": currentLibrary,
      "currentLocation": currentLocation,
      "circulateTypeName": circulateTypeName,
      "circulateTypeDescription": circulateTypeDescription,
      "registerDate": registerDate,
      "inDate": inDate,
      "singlePrice": singlePrice,
      "totalPrice": totalPrice,
    }.toString();
  }
}

/// 图书的流通类型
@JsonSerializable()
class BookCirculateType {
  // 流通类型代码
  @JsonKey(name: 'cirtype')
  final String circulateType;

  // 图书馆代码(SITLIB等)
  @JsonKey(name: 'libcode')
  final String libraryCode;

  // 流通类型名
  final String name;

  // 流通类型描述
  @JsonKey(name: 'descripe')
  final String description;

  // 不知道是啥
  final int loanNumSign;

  // 不知道是啥
  final int isPreviService;

  const BookCirculateType(
      this.circulateType, this.libraryCode, this.name, this.description, this.loanNumSign, this.isPreviService);

  factory BookCirculateType.fromJson(Map<String, dynamic> json) => _$BookCirculateTypeFromJson(json);

  Map<String, dynamic> toJson() => _$BookCirculateTypeToJson(this);
}

@JsonSerializable()
class BookCollectionState {
  final int stateType;
  final String stateName;

  const BookCollectionState(this.stateType, this.stateName);

  factory BookCollectionState.fromJson(Map<String, dynamic> json) => _$BookCollectionStateFromJson(json);

  Map<String, dynamic> toJson() => _$BookCollectionStateToJson(this);
}

@JsonSerializable()
class BookCollectionItem {
  // 图书记录号(同一本书可能有多本，该参数用于标识同一本书的不同本)
  @JsonKey(name: 'recno')
  final int bookRecordId;

  // 图书编号(用于标识哪本书)
  @JsonKey(name: 'bookrecno')
  final int bookId;

  // 馆藏状态类型号
  @JsonKey(name: 'state')
  final int stateType;

  // 条码号
  final String barcode;

  // 索书号
  @JsonKey(name: 'callno')
  final String callNumber;

  // 文献所属馆
  @JsonKey(name: 'orglib')
  final String originLibraryCode;
  @JsonKey(name: 'orglocal')
  final String originLocationCode;

  // 文献所在馆
  @JsonKey(name: 'curlib')
  final String currentLibraryCode;
  @JsonKey(name: 'curlocal')
  final String currentLocationCode;

  // 流通类型
  @JsonKey(name: 'cirtype')
  final String circulateType;

  // 注册日期
  @JsonKey(name: 'regdate')
  final String registerDate;

  // String? register_time;

  // 入馆日期
  @JsonKey(name: 'indate')
  final String inDate;

  // 单价
  final double singlePrice;

  // 总价
  final double totalPrice;

  const BookCollectionItem({
    required this.bookRecordId,
    required this.bookId,
    required this.stateType,
    required this.barcode,
    required this.callNumber,
    required this.originLibraryCode,
    required this.originLocationCode,
    required this.currentLibraryCode,
    required this.currentLocationCode,
    required this.circulateType,
    required this.registerDate,
    required this.inDate,
    required this.singlePrice,
    required this.totalPrice,
  });

// double totalLoanNum;
  factory BookCollectionItem.fromJson(Map<String, dynamic> json) => _$BookCollectionItemFromJson(json);

  Map<String, dynamic> toJson() => _$BookCollectionItemToJson(this);
}

@JsonSerializable()
class BookCollectionInfo {
  // 馆藏信息列表
  final List<BookCollectionItem> holdingList;

  // "libcodeMap": {
  //     "SITLIB": "上应大",
  //     "999": "中心馆"
  // },

  // 图书馆代码字典
  @JsonKey(name: 'libcodeMap')
  final Map<String, String> libraryCodeMap;

  // "localMap": {
  //   "110": "徐汇社科阅览室",
  //   "111": "徐汇综合阅览室",
  //   "001": "奉贤借阅",
  //   "002": "社科历史地理",
  //   "003": "奉贤外文",

  @JsonKey(name: 'localMap')
  final Map<String, String> locationMap;

  // "pBCtypeMap": {
  //   "SIT_US01": {
  //       "cirtype": "SIT_US01",
  //       "libcode": "SITLIB",
  //       "name": "西文图书",
  //       "descripe": "全局西文图书",
  //       "loanNumSign": 0,
  //       "isPreviService": 1
  //   },
  //   "SIT_US02": {
  //       "cirtype": "SIT_US02",
  @JsonKey(name: 'pBCtypeMap')
  final Map<String, BookCirculateType> circulateTypeMap;

  // "holdStateMap": {
  //   "32": {
  //       "stateType": 32,
  //       "stateName": "已签收"
  //   },
  //   "0": {
  //       "stateType": 0,
  //       "stateName": "流通还回上架中"
  //   },
  // 馆藏状态
  final Map<String, BookCollectionState> holdStateMap;

  // 不知道是啥
  // "libcodeDeferDateMap": {
  //     "SITLIB": 7,
  //     "999": 7
  // }
  final Map<String, int> libcodeDeferDateMap;

  // 不知道是啥
  // "barcodeLocationUrlMap": {
  //     "SITLIB": "http://210.35.66.106:8088/TSDW/GotoFlash.aspx?szBarCode=",
  //     "999": "http://210.35.66.106:8088"
  // },
  final Map<String, String> barcodeLocationUrlMap;

  const BookCollectionInfo({
    required this.holdingList,
    required this.libraryCodeMap,
    required this.locationMap,
    required this.circulateTypeMap,
    required this.holdStateMap,
    required this.libcodeDeferDateMap,
    required this.barcodeLocationUrlMap,
  });

  factory BookCollectionInfo.fromJson(Map<String, dynamic> json) => _$BookCollectionInfoFromJson(json);

  Map<String, dynamic> toJson() => _$BookCollectionInfoToJson(this);
}
