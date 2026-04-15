export interface TimeSlot {
  from: string;
  to: string;
}

export type Timings = Record<string, TimeSlot[]>;

export interface Doctor {
  id: string;
  name: string;
  specialityId: string;
  degrees: string[];
  experienceYears: number;
  languages: string[];
  gender: 'male' | 'female';
}

export interface Facility {
  id: string;
  name: string;
  type: 'hospital' | 'clinic' | 'lab';
  areaId: string;
  address: string;
  latitude: number;
  longitude: number;
  phone: string;
  timings: Timings;
  rating: number;
  reviewCount: number;
  services: string[];
  isEmergency24x7: boolean;
}

export interface DoctorFacility {
  doctorId: string;
  facilityId: string;
  timings: Timings;
  fee?: number;
}

export interface Area {
  id: string;
  name: string;
  cityId: string;
}

export interface Speciality {
  id: string;
  name: string;
  displayName: string;
  keywords: string[];
  emoji: string;
}

export interface SearchResult {
  doctor: Doctor;
  doctorFacility: DoctorFacility;
  facility: Facility;
  distanceKm: number;
}
