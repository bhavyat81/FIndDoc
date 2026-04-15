import React from 'react';
import {
  View, Text, ScrollView, TouchableOpacity, StyleSheet,
  SafeAreaView, Alert,
} from 'react-native';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { doctors, doctorFacilities } from '../../data/doctors';
import { facilities } from '../../data/facilities';
import { specialities } from '../../data/specialities';
import { theme } from '../../constants/theme';
import { weeklyTimingSummary, isOpenNow } from '../../services/timingUtils';
import { makeCall } from '../../services/callService';
import { openDirections } from '../../services/mapsService';
import { useSaved } from '../../contexts/SavedContext';

export default function DoctorDetailScreen() {
  const { id, facilityId } = useLocalSearchParams<{ id: string; facilityId: string }>();
  const router = useRouter();
  const { isDoctorSaved, toggleDoctor } = useSaved();

  const doctor = doctors.find((d) => d.id === id);
  const df = doctorFacilities.find((df) => df.doctorId === id && (facilityId ? df.facilityId === facilityId : true));
  const facility = facilities.find((f) => f.id === (facilityId || df?.facilityId));
  const sp = specialities.find((s) => s.id === doctor?.specialityId);

  if (!doctor || !df || !facility) {
    return (
      <SafeAreaView style={styles.safe}>
        <View style={styles.header}>
          <TouchableOpacity onPress={() => router.back()} style={styles.backBtn}>
            <Text style={styles.backText}>‹ Back</Text>
          </TouchableOpacity>
        </View>
        <View style={styles.center}>
          <Text>Doctor not found</Text>
        </View>
      </SafeAreaView>
    );
  }

  const saved = isDoctorSaved(doctor.id);
  const timing = weeklyTimingSummary(df.timings);
  const open = isOpenNow(df.timings);

  return (
    <SafeAreaView style={styles.safe}>
      <View style={styles.header}>
        <TouchableOpacity onPress={() => router.back()} style={styles.backBtn}>
          <Text style={styles.backText}>‹ Back</Text>
        </TouchableOpacity>
        <Text style={styles.headerTitle} numberOfLines={1}>{doctor.name}</Text>
        <TouchableOpacity onPress={() => toggleDoctor(doctor.id)} style={styles.saveBtn}>
          <Text style={styles.saveBtnText}>{saved ? '🔖' : '🏷️'}</Text>
        </TouchableOpacity>
      </View>

      <ScrollView style={styles.scroll} showsVerticalScrollIndicator={false}>
        {/* Hero */}
        <View style={styles.hero}>
          <Text style={styles.heroEmoji}>
            {doctor.gender === 'female' ? '👩‍⚕️' : '👨‍⚕️'}
          </Text>
          <Text style={styles.heroName}>{doctor.name}</Text>
          {sp && <Text style={styles.heroSpec}>{sp.emoji} {sp.name} · {sp.displayName}</Text>}
          <Text style={styles.heroDegrees}>{doctor.degrees.join(', ')}</Text>
        </View>

        <View style={styles.content}>
          {/* Info chips */}
          <View style={styles.chipRow}>
            <Chip icon="🏆" label={`${doctor.experienceYears} yrs exp`} />
            <Chip icon="🌐" label={doctor.languages.join(', ')} />
            <Chip icon="👤" label={doctor.gender === 'female' ? 'Female' : 'Male'} />
          </View>

          {/* Availability badge */}
          <View style={[styles.openBadge, open ? styles.openGreen : styles.openRed]}>
            <Text style={[styles.openText, open ? styles.openGreenText : styles.openRedText]}>
              {open ? '🟢 Open Now' : '🔴 Closed Now'}
            </Text>
          </View>

          {/* Clinic section */}
          <Text style={styles.sectionTitle}>Clinic / Hospital</Text>
          <View style={styles.facilityBox}>
            <Text style={styles.facilityName}>{facility.name}</Text>
            <Text style={styles.facilityAddr}>📍 {facility.address}</Text>
            {df.fee && <Text style={styles.fee}>💰 Consultation: ₹{df.fee}</Text>}
          </View>

          {/* Timings */}
          <Text style={styles.sectionTitle}>Doctor's Timings at this Clinic</Text>
          <View style={styles.timingBox}>
            <Text style={styles.timingText}>{timing}</Text>
          </View>

          {/* Action buttons */}
          <View style={styles.actionRow}>
            <TouchableOpacity
              style={[styles.actionBtn, styles.callBtn]}
              onPress={() => makeCall(facility.phone)}
            >
              <Text style={styles.actionBtnText}>📞 Call Clinic</Text>
            </TouchableOpacity>
            <TouchableOpacity
              style={[styles.actionBtn, styles.dirBtn]}
              onPress={() => openDirections(facility.latitude, facility.longitude)}
            >
              <Text style={[styles.actionBtnText, { color: theme.colors.primary }]}>🗺️ Directions</Text>
            </TouchableOpacity>
          </View>

          {/* Facility link */}
          <TouchableOpacity
            style={styles.viewFacilityBtn}
            onPress={() => router.push(`/facility/${facility.id}`)}
          >
            <Text style={styles.viewFacilityText}>View Full Facility Details →</Text>
          </TouchableOpacity>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}

function Chip({ icon, label }: { icon: string; label: string }) {
  return (
    <View style={styles.chip}>
      <Text style={styles.chipText}>{icon} {label}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  safe: { flex: 1, backgroundColor: theme.colors.background },
  header: {
    backgroundColor: theme.colors.primary,
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: theme.spacing.md,
    paddingVertical: theme.spacing.sm,
  },
  backBtn: { padding: theme.spacing.xs },
  backText: { color: '#fff', fontSize: theme.fontSize.lg },
  headerTitle: { flex: 1, color: '#fff', fontSize: theme.fontSize.md, fontWeight: '600', marginHorizontal: theme.spacing.sm },
  saveBtn: { padding: theme.spacing.xs },
  saveBtnText: { fontSize: 22 },
  scroll: { flex: 1 },
  hero: {
    backgroundColor: theme.colors.primaryDark,
    alignItems: 'center',
    paddingVertical: theme.spacing.xl,
    paddingHorizontal: theme.spacing.lg,
  },
  heroEmoji: { fontSize: 64, marginBottom: theme.spacing.sm },
  heroName: { color: '#fff', fontSize: theme.fontSize.xl, fontWeight: '700', textAlign: 'center' },
  heroSpec: { color: 'rgba(255,255,255,0.85)', fontSize: theme.fontSize.sm, marginTop: 4, textAlign: 'center' },
  heroDegrees: { color: 'rgba(255,255,255,0.7)', fontSize: theme.fontSize.xs, marginTop: 4, textAlign: 'center' },
  content: { padding: theme.spacing.lg },
  chipRow: { flexDirection: 'row', flexWrap: 'wrap', gap: theme.spacing.sm, marginBottom: theme.spacing.md },
  chip: { backgroundColor: theme.colors.chip, borderRadius: theme.radius.full, paddingHorizontal: 10, paddingVertical: 4 },
  chipText: { fontSize: theme.fontSize.xs, color: theme.colors.chipText, fontWeight: '600' },
  openBadge: { borderRadius: theme.radius.sm, padding: theme.spacing.sm, marginBottom: theme.spacing.md, alignSelf: 'flex-start' },
  openGreen: { backgroundColor: '#e8f5e9' },
  openRed: { backgroundColor: '#ffebee' },
  openText: { fontSize: theme.fontSize.sm, fontWeight: '600' },
  openGreenText: { color: theme.colors.success },
  openRedText: { color: theme.colors.error },
  sectionTitle: { fontSize: theme.fontSize.sm, fontWeight: '700', color: theme.colors.primary, marginBottom: theme.spacing.sm, marginTop: theme.spacing.md },
  facilityBox: { borderWidth: 1, borderColor: theme.colors.border, borderRadius: theme.radius.sm, padding: theme.spacing.md, backgroundColor: '#fff' },
  facilityName: { fontSize: theme.fontSize.md, fontWeight: '600', color: theme.colors.text },
  facilityAddr: { fontSize: theme.fontSize.xs, color: theme.colors.textSecondary, marginTop: 4 },
  fee: { fontSize: theme.fontSize.sm, color: theme.colors.primary, marginTop: 6, fontWeight: '600' },
  timingBox: { backgroundColor: '#fff', borderRadius: theme.radius.sm, padding: theme.spacing.md, borderWidth: 1, borderColor: theme.colors.border },
  timingText: { fontSize: theme.fontSize.xs, color: theme.colors.text, lineHeight: 20, fontFamily: 'monospace' },
  actionRow: { flexDirection: 'row', gap: theme.spacing.md, marginTop: theme.spacing.lg },
  actionBtn: { flex: 1, paddingVertical: 14, borderRadius: theme.radius.md, alignItems: 'center' },
  callBtn: { backgroundColor: theme.colors.primary },
  dirBtn: { borderWidth: 2, borderColor: theme.colors.primary, backgroundColor: '#fff' },
  actionBtnText: { color: '#fff', fontSize: theme.fontSize.sm, fontWeight: '700' },
  viewFacilityBtn: { marginTop: theme.spacing.md, alignItems: 'center', paddingVertical: theme.spacing.sm },
  viewFacilityText: { color: theme.colors.primary, fontSize: theme.fontSize.sm, fontWeight: '600' },
  center: { flex: 1, alignItems: 'center', justifyContent: 'center' },
});
