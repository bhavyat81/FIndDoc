import { doctors, doctorFacilities } from '../data/doctors';
import { facilities } from '../data/facilities';
import { specialities, findSpecialityByKeyword } from '../data/specialities';
import { SearchResult, Speciality } from '../types';
import { calculateDistance } from './distanceService';
import { USER_LOCATION } from './locationService';

export function search(
  query: string,
  userLat = USER_LOCATION.lat,
  userLng = USER_LOCATION.lng,
): { results: SearchResult[]; matchedSpeciality?: Speciality } {
  const matchedSpeciality = findSpecialityByKeyword(query);
  const q = query.toLowerCase();

  const results: SearchResult[] = [];

  for (const df of doctorFacilities) {
    const doctor = doctors.find(d => d.id === df.doctorId);
    if (!doctor) continue;

    if (matchedSpeciality) {
      if (doctor.specialityId !== matchedSpeciality.id) continue;
    } else {
      const spec = specialities.find(s => s.id === doctor.specialityId);
      const nameMatch = doctor.name.toLowerCase().includes(q);
      const specMatch = spec
        ? spec.name.toLowerCase().includes(q) || spec.displayName.toLowerCase().includes(q)
        : false;
      if (!nameMatch && !specMatch) continue;
    }

    const facility = facilities.find(f => f.id === df.facilityId);
    if (!facility) continue;

    const distanceKm = calculateDistance(userLat, userLng, facility.latitude, facility.longitude);

    results.push({ doctor, doctorFacility: df, facility, distanceKm });
  }

  results.sort((a, b) => a.distanceKm - b.distanceKm);
  return { results, matchedSpeciality };
}
