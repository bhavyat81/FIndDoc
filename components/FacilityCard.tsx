import React from 'react';
import { View, Text, TouchableOpacity, StyleSheet } from 'react-native';
import { Facility } from '../types';
import { theme } from '../constants/theme';
import { isOpenNow } from '../services/timingUtils';

interface Props {
  facility: Facility;
  distanceKm?: number;
  onPress: () => void;
}

const TYPE_EMOJI: Record<string, string> = {
  hospital: '🏥',
  clinic: '🏨',
  lab: '🔬',
};

export default function FacilityCard({ facility, distanceKm, onPress }: Props) {
  const open = isOpenNow(facility.timings);
  const emoji = TYPE_EMOJI[facility.type] ?? '🏥';

  return (
    <TouchableOpacity style={styles.card} onPress={onPress} activeOpacity={0.85}>
      <View style={styles.header}>
        <Text style={styles.emoji}>{emoji}</Text>
        <View style={styles.info}>
          <Text style={styles.name} numberOfLines={2}>{facility.name}</Text>
          <Text style={styles.type}>{facility.type.charAt(0).toUpperCase() + facility.type.slice(1)}</Text>
        </View>
        <View style={styles.right}>
          <View style={styles.ratingRow}>
            <Text style={styles.star}>⭐</Text>
            <Text style={styles.rating}>{facility.rating.toFixed(1)}</Text>
          </View>
          {facility.isEmergency24x7 && (
            <View style={styles.emergencyBadge}>
              <Text style={styles.emergencyText}>24x7</Text>
            </View>
          )}
        </View>
      </View>
      <Text style={styles.address} numberOfLines={1}>📍 {facility.address}</Text>
      <View style={styles.metaRow}>
        {distanceKm !== undefined && (
          <Text style={styles.meta}>{distanceKm.toFixed(1)} km</Text>
        )}
        <View style={[styles.badge, open ? styles.openBadge : styles.closedBadge]}>
          <Text style={[styles.badgeText, open ? styles.openText : styles.closedText]}>
            {open ? 'Open Now' : 'Closed'}
          </Text>
        </View>
      </View>
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  card: {
    backgroundColor: theme.colors.surface,
    borderRadius: theme.radius.md,
    padding: theme.spacing.md,
    marginHorizontal: theme.spacing.lg,
    marginVertical: theme.spacing.xs,
    elevation: 2,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.12,
    shadowRadius: 3,
  },
  header: { flexDirection: 'row', alignItems: 'flex-start' },
  emoji: { fontSize: 32, marginRight: theme.spacing.sm },
  info: { flex: 1 },
  name: { fontSize: theme.fontSize.md, fontWeight: '700', color: theme.colors.text },
  type: { fontSize: theme.fontSize.xs, color: theme.colors.textSecondary, marginTop: 2 },
  right: { alignItems: 'flex-end', gap: 4 },
  ratingRow: { flexDirection: 'row', alignItems: 'center' },
  star: { fontSize: 12 },
  rating: { fontSize: theme.fontSize.sm, fontWeight: '600', color: theme.colors.text, marginLeft: 2 },
  emergencyBadge: { backgroundColor: theme.colors.emergency, borderRadius: 4, paddingHorizontal: 6, paddingVertical: 2 },
  emergencyText: { color: '#fff', fontSize: theme.fontSize.xs, fontWeight: '700' },
  address: { fontSize: theme.fontSize.xs, color: theme.colors.textSecondary, marginTop: theme.spacing.sm },
  metaRow: { flexDirection: 'row', alignItems: 'center', marginTop: theme.spacing.sm, gap: 8 },
  meta: { fontSize: theme.fontSize.xs, color: theme.colors.textSecondary },
  badge: { paddingHorizontal: 8, paddingVertical: 2, borderRadius: theme.radius.full },
  openBadge: { backgroundColor: '#e8f5e9' },
  closedBadge: { backgroundColor: '#ffebee' },
  badgeText: { fontSize: theme.fontSize.xs, fontWeight: '600' },
  openText: { color: theme.colors.success },
  closedText: { color: theme.colors.error },
});
