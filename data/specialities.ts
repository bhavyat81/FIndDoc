import { Speciality } from '../types';

export const specialities: Speciality[] = [
  {
    id: 'nephrology',
    name: 'Nephrology',
    displayName: 'Kidney Specialist',
    keywords: ['kidney', 'nephro', 'renal', 'dialysis', 'ckd'],
    emoji: '🫘',
  },
  {
    id: 'cardiology',
    name: 'Cardiology',
    displayName: 'Heart Specialist',
    keywords: ['heart', 'cardiac', 'cardio', 'chest pain', 'bp', 'blood pressure', 'angina'],
    emoji: '❤️',
  },
  {
    id: 'pediatrics',
    name: 'Pediatrics',
    displayName: 'Child Specialist',
    keywords: ['child', 'baby', 'kids', 'pediatric', 'infant', 'newborn', 'toddler'],
    emoji: '👶',
  },
  {
    id: 'dentistry',
    name: 'Dentistry',
    displayName: 'Dental',
    keywords: ['teeth', 'dental', 'tooth', 'dentist', 'gum', 'cavity', 'braces'],
    emoji: '🦷',
  },
  {
    id: 'orthopedics',
    name: 'Orthopedics',
    displayName: 'Bone & Joint',
    keywords: ['bone', 'fracture', 'joint', 'ortho', 'knee', 'spine', 'back pain', 'arthritis'],
    emoji: '🦴',
  },
  {
    id: 'ophthalmology',
    name: 'Ophthalmology',
    displayName: 'Eye Specialist',
    keywords: ['eye', 'vision', 'ophthalmology', 'cataract', 'glaucoma', 'retina', 'glasses'],
    emoji: '👁️',
  },
  {
    id: 'dermatology',
    name: 'Dermatology',
    displayName: 'Skin Specialist',
    keywords: ['skin', 'acne', 'hair', 'derma', 'rash', 'eczema', 'allergy', 'psoriasis'],
    emoji: '🧴',
  },
  {
    id: 'neurology',
    name: 'Neurology',
    displayName: 'Brain & Nerve',
    keywords: ['brain', 'headache', 'nerve', 'neuro', 'migraine', 'epilepsy', 'paralysis', 'stroke'],
    emoji: '🧠',
  },
  {
    id: 'general',
    name: 'General Physician',
    displayName: 'General Physician',
    keywords: ['fever', 'cold', 'cough', 'flu', 'general', 'physician', 'fatigue', 'weakness', 'infection'],
    emoji: '🩺',
  },
  {
    id: 'gynecology',
    name: 'Gynecology',
    displayName: 'Women Health',
    keywords: ['pregnancy', 'women', 'gynec', 'gynecology', 'period', 'menstrual', 'obstetrics', 'delivery'],
    emoji: '👩‍⚕️',
  },
];

export function findSpecialityByKeyword(query: string): Speciality | undefined {
  const q = query.toLowerCase().trim();
  for (const sp of specialities) {
    for (const kw of sp.keywords) {
      if (q.includes(kw) || kw.includes(q)) {
        return sp;
      }
    }
  }
  return undefined;
}
