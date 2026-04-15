import React from 'react';
import { View, Text, TouchableOpacity, StyleSheet } from 'react-native';
import { Area } from '../types';
import { facilities } from '../data/facilities';
import { theme } from '../constants/theme';

interface Props {
  area: Area;
  onPress: () => void;
}

export default function AreaCard({ area, onPress }: Props) {
  const count = facilities.filter(f => f.areaId === area.id).length;
  return (
    <TouchableOpacity style={styles.card} onPress={onPress} activeOpacity={0.85}>
      <Text style={styles.name}>{area.name}</Text>
      <Text style={styles.count}>{count} {count === 1 ? 'facility' : 'facilities'}</Text>
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  card: {
    backgroundColor: theme.colors.chip,
    borderRadius: theme.radius.md,
    padding: theme.spacing.md,
    margin: theme.spacing.xs,
    alignItems: 'center',
    justifyContent: 'center',
    minWidth: 100,
    elevation: 1,
  },
  name: { fontSize: theme.fontSize.sm, fontWeight: '700', color: theme.colors.primaryDark, textAlign: 'center' },
  count: { fontSize: theme.fontSize.xs, color: theme.colors.textSecondary, marginTop: 2 },
});
