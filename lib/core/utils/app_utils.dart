import 'package:url_launcher/url_launcher.dart';

/// This utility class helps to launch an url
class AppUtils {
  static void launchURL(String url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
}
