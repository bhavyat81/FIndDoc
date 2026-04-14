# FindDoc – Find the Right Doctor Near You in Vadodara 🏥

**FindDoc** is a cross-platform Flutter application (Android + iOS) that helps users in **Vadodara** find doctors, hospitals, clinics, and emergency services quickly.

---

## Features

- 🔍 **Search** by symptom, speciality, or doctor name (e.g. "kidney", "heart", "dentist")
- 🗺️ **Browse by Area** – 17 Vadodara localities (Alkapuri, Gotri, Manjalpur, Karelibaug, etc.)
- 🏥 **Area Detail** – Filter hospitals, clinics, and labs in each area
- 👨‍⚕️ **Doctor Profiles** – Degrees, experience, languages, consultation timings
- 📞 **Click-to-Call** – One tap to call the clinic
- 🗺️ **Google Maps Directions** – Opens navigation directly
- 🔖 **Save Doctors** – Bookmark your preferred doctors (persisted locally)
- 🚨 **Emergency Screen** – 24x7 hospitals + helplines (108, 100, 101)
- 🏠 **Profile Screen** – Language toggle, dark mode setting

---

## Screenshots

> _(Screenshots will be added after the first build)_

---

## How to Run

```bash
# Install dependencies
flutter pub get

# Run on connected device / emulator
flutter run

# Build APK (Android)
flutter build apk

# Build IPA (iOS)
flutter build ios
```

---

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── models/                      # Data models
│   ├── area.dart
│   ├── city.dart
│   ├── doctor.dart
│   ├── doctor_facility.dart
│   ├── facility.dart
│   ├── speciality.dart
│   └── time_slot.dart
├── data/                        # Mock data for Vadodara
│   ├── areas.dart               # 17 Vadodara areas
│   ├── doctors.dart             # 33+ doctors with DoctorFacility mappings
│   ├── facilities.dart          # 18+ hospitals/clinics/labs
│   └── specialities.dart       # 10 specialities with keyword maps
├── screens/                     # All app screens
│   ├── home_screen.dart
│   ├── area_detail_screen.dart
│   ├── facility_detail_screen.dart
│   ├── doctor_detail_screen.dart
│   ├── search_results_screen.dart
│   ├── saved_screen.dart
│   ├── profile_screen.dart
│   └── emergency_screen.dart
├── providers/
│   └── saved_provider.dart      # Provider for saved doctors state
├── services/
│   ├── search_service.dart      # Keyword → speciality → doctor search
│   ├── location_service.dart    # Mock location (Vadodara centre)
│   ├── maps_service.dart        # Google Maps URL launcher
│   ├── call_service.dart        # tel: scheme launcher
│   ├── distance_service.dart    # Haversine distance calculation
│   ├── saved_service.dart       # SharedPreferences persistence
│   └── timing_utils.dart        # Open/closed status, timing display
└── widgets/
    ├── facility_card.dart
    ├── doctor_card.dart
    ├── area_card.dart
    └── speciality_card.dart
```

---

## Tech Stack

| Technology | Purpose |
|---|---|
| **Flutter** | Cross-platform UI framework |
| **Dart** | Programming language |
| **Provider** | State management |
| **url_launcher** | Phone calls & Google Maps links |
| **shared_preferences** | Local persistence for saved doctors |

---

## Mock Data Highlights

- **18 facilities** across all 17 Vadodara areas including:
  - Sterling Multispeciality Hospital (Gotri)
  - Baroda Heart Institute (Alkapuri)
  - Bankers Heart Institute (Race Course)
  - Kiran Multispeciality Hospital (Karelibaug)
  - Dhiraj Hospital / SBKS (Waghodia Road)
  - Sunshine Global Hospitals (Old Padra Road)
  - Sir Sayajirao General Hospital (Sayajigunj)
  - And many more…

- **33+ doctors** across 10 specialities with Indian names, degrees, languages

- **10 specialities** with keyword mapping:
  - "kidney" → Nephrology, "heart" → Cardiology, "child/baby" → Pediatrics
  - "teeth" → Dentistry, "bone/fracture" → Orthopedics, "eye" → Ophthalmology
  - "skin/acne" → Dermatology, "brain/headache" → Neurology
  - "fever/cold" → General Physician, "pregnancy" → Gynecology

---

## Future Roadmap

- [ ] Real GPS location integration
- [ ] Backend API (Node.js / Firebase)
- [ ] Online appointment booking
- [ ] Multi-city support (Surat, Ahmedabad, …)
- [ ] Patient reviews & ratings
- [ ] Online / telemedicine consultations
- [ ] Pharmacy & blood bank locator
- [ ] Gujarati language support

---

## License

MIT License
