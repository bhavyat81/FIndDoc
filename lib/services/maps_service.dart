import 'package:url_launcher/url_launcher.dart';

class MapsService {
  static Future<void> openDirections(double lat, double lng) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
    );
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not open Google Maps');
    }
  }
}
