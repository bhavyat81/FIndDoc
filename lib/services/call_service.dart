import 'package:url_launcher/url_launcher.dart';

class CallService {
  static Future<void> call(String phoneNumber) async {
    final uri = Uri(scheme: 'tel', path: phoneNumber);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch phone call');
    }
  }
}
