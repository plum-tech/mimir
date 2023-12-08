class LibraryApi {
  static const opacUrl = 'http://210.35.66.106/opac';
  static const forgotLoginPasswordUrl = "$opacUrl/reader/retrievePassword";

  static const searchUrl = '$opacUrl/search';
  static const hotSearchUrl = '$opacUrl/hotsearch';
  static const apiUrl = '$opacUrl/api';
  static const bookUrl = '$opacUrl/book';

  static const loanUrl = '$opacUrl/loan';
  static const currentLoanListUrl = '$loanUrl/currentLoanList';
  static const historyLoanListUrl = '$loanUrl/historyLoanList';
  static const renewList = '$loanUrl/renewList';
  static const doRenewUrl = '$loanUrl/doRenew';

  static const bookCollectionUrl = '$apiUrl/holding';
  static const bookCollectionPreviewsUrl = '$bookUrl/holdingPreviews';
  static const virtualBookshelfUrl = '$apiUrl/virtualBookshelf';

  static const bookImageInfoUrl = 'https://book-resource.dataesb.com/websearch/metares';
}
