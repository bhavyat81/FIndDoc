import { Linking } from 'react-native';

export function makeCall(phoneNumber: string): void {
  Linking.openURL(`tel:${phoneNumber}`);
}
