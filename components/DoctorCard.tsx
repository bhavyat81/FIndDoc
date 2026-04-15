import React from 'react';
import { View, Text, TouchableOpacity, StyleSheet } from 'react-native';
import { Doctor, DoctorFacility, Facility } from '../types';
import { specialities } from '../data/specialities';
import { theme } from '../constants/theme';
import { todayTimingString, isOpenNow } from '../services/timingUtils';
import { useSaved } from '../contexts/SavedContext';

interface Props {
  doctor: Doctor;
  doctorFacility: DoctorFacility;
  facility: Facility;
  distanceKm?: number;
  onPress: () => void;
}

export default function DoctorCard({ doctor, doctorFacility, facility, distanceKm, onPress }: Props) {
  const sp = specialities.find(s => s.id === doctor.specialityId);
  const open = isOpenNow(doctorFacility.timings);
  const timing = todayTimingString(doctorFacility.timings);
  const { isDoctorSaved } = useSaved();
  const saved = isDoctorSaved(doctor.id);

  return (
    <TouchableOpacity style={styles.card} onPress={onPress} activeOpacity={0.85}>
      <View style={styles.row}>
        <View style={styles.avatar}>
          <Text style={styles.avatarEmoji}>
            {doctor.gender === 'female' ? '👩‍⚕️' : '👨‍⚕️'}
          </Text>
        </View>
        <View style={styles.info}>
          <View style={styles.nameRow}>
            <Text style={styles.name} numberOfLines={1}>{doctor.name}</Text>
            {saved && <Text style={styles.savedIcon}>🔖</Text>}
          </View>
          <Text style={styles.speciality}>
            {sp ? `${sp.emoji} ${sp.displayName}` : doctor.specialityId}
          </Text>
          <Text style={styles.degrees} numberOfLines={1}>
            {doctor.degrees.join(', ')}
          </Text>
          <Text style={styles.facility} numberOfLines={1}>🏥 {facility.name}</Text>
          <View style={styles.metaRow}>
            {distanceKm !== undefined && (
              <Text style={styles.meta}>📍 {distanceKm.toFixed(1)} km</Text>
            )}
            <View style={[styles.badge, open ? styles.openBadge : styles.closedBadge]}>
              <Text style={[styles.badgeText, open ? styles.openText : styles.closedText]}>
                {open ? 'Open' : 'Closed'}
              </Text>
            </View>
            {doctorFacility.fee && (
              <Text style={styles.meta}>₹{doctorFacility.fee}</Text>
            )}
          </View>
          <Text style={styles.timing} numberOfLines={1}>🕒 {timing}</Text>
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
  row: { flexDirection: 'row' },
  avatar: {
    width: 56,
    height: 56,
    borderRadius: 28,
    backgroundColor: theme.colors.chip,
    alignItems: 'center',
    justifyContent: 'center',
    marginRight: theme.spacing.md,
  },
  avatarEmoji: { fontSize: 28 },
  info: { flex: 1 },
  nameRow: { flexDirection: 'row', alignItems: 'center' },
  name: { fontSize: theme.fontSize.md, fontWeight: '700', color: theme.colors.text, flex: 1 },
  savedIcon: { fontSize: 14, marginLeft: 4 },
  speciality: { fontSize: theme.fontSize.sm, color: theme.colors.primary, marginTop: 2 },
  degrees: { fontSize: theme.fontSize.xs, color: theme.colors.textSecondary, marginTop: 2 },
  facility: { fontSize: theme.fontSize.xs, color: theme.colors.textSecondary, marginTop: 4 },
  metaRow: { flexDirection: 'row', alignItems: 'center', marginTop: 6, gap: 8, flexWrap: 'wrap' },
  meta: { fontSize: theme.fontSize.xs, color: theme.colors.textSecondary },
  badge: { paddingHorizontal: 8, paddingVertical: 2, borderRadius: theme.radius.full },
  openBadge: { backgroundColor: '#e8f5e9' },
  closedBadge: { backgroundColor: '#ffebee' },
  badgeText: { fontSize: theme.fontSize.xs, fontWeight: '600' },
  openText: { color: theme.colors.success },
  closedText: { color: theme.colors.error },
  timing: { fontSize: theme.fontSize.xs, color: theme.colors.textSecondary, marginTop: 4 },
});
