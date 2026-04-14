import '../data/doctors.dart' as doctor_data;
import '../data/facilities.dart' as facility_data;
import '../data/specialities.dart';
import '../models/doctor.dart';
import '../models/doctor_facility.dart';
import '../models/facility.dart';
import '../models/speciality.dart';
import '../services/distance_service.dart';

class SearchResult {
  final Doctor doctor;
  final DoctorFacility doctorFacility;
  final Facility facility;
  final double distanceKm;

  SearchResult({
    required this.doctor,
    required this.doctorFacility,
    required this.facility,
    required this.distanceKm,
  });
}

class SearchService {
  Speciality? matchedSpeciality;

  List<SearchResult> search(
    String query, {
    double userLat = 22.3072,
    double userLng = 73.1812,
  }) {
    matchedSpeciality = findSpecialityByKeyword(query);

    final List<SearchResult> results = [];

    for (final df in doctor_data.doctorFacilities) {
      final doctor = doctor_data.doctors.firstWhere(
        (d) => d.id == df.doctorId,
        orElse: () => throw StateError('Doctor not found: ${df.doctorId}'),
      );

      // Filter by speciality if matched
      if (matchedSpeciality != null &&
          doctor.specialityId != matchedSpeciality!.id) {
        continue;
      }

      // Also try name/speciality match if no keyword speciality matched
      if (matchedSpeciality == null) {
        final q = query.toLowerCase();
        final spec = specialities.firstWhere(
          (s) => s.id == doctor.specialityId,
          orElse: () => specialities.first,
        );
        final nameMatch = doctor.name.toLowerCase().contains(q);
        final specMatch = spec.name.toLowerCase().contains(q) ||
            spec.displayName.toLowerCase().contains(q);
        if (!nameMatch && !specMatch) continue;
      }

      final facility = facility_data.facilities.firstWhere(
        (f) => f.id == df.facilityId,
        orElse: () => throw StateError('Facility not found: ${df.facilityId}'),
      );

      final distanceKm = DistanceService.calculate(
        userLat,
        userLng,
        facility.latitude,
        facility.longitude,
      );

      results.add(SearchResult(
        doctor: doctor,
        doctorFacility: df,
        facility: facility,
        distanceKm: distanceKm,
      ));
    }

    results.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    return results;
  }
}
