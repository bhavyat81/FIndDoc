import 'package:flutter/material.dart';
import '../models/facility.dart';
import '../services/call_service.dart';
import '../services/maps_service.dart';
import '../services/timing_utils.dart';

class FacilityCard extends StatelessWidget {
  final Facility facility;
  final double? distanceKm;
  final VoidCallback? onViewDoctors;
  final bool showViewDoctors;

  const FacilityCard({
    super.key,
    required this.facility,
    this.distanceKm,
    this.onViewDoctors,
    this.showViewDoctors = true,
  });

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

  @override
  Widget build(BuildContext context) {
    final open = isOpenNow(facility.timings);
    final todayTime = todayTimingString(facility.timings);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name + rating row
            Row(
              children: [
                Expanded(
                  child: Text(
                    facility.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 2),
                    Text(
                      facility.rating.toStringAsFixed(1),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      ' (${facility.reviewCount})',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            // Type label
            Text(
              _typeLabel,
              style: TextStyle(color: Colors.teal.shade700, fontSize: 13),
            ),
            const SizedBox(height: 8),
            // Address + distance
            Row(
              children: [
                const Icon(Icons.location_on, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    facility.address,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
                if (distanceKm != null)
                  Text(
                    '${distanceKm!.toStringAsFixed(1)} km',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
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
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: open ? Colors.green.shade50 : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    open ? 'Open Now' : 'Closed',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: open ? Colors.green.shade700 : Colors.red.shade700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Action buttons
            Row(
              children: [
                _actionButton(
                  icon: Icons.call,
                  label: 'Call',
                  color: Colors.teal,
                  onTap: () => CallService.call(facility.phone),
                ),
                const SizedBox(width: 8),
                _actionButton(
                  icon: Icons.directions,
                  label: 'Directions',
                  color: Colors.blue,
                  onTap: () => MapsService.openDirections(
                      facility.latitude, facility.longitude),
                ),
                if (showViewDoctors && onViewDoctors != null) ...[
                  const SizedBox(width: 8),
                  _actionButton(
                    icon: Icons.people,
                    label: 'Doctors',
                    color: Colors.purple,
                    onTap: onViewDoctors!,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 16, color: color),
        label: Text(label,
            style: TextStyle(color: color, fontSize: 12)),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 8),
          side: BorderSide(color: color.withOpacity(0.5)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
