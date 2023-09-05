import 'package:url_launcher/url_launcher_string.dart';

Future<void> launchUrlInBrowser(String url) async {
  await launchUrlString(url, mode: LaunchMode.externalApplication);
}
