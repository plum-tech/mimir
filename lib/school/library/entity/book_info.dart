class BookInfo {
  final String title;
  final String isbn;
  final String price;
  final Map<String, String> rawDetail;

  BookInfo({
    required this.title,
    required this.isbn,
    required this.price,
    required this.rawDetail,
  });
}
