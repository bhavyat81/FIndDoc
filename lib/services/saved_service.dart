import 'package:shared_preferences/shared_preferences.dart';

class SavedService {
  static const String _doctorKey = 'saved_doctors';
  static const String _facilityKey = 'saved_facilities';

  Future<Set<String>> getSavedDoctorIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_doctorKey)?.toSet() ?? {};
  }

  Future<void> toggleDoctor(String doctorId) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_doctorKey)?.toSet() ?? {};
    if (saved.contains(doctorId)) {
      saved.remove(doctorId);
    } else {
      saved.add(doctorId);
    }
    await prefs.setStringList(_doctorKey, saved.toList());
  }

  Future<bool> isDoctorSaved(String doctorId) async {
    final ids = await getSavedDoctorIds();
    return ids.contains(doctorId);
  }

  Future<Set<String>> getSavedFacilityIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_facilityKey)?.toSet() ?? {};
  }

  Future<void> toggleFacility(String facilityId) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_facilityKey)?.toSet() ?? {};
    if (saved.contains(facilityId)) {
      saved.remove(facilityId);
    } else {
      saved.add(facilityId);
    }
    await prefs.setStringList(_facilityKey, saved.toList());
  }

  Future<bool> isFacilitySaved(String facilityId) async {
    final ids = await getSavedFacilityIds();
    return ids.contains(facilityId);
  }
}
