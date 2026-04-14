import 'package:flutter/material.dart';
import '../data/facilities.dart';
import '../services/call_service.dart';
import '../services/maps_service.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  static final List<Map<String, String>> _helplines = [
    {'name': 'Ambulance', 'number': '108', 'icon': '🚑'},
    {'name': 'Police', 'number': '100', 'icon': '👮'},
    {'name': 'Fire Brigade', 'number': '101', 'icon': '🔥'},
    {'name': 'Women Helpline', 'number': '1091', 'icon': '👩'},
    {'name': 'Child Helpline', 'number': '1098', 'icon': '👶'},
  ];

  @override
  Widget build(BuildContext context) {
    final emergencyFacilities =
        facilities.where((f) => f.isEmergency24x7).toList();

    return Scaffold(
      backgroundColor: Colors.red.shade50,
      appBar: AppBar(
        title: const Text('Emergency'),
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner
            Container(
              width: double.infinity,
              color: Colors.red.shade700,
              padding: const EdgeInsets.all(16),
              child: const Column(
                children: [
                  Text(
                    '🚨 Emergency Services',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Tap to call immediately',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            _sectionHeader('Important Helplines'),
            ...(_helplines.map(
              (h) => _helpllineTile(h['icon']!, h['name']!, h['number']!),
            )),

            const SizedBox(height: 16),
            _sectionHeader('24×7 Emergency Hospitals in Vadodara'),
            ...emergencyFacilities.map((f) => Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.local_hospital,
                                color: Colors.red, size: 22),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                f.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                f.address,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade700),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => CallService.call(f.phone),
                                icon: const Icon(Icons.call, size: 18),
                                label: const Text('Call Now'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red.shade600,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(8)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => MapsService.openDirections(
                                    f.latitude, f.longitude),
                                icon: const Icon(Icons.directions,
                                    color: Colors.red, size: 18),
                                label: const Text('Directions',
                                    style: TextStyle(color: Colors.red)),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                      color: Colors.red),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(8)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.red.shade800,
        ),
      ),
    );
  }

  Widget _helpllineTile(String emoji, String name, String number) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Text(emoji, style: const TextStyle(fontSize: 28)),
        title: Text(name,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(number,
            style: TextStyle(
                color: Colors.red.shade700, fontWeight: FontWeight.bold)),
        trailing: ElevatedButton.icon(
          onPressed: () => CallService.call(number),
          icon: const Icon(Icons.call, size: 16),
          label: const Text('Call'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade600,
            foregroundColor: Colors.white,
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),
    );
  }
}
