import 'package:json_annotation/json_annotation.dart';

part 'collection_preview.g.dart';

@JsonSerializable()
class BookCollectionItem {
  @JsonKey(name: 'bookrecno')
  final int bookId;
  @JsonKey(name: 'barcode')
  final String barcode;
  @JsonKey(name: 'callno')
  final String callNumber;

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

  const BookCollectionItem({
    required this.bookId,
    required this.barcode,
    required this.callNumber,
    required this.currentLibrary,
    required this.currentLocation,
    required this.copyCount,
    required this.loanableCount,
  });

  factory BookCollectionItem.fromJson(Map<String, dynamic> json) => _$BookCollectionItemFromJson(json);

  Map<String, dynamic> toJson() => _$BookCollectionItemToJson(this);

  @override
  String toString() {
    return {
      "bookId": bookId,
      "barcode": barcode,
      "callNo": callNumber,
      "currentLibrary": currentLibrary,
      "currentLocation": currentLocation,
      "copyCount": copyCount,
      "loanableCount": loanableCount,
    }.toString();
  }
}
