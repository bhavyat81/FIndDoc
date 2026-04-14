class Doctor {
  final String id;
  final String name;
  final String specialityId;
  final List<String> degrees;
  final int experienceYears;
  final List<String> languages;
  final String gender; // 'male', 'female'

  const Doctor({
    required this.id,
    required this.name,
    required this.specialityId,
    required this.degrees,
    required this.experienceYears,
    required this.languages,
    required this.gender,
  });
}
