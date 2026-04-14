import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/specialities.dart';
import '../models/doctor.dart';
import '../models/doctor_facility.dart';
import '../models/facility.dart';
import '../providers/saved_provider.dart';
import '../services/call_service.dart';
import '../services/maps_service.dart';
import '../services/timing_utils.dart';

class DoctorDetailScreen extends StatelessWidget {
  final Doctor doctor;
  final DoctorFacility doctorFacility;
  final Facility facility;

  const DoctorDetailScreen({
    super.key,
    required this.doctor,
    required this.doctorFacility,
    required this.facility,
  });

  @override
  Widget build(BuildContext context) {
    final sp = specialities.firstWhere(
      (s) => s.id == doctor.specialityId,
      orElse: () => specialities.first,
    );
    final timing = weeklyTimingSummary(doctorFacility.timings);

    return Scaffold(
      appBar: AppBar(
        title: Text(doctor.name),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          Consumer<SavedProvider>(
            builder: (context, savedProvider, _) {
              final saved = savedProvider.isDoctorSaved(doctor.id);
              return IconButton(
                icon: Icon(
                  saved ? Icons.bookmark : Icons.bookmark_border,
                  color: Colors.white,
                ),
                onPressed: () => savedProvider.toggleDoctor(doctor.id),
                tooltip: saved ? 'Unsave' : 'Save Doctor',
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              color: Colors.teal.shade700,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    child: Text(
                      doctor.gender == 'female' ? '👩‍⚕️' : '👨‍⚕️',
                      style: const TextStyle(fontSize: 42),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    doctor.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${sp.name} · ${sp.displayName}',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    doctor.degrees.join(', '),
                    style: const TextStyle(color: Colors.white60, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Info chips
                  Row(
                    children: [
                      _infoChip(
                          '${doctor.experienceYears} yrs', Icons.workspace_premium),
                      const SizedBox(width: 8),
                      _infoChip(
                          doctor.languages.join(', '), Icons.language),
                      const SizedBox(width: 8),
                      _infoChip(
                          doctor.gender == 'female' ? 'Female' : 'Male',
                          Icons.person),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Facility
                  _sectionTitle('Clinic / Hospital'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.teal.shade100),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(facility.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(facility.address,
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade700)),
                            ),
                          ],
                        ),
                        if (doctorFacility.fee != null) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.currency_rupee,
                                  size: 14, color: Colors.teal),
                              Text('Consultation Fee: ₹${doctorFacility.fee}',
                                  style: const TextStyle(
                                      color: Colors.teal,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Timings
                  _sectionTitle('Consultation Timings'),
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

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => CallService.call(facility.phone),
                          icon: const Icon(Icons.call),
                          label: const Text('Call Clinic'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
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
                          icon: const Icon(Icons.directions,
                              color: Colors.teal),
                          label: const Text('Directions',
                              style: TextStyle(color: Colors.teal)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.teal),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Save button
                  Consumer<SavedProvider>(
                    builder: (context, savedProvider, _) {
                      final saved = savedProvider.isDoctorSaved(doctor.id);
                      return SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () =>
                              savedProvider.toggleDoctor(doctor.id),
                          icon: Icon(
                              saved ? Icons.bookmark : Icons.bookmark_border,
                              color: Colors.teal),
                          label: Text(
                            saved ? 'Saved' : 'Save Doctor',
                            style: const TextStyle(color: Colors.teal),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.teal),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoChip(String label, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.teal.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: Colors.teal),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                style: const TextStyle(fontSize: 11),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }
}
