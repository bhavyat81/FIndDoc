# FindDoc – Find the Right Doctor Near You in Vadodara 🏥

**FindDoc** is a cross-platform **Expo (React Native)** app that helps users in **Vadodara** find doctors, hospitals, clinics, and emergency services instantly — no build errors, no codesign issues.

> **Test on your iPhone in 30 seconds:** `npx expo start` → scan QR code with your camera 📱

---

## Features

- 🔍 **Search** by symptom, speciality, or doctor name (e.g. "kidney", "heart", "dentist")
- 🗺️ **Browse by Area** – 17 Vadodara localities (Alkapuri, Gotri, Manjalpur, Karelibaug, etc.)
- 🏥 **Area Detail** – Filter hospitals, clinics, and labs in each area
- 👨‍⚕️ **Doctor Profiles** – Degrees, experience, languages, consultation timings
- 📞 **Click-to-Call** – One tap to call the clinic
- 🗺️ **Google Maps Directions** – Opens navigation directly
- 🔖 **Save Doctors** – Bookmark your preferred doctors (persisted with AsyncStorage)
- 🚨 **Emergency Screen** – 24x7 hospitals + helplines (108, 100, 101)
- 🏠 **Profile Screen** – City & app info

---

## Quick Start

```bash
# 1. Install dependencies
npm install

# 2. Start Expo dev server
npx expo start

# 3. On your iPhone:
#    - Open the Camera app
#    - Scan the QR code shown in your terminal
#    - FindDoc opens instantly! ✅
```

**No Xcode, no codesign, no Android Studio required for testing.**

---

## Install on Physical Device

Install the **Expo Go** app from the App Store (iPhone) or Play Store (Android), then scan the QR code after running `npx expo start`.

---

## Build for Production

```bash
# Install EAS CLI
npm install -g eas-cli

# Login
eas login

# Build for iOS
eas build --platform ios

# Build for Android
eas build --platform android
```

---

## Project Structure

```
app/
├── _layout.tsx                  # Root layout (SavedContext provider)
├── (tabs)/
│   ├── _layout.tsx              # Bottom tab navigation
│   ├── index.tsx                # Home screen (search, areas, specialities)
│   ├── saved.tsx                # Saved doctors
│   └── profile.tsx             # Profile & app info
├── doctor/[id].tsx              # Doctor detail screen
├── facility/[id].tsx            # Facility detail screen
├── area/[id].tsx                # Area detail screen (filter by type)
├── search/[query].tsx           # Search results
└── emergency.tsx                # Emergency helplines & hospitals

components/
├── DoctorCard.tsx
├── FacilityCard.tsx
├── AreaCard.tsx
└── SpecialityCard.tsx

data/
├── doctors.ts                   # 33+ doctors + DoctorFacility mappings
├── facilities.ts                # 18+ hospitals/clinics/labs
├── areas.ts                     # 17 Vadodara areas
└── specialities.ts              # 10 specialities with keyword maps

services/
├── searchService.ts             # Keyword → speciality → doctor search
├── distanceService.ts           # Haversine formula
├── locationService.ts           # Mock location (Vadodara centre)
├── savedService.ts              # AsyncStorage persistence
├── callService.ts               # tel: scheme launcher
├── mapsService.ts               # Google Maps URL launcher
└── timingUtils.ts               # Open/closed status, timing display

contexts/
└── SavedContext.tsx             # React Context for bookmarks

constants/
└── theme.ts                     # Teal color theme + spacing/radius
```

---

## Tech Stack

| Technology | Purpose |
|---|---|
| **Expo (React Native)** | Cross-platform mobile framework |
| **TypeScript** | Type-safe JavaScript |
| **Expo Router** | File-based navigation |
| **AsyncStorage** | Local persistence for saved doctors |
| **React Native Linking** | Phone calls & Google Maps links |
| **React Context** | State management for saved doctors |

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
- [ ] Gujarati language support

---

## License

MIT License
