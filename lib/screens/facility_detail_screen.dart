import 'package:flutter/material.dart';
import '../data/doctors.dart' as doctor_data;
import '../data/specialities.dart';
import '../models/doctor.dart';
import '../models/doctor_facility.dart';
import '../models/facility.dart';
import '../services/call_service.dart';
import '../services/maps_service.dart';
import '../services/timing_utils.dart';
import 'doctor_detail_screen.dart';

class FacilityDetailScreen extends StatelessWidget {
  final Facility facility;

  const FacilityDetailScreen({super.key, required this.facility});

  String get _typeLabel {
    switch (facility.type) {
      case 'hospital':
        return 'Multispeciality Hospital';
      case 'clinic':
        return 'Clinic';
      case 'lab':
        return 'Diagnostic Lab';
      default:
        return facility.type;
    }
  }

  List<MapEntry<Doctor, DoctorFacility>> get _doctorsHere {
    final dfs = doctor_data.doctorFacilities
        .where((df) => df.facilityId == facility.id)
        .toList();
    return dfs.map((df) {
      final doc = doctor_data.doctors.firstWhere((d) => d.id == df.doctorId);
      return MapEntry(doc, df);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final doctorEntries = _doctorsHere;
    final timing = weeklyTimingSummary(facility.timings);

    return Scaffold(
      appBar: AppBar(
        title: Text(facility.name),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card
            Container(
              color: Colors.teal.shade700,
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    facility.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _typeLabel,
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        '${facility.rating.toStringAsFixed(1)} (${facility.reviewCount} reviews)',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  if (facility.isEmergency24x7) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red.shade600,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '🚨 Emergency 24x7',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Address
                  _infoRow(Icons.location_on, facility.address),
                  const SizedBox(height: 8),
                  _infoRow(Icons.phone, facility.phone),
                  const SizedBox(height: 16),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => CallService.call(facility.phone),
                          icon: const Icon(Icons.call),
                          label: const Text('Call'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => MapsService.openDirections(
                              facility.latitude, facility.longitude),
                          icon: const Icon(Icons.map, color: Colors.teal),
                          label: const Text('Open in Maps',
                              style: TextStyle(color: Colors.teal)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.teal),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Timings
                  _sectionTitle('Weekly Timings'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      timing,
                      style: const TextStyle(fontSize: 13, height: 1.8),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Services
                  _sectionTitle('Services'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: facility.services.map((s) {
                      return Chip(
                        label: Text(s),
                        backgroundColor: Colors.teal.shade50,
                        labelStyle: TextStyle(
                            color: Colors.teal.shade800, fontSize: 12),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Doctors
                  _sectionTitle('Doctors at this Facility'),
                  const SizedBox(height: 8),
                  if (doctorEntries.isEmpty)
                    const Text('No doctor information available.',
                        style: TextStyle(color: Colors.grey))
                  else
                    ...doctorEntries.map((entry) {
                      final doc = entry.key;
                      final df = entry.value;
                      final sp = specialities.firstWhere(
                          (s) => s.id == doc.specialityId,
                          orElse: () => specialities.first);
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: Colors.teal.shade50,
                          child: Text(
                            doc.gender == 'female' ? '👩‍⚕️' : '👨‍⚕️',
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                        title: Text(doc.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                '${sp.name} · ${doc.degrees.join(', ')}',
                                style: const TextStyle(fontSize: 12)),
                            Text(
                                todayTimingString(df.timings),
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600)),
                            if (df.fee != null)
                              Text('Fee: ₹${df.fee}',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.teal)),
                          ],
                        ),
                        isThreeLine: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DoctorDetailScreen(
                                doctor: doc,
                                doctorFacility: df,
                                facility: facility,
                              ),
                            ),
                          );
                        },
                        trailing:
                            const Icon(Icons.chevron_right, color: Colors.grey),
                      );
                    }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.teal),
        const SizedBox(width: 8),
        Expanded(
            child: Text(text, style: const TextStyle(fontSize: 14))),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }
}
