import React from 'react';
import { View, Text, TouchableOpacity, StyleSheet } from 'react-native';
import { Speciality } from '../types';
import { theme } from '../constants/theme';

interface Props {
  speciality: Speciality;
  onPress: () => void;
}

export default function SpecialityCard({ speciality, onPress }: Props) {
  return (
    <TouchableOpacity style={styles.card} onPress={onPress} activeOpacity={0.85}>
      <Text style={styles.emoji}>{speciality.emoji}</Text>
      <Text style={styles.name} numberOfLines={2}>{speciality.displayName}</Text>
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  card: {
    backgroundColor: theme.colors.surface,
    borderRadius: theme.radius.md,
    padding: theme.spacing.md,
    marginRight: theme.spacing.sm,
    width: 90,
    alignItems: 'center',
    elevation: 2,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.1,
    shadowRadius: 2,
  },
  emoji: { fontSize: 28, marginBottom: theme.spacing.xs },
  name: { fontSize: theme.fontSize.xs, color: theme.colors.text, textAlign: 'center', fontWeight: '600' },
});
