import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/doctors.dart' as doctor_data;
import '../data/facilities.dart' as facility_data;
import '../models/doctor.dart';
import '../models/doctor_facility.dart';
import '../models/facility.dart';
import '../providers/saved_provider.dart';
import '../widgets/doctor_card.dart';
import 'doctor_detail_screen.dart';

class _SavedEntry {
  final Doctor doc;
  final DoctorFacility df;
  final Facility facility;
  _SavedEntry({required this.doc, required this.df, required this.facility});
}

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Doctors'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Consumer<SavedProvider>(
        builder: (context, savedProvider, _) {
          final savedIds = savedProvider.savedDoctorIds;

          if (savedIds.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.bookmark_border,
                      size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'No saved doctors yet.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Bookmark doctors to find them here quickly.',
                    style: TextStyle(
                        fontSize: 13, color: Colors.grey.shade400),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          final List<_SavedEntry> entries = [];
          for (final doctorId in savedIds) {
            try {
              final doc =
                  doctor_data.doctors.firstWhere((d) => d.id == doctorId);
              final df = doctor_data.doctorFacilities
                  .firstWhere((df) => df.doctorId == doctorId);
              final fac = facility_data.facilities
                  .firstWhere((f) => f.id == df.facilityId);
              entries.add(_SavedEntry(doc: doc, df: df, facility: fac));
            } catch (_) {
              // Skip if data not found
            }
          }

          if (entries.isEmpty) {
            return const Center(child: Text('No valid saved doctors.'));
          }

          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final e = entries[index];
              return DoctorCard(
                doctor: e.doc,
                doctorFacility: e.df,
                facility: e.facility,
                isSaved: true,
                onSaveToggle: () => savedProvider.toggleDoctor(e.doc.id),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DoctorDetailScreen(
                        doctor: e.doc,
                        doctorFacility: e.df,
                        facility: e.facility,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
