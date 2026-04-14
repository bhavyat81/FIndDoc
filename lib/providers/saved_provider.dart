import 'package:flutter/foundation.dart';
import '../services/saved_service.dart';

class SavedProvider extends ChangeNotifier {
  final SavedService _service = SavedService();

  Set<String> _savedDoctorIds = {};
  Set<String> _savedFacilityIds = {};

  Set<String> get savedDoctorIds => _savedDoctorIds;
  Set<String> get savedFacilityIds => _savedFacilityIds;

  SavedProvider() {
    _load();
  }

  Future<void> _load() async {
    _savedDoctorIds = await _service.getSavedDoctorIds();
    _savedFacilityIds = await _service.getSavedFacilityIds();
    notifyListeners();
  }

  bool isDoctorSaved(String doctorId) => _savedDoctorIds.contains(doctorId);

  Future<void> toggleDoctor(String doctorId) async {
    await _service.toggleDoctor(doctorId);
    if (_savedDoctorIds.contains(doctorId)) {
      _savedDoctorIds.remove(doctorId);
    } else {
      _savedDoctorIds.add(doctorId);
    }
    notifyListeners();
  }

  bool isFacilitySaved(String facilityId) =>
      _savedFacilityIds.contains(facilityId);

  Future<void> toggleFacility(String facilityId) async {
    await _service.toggleFacility(facilityId);
    if (_savedFacilityIds.contains(facilityId)) {
      _savedFacilityIds.remove(facilityId);
    } else {
      _savedFacilityIds.add(facilityId);
    }
    notifyListeners();
  }
}
