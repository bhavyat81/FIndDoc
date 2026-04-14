import '../models/speciality.dart';

final List<Speciality> specialities = [
  Speciality(
    id: 'nephrology',
    name: 'Nephrology',
    displayName: 'Kidney Specialist',
    keywords: ['kidney', 'nephro', 'renal', 'dialysis', 'ckd'],
    iconName: 'water_drop',
    emoji: '🫘',
  ),
  Speciality(
    id: 'cardiology',
    name: 'Cardiology',
    displayName: 'Heart Specialist',
    keywords: ['heart', 'cardiac', 'cardio', 'chest pain', 'bp', 'blood pressure', 'angina'],
    iconName: 'favorite',
    emoji: '❤️',
  ),
  Speciality(
    id: 'pediatrics',
    name: 'Pediatrics',
    displayName: 'Child Specialist',
    keywords: ['child', 'baby', 'kids', 'pediatric', 'infant', 'newborn', 'toddler'],
    iconName: 'child_care',
    emoji: '👶',
  ),
  Speciality(
    id: 'dentistry',
    name: 'Dentistry',
    displayName: 'Dental',
    keywords: ['teeth', 'dental', 'tooth', 'dentist', 'gum', 'cavity', 'braces'],
    iconName: 'sentiment_very_satisfied',
    emoji: '🦷',
  ),
  Speciality(
    id: 'orthopedics',
    name: 'Orthopedics',
    displayName: 'Bone & Joint',
    keywords: ['bone', 'fracture', 'joint', 'ortho', 'knee', 'spine', 'back pain', 'arthritis'],
    iconName: 'accessibility_new',
    emoji: '🦴',
  ),
  Speciality(
    id: 'ophthalmology',
    name: 'Ophthalmology',
    displayName: 'Eye Specialist',
    keywords: ['eye', 'vision', 'ophthalmology', 'cataract', 'glaucoma', 'retina', 'glasses'],
    iconName: 'visibility',
    emoji: '👁️',
  ),
  Speciality(
    id: 'dermatology',
    name: 'Dermatology',
    displayName: 'Skin Specialist',
    keywords: ['skin', 'acne', 'hair', 'derma', 'rash', 'eczema', 'allergy', 'psoriasis'],
    iconName: 'face',
    emoji: '🧴',
  ),
  Speciality(
    id: 'neurology',
    name: 'Neurology',
    displayName: 'Brain & Nerve',
    keywords: ['brain', 'headache', 'nerve', 'neuro', 'migraine', 'epilepsy', 'paralysis', 'stroke'],
    iconName: 'psychology',
    emoji: '🧠',
  ),
  Speciality(
    id: 'general',
    name: 'General Physician',
    displayName: 'General Physician',
    keywords: ['fever', 'cold', 'cough', 'flu', 'general', 'physician', 'fatigue', 'weakness', 'infection'],
    iconName: 'local_hospital',
    emoji: '🩺',
  ),
  Speciality(
    id: 'gynecology',
    name: 'Gynecology',
    displayName: 'Women Health',
    keywords: ['pregnancy', 'women', 'gynec', 'gynecology', 'period', 'menstrual', 'obstetrics', 'delivery'],
    iconName: 'pregnant_woman',
    emoji: '👩‍⚕️',
  ),
];

Speciality? findSpecialityByKeyword(String query) {
  final q = query.toLowerCase().trim();
  for (final sp in specialities) {
    for (final kw in sp.keywords) {
      if (q.contains(kw) || kw.contains(q)) {
        return sp;
      }
    }
  }
  return null;
}
