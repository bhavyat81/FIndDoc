import 'time_slot.dart';

class DoctorFacility {
  final String doctorId;
  final String facilityId;
  final Map<String, List<TimeSlot>> timings;
  final int? fee;

  const DoctorFacility({
    required this.doctorId,
    required this.facilityId,
    required this.timings,
    this.fee,
  });
}
