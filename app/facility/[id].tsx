import React from 'react';
import {
  View, Text, ScrollView, TouchableOpacity, StyleSheet,
  SafeAreaView, FlatList,
} from 'react-native';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { facilities } from '../../data/facilities';
import { doctors, doctorFacilities } from '../../data/doctors';
import { specialities } from '../../data/specialities';
import { theme } from '../../constants/theme';
import { weeklyTimingSummary, isOpenNow } from '../../services/timingUtils';
import { makeCall } from '../../services/callService';
import { openDirections } from '../../services/mapsService';

const TYPE_LABEL: Record<string, string> = {
  hospital: 'Multispeciality Hospital',
  clinic: 'Clinic',
  lab: 'Diagnostic Lab',
};

export default function FacilityDetailScreen() {
  const { id } = useLocalSearchParams<{ id: string }>();
  const router = useRouter();

  const facility = facilities.find((f) => f.id === id);

  if (!facility) {
    return (
      <SafeAreaView style={styles.safe}>
        <View style={styles.header}>
          <TouchableOpacity onPress={() => router.back()} style={styles.backBtn}>
            <Text style={styles.backText}>‹ Back</Text>
          </TouchableOpacity>
        </View>
        <View style={styles.center}><Text>Facility not found</Text></View>
      </SafeAreaView>
    );
  }

  const timing = weeklyTimingSummary(facility.timings);
  const open = isOpenNow(facility.timings);

  const doctorEntries = doctorFacilities
    .filter((df) => df.facilityId === facility.id)
    .map((df) => {
      const doc = doctors.find((d) => d.id === df.doctorId);
      const sp = doc ? specialities.find((s) => s.id === doc.specialityId) : undefined;
      return { doctor: doc, df, sp };
    })
    .filter((e) => e.doctor);

  return (
    <SafeAreaView style={styles.safe}>
      <View style={styles.header}>
        <TouchableOpacity onPress={() => router.back()} style={styles.backBtn}>
          <Text style={styles.backText}>‹ Back</Text>
        </TouchableOpacity>
        <Text style={styles.headerTitle} numberOfLines={1}>{facility.name}</Text>
      </View>

      <ScrollView style={styles.scroll} showsVerticalScrollIndicator={false}>
        {/* Hero */}
        <View style={styles.hero}>
          <Text style={styles.heroName}>{facility.name}</Text>
          <Text style={styles.heroType}>{TYPE_LABEL[facility.type] ?? facility.type}</Text>
          <View style={styles.ratingRow}>
            <Text style={styles.star}>⭐</Text>
            <Text style={styles.rating}>{facility.rating.toFixed(1)}</Text>
            <Text style={styles.reviewCount}>({facility.reviewCount} reviews)</Text>
          </View>
          {facility.isEmergency24x7 && (
            <View style={styles.emergencyBadge}>
              <Text style={styles.emergencyText}>🚨 Emergency 24x7</Text>
            </View>
          )}
        </View>

        <View style={styles.content}>
          {/* Open status */}
          <View style={[styles.openBadge, open ? styles.openGreen : styles.openRed]}>
            <Text style={[styles.openText, open ? styles.openGreenText : styles.openRedText]}>
              {open ? '🟢 Open Now' : '🔴 Closed Now'}
            </Text>
          </View>

          {/* Address & Phone */}
          <Text style={styles.sectionTitle}>Location</Text>
          <View style={styles.infoBox}>
            <Text style={styles.infoRow}>📍 {facility.address}</Text>
            <Text style={styles.infoRow}>📞 {facility.phone}</Text>
          </View>

          {/* Services */}
          {facility.services.length > 0 && (
            <>
              <Text style={styles.sectionTitle}>Services</Text>
              <View style={styles.chipRow}>
                {facility.services.map((s) => (
                  <View key={s} style={styles.chip}>
                    <Text style={styles.chipText}>{s}</Text>
                  </View>
                ))}
              </View>
            </>
          )}

          {/* Timings */}
          <Text style={styles.sectionTitle}>Timings</Text>
          <View style={styles.timingBox}>
            <Text style={styles.timingText}>{timing}</Text>
          </View>

          {/* Action buttons */}
          <View style={styles.actionRow}>
            <TouchableOpacity
              style={[styles.actionBtn, styles.callBtn]}
              onPress={() => makeCall(facility.phone)}
            >
              <Text style={styles.actionBtnText}>📞 Call Now</Text>
            </TouchableOpacity>
            <TouchableOpacity
              style={[styles.actionBtn, styles.dirBtn]}
              onPress={() => openDirections(facility.latitude, facility.longitude)}
            >
              <Text style={[styles.actionBtnText, { color: theme.colors.primary }]}>🗺️ Directions</Text>
            </TouchableOpacity>
          </View>

          {/* Doctors */}
          {doctorEntries.length > 0 && (
            <>
              <Text style={styles.sectionTitle}>Doctors Here</Text>
              {doctorEntries.map(({ doctor: doc, df, sp }) => (
                <TouchableOpacity
                  key={doc!.id}
                  style={styles.doctorRow}
                  onPress={() =>
                    router.push({
                      pathname: '/doctor/[id]',
                      params: { id: doc!.id, facilityId: facility.id },
                    })
                  }
                >
                  <Text style={styles.doctorEmoji}>
                    {doc!.gender === 'female' ? '👩‍⚕️' : '👨‍⚕️'}
                  </Text>
                  <View style={styles.doctorInfo}>
                    <Text style={styles.doctorName}>{doc!.name}</Text>
                    <Text style={styles.doctorSpec}>
                      {sp ? `${sp.emoji} ${sp.displayName}` : doc!.specialityId}
                    </Text>
                    {df.fee && <Text style={styles.doctorFee}>₹{df.fee}</Text>}
                  </View>
                  <Text style={styles.arrow}>›</Text>
                </TouchableOpacity>
              ))}
            </>
          )}
        </View>
      </ScrollView>
    </SafeAreaView>
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
  headerTitle: { flex: 1, color: '#fff', fontSize: theme.fontSize.md, fontWeight: '600', marginLeft: theme.spacing.sm },
  scroll: { flex: 1 },
  hero: {
    backgroundColor: theme.colors.primaryDark,
    padding: theme.spacing.xl,
    alignItems: 'flex-start',
  },
  heroName: { color: '#fff', fontSize: theme.fontSize.xl, fontWeight: '700' },
  heroType: { color: 'rgba(255,255,255,0.75)', fontSize: theme.fontSize.sm, marginTop: 4 },
  ratingRow: { flexDirection: 'row', alignItems: 'center', marginTop: theme.spacing.sm },
  star: { fontSize: 14 },
  rating: { color: '#fff', fontSize: theme.fontSize.sm, fontWeight: '700', marginLeft: 4 },
  reviewCount: { color: 'rgba(255,255,255,0.7)', fontSize: theme.fontSize.xs, marginLeft: 4 },
  emergencyBadge: { backgroundColor: theme.colors.emergency, borderRadius: theme.radius.sm, paddingHorizontal: 10, paddingVertical: 4, marginTop: theme.spacing.sm },
  emergencyText: { color: '#fff', fontSize: theme.fontSize.sm, fontWeight: '700' },
  content: { padding: theme.spacing.lg },
  openBadge: { borderRadius: theme.radius.sm, padding: theme.spacing.sm, marginBottom: theme.spacing.md, alignSelf: 'flex-start' },
  openGreen: { backgroundColor: '#e8f5e9' },
  openRed: { backgroundColor: '#ffebee' },
  openText: { fontSize: theme.fontSize.sm, fontWeight: '600' },
  openGreenText: { color: theme.colors.success },
  openRedText: { color: theme.colors.error },
  sectionTitle: { fontSize: theme.fontSize.sm, fontWeight: '700', color: theme.colors.primary, marginBottom: theme.spacing.sm, marginTop: theme.spacing.md },
  infoBox: { backgroundColor: '#fff', borderRadius: theme.radius.sm, padding: theme.spacing.md, borderWidth: 1, borderColor: theme.colors.border, gap: 6 },
  infoRow: { fontSize: theme.fontSize.sm, color: theme.colors.text },
  chipRow: { flexDirection: 'row', flexWrap: 'wrap', gap: theme.spacing.xs },
  chip: { backgroundColor: theme.colors.chip, borderRadius: theme.radius.full, paddingHorizontal: 10, paddingVertical: 4 },
  chipText: { fontSize: theme.fontSize.xs, color: theme.colors.chipText, fontWeight: '600' },
  timingBox: { backgroundColor: '#fff', borderRadius: theme.radius.sm, padding: theme.spacing.md, borderWidth: 1, borderColor: theme.colors.border },
  timingText: { fontSize: theme.fontSize.xs, color: theme.colors.text, lineHeight: 20 },
  actionRow: { flexDirection: 'row', gap: theme.spacing.md, marginTop: theme.spacing.lg },
  actionBtn: { flex: 1, paddingVertical: 14, borderRadius: theme.radius.md, alignItems: 'center' },
  callBtn: { backgroundColor: theme.colors.primary },
  dirBtn: { borderWidth: 2, borderColor: theme.colors.primary, backgroundColor: '#fff' },
  actionBtnText: { color: '#fff', fontSize: theme.fontSize.sm, fontWeight: '700' },
  doctorRow: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#fff',
    padding: theme.spacing.md,
    borderRadius: theme.radius.sm,
    marginBottom: theme.spacing.xs,
    borderWidth: 1,
    borderColor: theme.colors.border,
  },
  doctorEmoji: { fontSize: 28, marginRight: theme.spacing.md },
  doctorInfo: { flex: 1 },
  doctorName: { fontSize: theme.fontSize.sm, fontWeight: '700', color: theme.colors.text },
  doctorSpec: { fontSize: theme.fontSize.xs, color: theme.colors.primary, marginTop: 2 },
  doctorFee: { fontSize: theme.fontSize.xs, color: theme.colors.textSecondary, marginTop: 2 },
  arrow: { fontSize: 20, color: theme.colors.textSecondary },
  center: { flex: 1, alignItems: 'center', justifyContent: 'center' },
});
