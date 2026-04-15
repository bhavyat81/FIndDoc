import { Linking } from 'react-native';

export function openDirections(lat: number, lng: number): void {
  Linking.openURL(`https://www.google.com/maps/dir/?api=1&destination=${lat},${lng}`);
}
