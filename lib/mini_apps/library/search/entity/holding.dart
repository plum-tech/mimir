class HoldingItem {
  // 图书记录号(同一本书可能有多本，该参数用于标识同一本书的不同本)
  final int bookRecordId;

  // 图书编号(用于标识哪本书)
  final int bookId;

  // 馆藏状态类型名称
  final String stateTypeName;

  // 条码号
  final String barcode;

  // 索书号
  final String callNo;

  // 文献所属馆
  final String originLibrary;

  // 所属馆位置
  final String originLocation;

  // 文献所在馆
  final String currentLibrary;

  // 所在馆位置
  final String currentLocation;

  // 流通类型名称
  final String circulateTypeName;

  // 流通类型描述
  final String circulateTypeDescription;

  // 注册日期
  final DateTime registerDate;

  // 入馆日期
  final DateTime inDate;

  // 单价
  final double singlePrice;

  // 总价
  final double totalPrice;

  const HoldingItem(
      this.bookRecordId,
      this.bookId,
      this.stateTypeName,
      this.barcode,
      this.callNo,
      this.originLibrary,
      this.originLocation,
      this.currentLibrary,
      this.currentLocation,
      this.circulateTypeName,
      this.circulateTypeDescription,
      this.registerDate,
      this.inDate,
      this.singlePrice,
      this.totalPrice);

  @override
  String toString() {
    return 'HoldingItem{bookRecordId: $bookRecordId, bookId: $bookId, stateTypeName: $stateTypeName, barcode: $barcode, callNo: $callNo, originLibrary: $originLibrary, originLocation: $originLocation, currentLibrary: $currentLibrary, currentLocation: $currentLocation, circulateTypeName: $circulateTypeName, circulateTypeDescription: $circulateTypeDescription, registerDate: $registerDate, inDate: $inDate, singlePrice: $singlePrice, totalPrice: $totalPrice}';
  }
}

class HoldingInfo {
  final List<HoldingItem> holdingList;

  const HoldingInfo(this.holdingList);

  @override
  String toString() {
    return 'HoldingInfo{holdingList: $holdingList}';
  }
}
