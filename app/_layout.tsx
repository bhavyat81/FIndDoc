import { Stack } from 'expo-router';
import { SavedProvider } from '../contexts/SavedContext';

export default function RootLayout() {
  return (
    <SavedProvider>
      <Stack screenOptions={{ headerShown: false }} />
    </SavedProvider>
  );
}
