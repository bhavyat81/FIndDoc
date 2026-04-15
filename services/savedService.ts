import AsyncStorage from '@react-native-async-storage/async-storage';

const SAVED_DOCTORS_KEY = 'saved_doctors';

export async function getSavedDoctorIds(): Promise<string[]> {
  try {
    const json = await AsyncStorage.getItem(SAVED_DOCTORS_KEY);
    return json ? JSON.parse(json) : [];
  } catch {
    return [];
  }
}

export async function saveDoctorId(id: string): Promise<void> {
  const ids = await getSavedDoctorIds();
  if (!ids.includes(id)) {
    await AsyncStorage.setItem(SAVED_DOCTORS_KEY, JSON.stringify([...ids, id]));
  }
}

export async function removeDoctorId(id: string): Promise<void> {
  const ids = await getSavedDoctorIds();
  await AsyncStorage.setItem(
    SAVED_DOCTORS_KEY,
    JSON.stringify(ids.filter(i => i !== id)),
  );
}
