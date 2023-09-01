import 'package:json_annotation/json_annotation.dart';

part 'holding_preview.g.dart';

@JsonSerializable()
class HoldingPreviewItem {
  // 图书编号
  @JsonKey(name: 'bookrecno')
  final int bookId;

  // 条码号
  @JsonKey(name: 'barcode')
  final String barcode;

  // 索书号
  @JsonKey(name: 'callno')
  final String callNo;

  // 文献所在馆
  @JsonKey(name: 'curlibName')
  final String currentLibrary;

  // 所在馆位置
  @JsonKey(name: 'curlocalName')
  final String currentLocation;

  // 总共有多少
  @JsonKey(name: 'copycount')
  final int copyCount;

  // 可借数量
  @JsonKey(name: 'loanableCount')
  final int loanableCount;

  const HoldingPreviewItem(
    this.bookId,
    this.barcode,
    this.callNo,
    this.currentLibrary,
    this.currentLocation,
    this.copyCount,
    this.loanableCount,
  );

  factory HoldingPreviewItem.fromJson(Map<String, dynamic> json) => _$HoldingPreviewItemFromJson(json);

  Map<String, dynamic> toJson() => _$HoldingPreviewItemToJson(this);

  @override
  String toString() {
    return 'HoldingPreviewItem{bookId: $bookId, barcode: $barcode, callNo: $callNo, currentLibrary: $currentLibrary, currentLocation: $currentLocation, copyCount: $copyCount, loanableCount: $loanableCount}';
  }
}

@JsonSerializable()
class HoldingPreviews {
  @JsonKey(name: 'previews')
  final Map<String, List<HoldingPreviewItem>> previews;

  const HoldingPreviews(this.previews);

  factory HoldingPreviews.fromJson(Map<String, dynamic> json) => _$HoldingPreviewsFromJson(json);

  Map<String, dynamic> toJson() => _$HoldingPreviewsToJson(this);

  @override
  String toString() {
    return 'HoldingPreviews{previews: $previews}';
  }
}
