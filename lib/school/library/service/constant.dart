class Constants {
  static const homeUrl = 'http://210.35.66.106';
  static const opacUrl = '$homeUrl/opac';

  static const searchUrl = '$opacUrl/search';
  static const hotSearchUrl = '$opacUrl/hotsearch';
  static const apiUrl = '$opacUrl/api';
  static const bookUrl = '$opacUrl/book';

  static const loanUrl = '$opacUrl/loan';
  static const currentLoanListUrl = '$loanUrl/currentLoanList';
  static const historyLoanListUrl = '$loanUrl/historyLoanList';
  static const renewList = '$loanUrl/renewList';
  static const doRenewUrl = '$loanUrl/doRenew';

  static const bookHoldingUrl = '$apiUrl/holding';
  static const bookHoldingPreviewsUrl = '$bookUrl/holdingPreviews';
  static const virtualBookshelfUrl = '$apiUrl/virtualBookshelf';

  static const bookImageInfoUrl = 'https://book-resource.dataesb.com/websearch/metares';
}
