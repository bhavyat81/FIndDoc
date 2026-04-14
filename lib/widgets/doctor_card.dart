import 'package:flutter/material.dart';
import '../data/specialities.dart';
import '../models/doctor.dart';
import '../models/doctor_facility.dart';
import '../models/facility.dart';
import '../services/call_service.dart';
import '../services/maps_service.dart';
import '../services/timing_utils.dart';

class DoctorCard extends StatelessWidget {
  final Doctor doctor;
  final DoctorFacility doctorFacility;
  final Facility facility;
  final double? distanceKm;
  final bool isSaved;
  final VoidCallback? onSaveToggle;
  final VoidCallback? onTap;

  const DoctorCard({
    super.key,
    required this.doctor,
    required this.doctorFacility,
    required this.facility,
    this.distanceKm,
    this.isSaved = false,
    this.onSaveToggle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final speciality = specialities.firstWhere(
      (s) => s.id == doctor.specialityId,
      orElse: () => specialities.first,
    );
    final open = isOpenNow(doctorFacility.timings);
    final todayTime = todayTimingString(doctorFacility.timings);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name row
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.teal.shade100,
                    child: Text(
                      doctor.gender == 'female' ? '👩‍⚕️' : '👨‍⚕️',
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctor.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '${speciality.name} · ${speciality.displayName}',
                          style: TextStyle(
                            color: Colors.teal.shade700,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (onSaveToggle != null)
                    IconButton(
                      icon: Icon(
                        isSaved ? Icons.bookmark : Icons.bookmark_border,
                        color: isSaved ? Colors.teal : Colors.grey,
                      ),
                      onPressed: onSaveToggle,
                    ),
                ],
              ),
              const SizedBox(height: 8),
              // Degrees + experience
              Text(
                doctor.degrees.join(', '),
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
              ),
              Text(
                '${doctor.experienceYears} yrs experience  ·  ${doctor.languages.join(', ')}',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 8),
              // Facility
              Row(
                children: [
                  const Icon(Icons.local_hospital, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      facility.name,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                    ),
                  ),
                  if (distanceKm != null)
                    Text(
                      '${distanceKm!.toStringAsFixed(1)} km',
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              // Timing + open badge
              Row(
                children: [
                  const Icon(Icons.access_time, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    todayTime,
                    style:
                        TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color:
                          open ? Colors.green.shade50 : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      open ? 'Open Now' : 'Closed',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: open
                            ? Colors.green.shade700
                            : Colors.red.shade700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Actions
              Row(
                children: [
                  _actionBtn(
                    icon: Icons.call,
                    label: 'Call',
                    color: Colors.teal,
                    onTap: () => CallService.call(facility.phone),
                  ),
                  const SizedBox(width: 8),
                  _actionBtn(
                    icon: Icons.directions,
                    label: 'Directions',
                    color: Colors.blue,
                    onTap: () => MapsService.openDirections(
                        facility.latitude, facility.longitude),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionBtn({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 16, color: color),
        label: Text(label, style: TextStyle(color: color, fontSize: 12)),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 8),
          side: BorderSide(color: color.withOpacity(0.5)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
