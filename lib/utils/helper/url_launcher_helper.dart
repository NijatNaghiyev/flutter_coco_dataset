import 'package:url_launcher/url_launcher.dart';

class UrlLauncherHelper {
  /// Opens a URL in an in-app web view
  static Future<bool> openInAppWebView(String url) async {
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      return launchUrl(
        uri,
        mode: LaunchMode.inAppWebView,
      );
    }
    return false;
  }
}
