import 'time_slot.dart';

class Facility {
  final String id;
  final String name;
  final String type; // 'hospital', 'clinic', 'lab'
  final String areaId;
  final String address;
  final double latitude;
  final double longitude;
  final String phone;
  final Map<String, List<TimeSlot>> timings;
  final double rating;
  final int reviewCount;
  final List<String> services;
  final bool isEmergency24x7;

  const Facility({
    required this.id,
    required this.name,
    required this.type,
    required this.areaId,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.phone,
    required this.timings,
    required this.rating,
    required this.reviewCount,
    required this.services,
    this.isEmergency24x7 = false,
  });
}
