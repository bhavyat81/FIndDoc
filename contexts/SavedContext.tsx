import React, { createContext, useContext, useEffect, useState } from 'react';
import { getSavedDoctorIds, saveDoctorId, removeDoctorId } from '../services/savedService';

interface SavedContextType {
  savedIds: string[];
  isDoctorSaved: (id: string) => boolean;
  toggleDoctor: (id: string) => Promise<void>;
}

const SavedContext = createContext<SavedContextType>({
  savedIds: [],
  isDoctorSaved: () => false,
  toggleDoctor: async () => {},
});

export function SavedProvider({ children }: { children: React.ReactNode }) {
  const [savedIds, setSavedIds] = useState<string[]>([]);

  useEffect(() => {
    getSavedDoctorIds().then(setSavedIds);
  }, []);

  const isDoctorSaved = (id: string) => savedIds.includes(id);

  const toggleDoctor = async (id: string) => {
    if (isDoctorSaved(id)) {
      await removeDoctorId(id);
      setSavedIds(prev => prev.filter(i => i !== id));
    } else {
      await saveDoctorId(id);
      setSavedIds(prev => [...prev, id]);
    }
  };

  return (
    <SavedContext.Provider value={{ savedIds, isDoctorSaved, toggleDoctor }}>
      {children}
    </SavedContext.Provider>
  );
}

export function useSaved() {
  return useContext(SavedContext);
}
