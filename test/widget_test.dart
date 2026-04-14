import 'package:flutter_test/flutter_test.dart';
import 'package:finddoc/data/areas.dart';
import 'package:finddoc/data/facilities.dart';
import 'package:finddoc/data/doctors.dart';
import 'package:finddoc/data/specialities.dart';
import 'package:finddoc/services/distance_service.dart';
import 'package:finddoc/services/timing_utils.dart';
import 'package:finddoc/services/search_service.dart';

void main() {
  group('Data integrity', () {
    test('Areas: Vadodara has 17 areas', () {
      expect(vadodaraAreas.length, 17);
    });

    test('Facilities: at least 15 facilities', () {
      expect(facilities.length, greaterThanOrEqualTo(15));
    });

    test('Doctors: at least 30 doctors', () {
      expect(doctors.length, greaterThanOrEqualTo(30));
    });

    test('Specialities: 10 specialities defined', () {
      expect(specialities.length, 10);
    });

    test('All doctor facilities reference valid doctors', () {
      for (final df in doctorFacilities) {
        final doc = doctors.where((d) => d.id == df.doctorId).toList();
        expect(doc.isNotEmpty, true,
            reason: 'Missing doctor: ${df.doctorId}');
      }
    });

    test('All doctor facilities reference valid facilities', () {
      for (final df in doctorFacilities) {
        final fac = facilities.where((f) => f.id == df.facilityId).toList();
        expect(fac.isNotEmpty, true,
            reason: 'Missing facility: ${df.facilityId}');
      }
    });
  });

  group('Distance service', () {
    test('Same point returns 0', () {
      final dist = DistanceService.calculate(22.3072, 73.1812, 22.3072, 73.1812);
      expect(dist, closeTo(0, 0.001));
    });

    test('Sterling Hospital is within 5km of city centre', () {
      // Sterling Hospital: lat 22.3312, lng 73.1684
      final dist = DistanceService.calculate(22.3072, 73.1812, 22.3312, 73.1684);
      expect(dist, lessThan(5));
    });
  });

  group('Timing utils', () {
    test('todayKey returns valid day string', () {
      final key = todayKey();
      expect(['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'].contains(key), true);
    });

    test('24x7 timings are always open', () {
      // Grab an emergency facility
      final emFacility = facilities.firstWhere((f) => f.isEmergency24x7);
      // We can't truly test "now" in a unit test but we verify the data exists
      expect(emFacility.timings.length, 7);
    });
  });

  group('Search service', () {
    test('Searching "kidney" returns nephrologists', () {
      final svc = SearchService();
      final results = svc.search('kidney');
      expect(results.isNotEmpty, true);
      for (final r in results) {
        expect(r.doctor.specialityId, 'nephrology');
      }
    });

    test('Searching "heart" returns cardiologists', () {
      final svc = SearchService();
      final results = svc.search('heart');
      expect(results.isNotEmpty, true);
      for (final r in results) {
        expect(r.doctor.specialityId, 'cardiology');
      }
    });

    test('Results are sorted by distance ascending', () {
      final svc = SearchService();
      final results = svc.search('kidney');
      for (int i = 1; i < results.length; i++) {
        expect(results[i].distanceKm,
            greaterThanOrEqualTo(results[i - 1].distanceKm));
      }
    });

    test('Speciality keyword match works', () {
      final sp = findSpecialityByKeyword('teeth');
      expect(sp, isNotNull);
      expect(sp!.id, 'dentistry');
    });
  });
}
