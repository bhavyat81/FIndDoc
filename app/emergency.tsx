import React from 'react';
import {
  View, Text, ScrollView, TouchableOpacity, StyleSheet,
  SafeAreaView,
} from 'react-native';
import { useRouter } from 'expo-router';
import { facilities } from '../data/facilities';
import { theme } from '../constants/theme';
import { makeCall } from '../services/callService';
import { openDirections } from '../services/mapsService';

const HELPLINES = [
  { name: 'Ambulance', number: '108', emoji: '🚑' },
  { name: 'Police', number: '100', emoji: '👮' },
  { name: 'Fire Brigade', number: '101', emoji: '🔥' },
  { name: 'Women Helpline', number: '1091', emoji: '👩' },
  { name: 'Child Helpline', number: '1098', emoji: '👶' },
];

export default function EmergencyScreen() {
  const router = useRouter();
  const emergencyFacilities = facilities.filter(f => f.isEmergency24x7);

  return (
    <SafeAreaView style={styles.safe}>
      <View style={styles.header}>
        <TouchableOpacity onPress={() => router.back()} style={styles.backBtn}>
          <Text style={styles.backText}>‹ Back</Text>
        </TouchableOpacity>
        <Text style={styles.headerTitle}>Emergency</Text>
      </View>

      <ScrollView style={styles.scroll} showsVerticalScrollIndicator={false}>
        {/* Banner */}
        <View style={styles.banner}>
          <Text style={styles.bannerTitle}>🚨 Emergency Services</Text>
          <Text style={styles.bannerSub}>Tap to call immediately</Text>
        </View>

        <Text style={styles.sectionTitle}>Important Helplines</Text>
        {HELPLINES.map(h => (
          <View key={h.number} style={styles.helplineCard}>
            <Text style={styles.helplineEmoji}>{h.emoji}</Text>
            <View style={styles.helplineInfo}>
              <Text style={styles.helplineName}>{h.name}</Text>
              <Text style={styles.helplineNumber}>{h.number}</Text>
            </View>
            <TouchableOpacity
              style={styles.callBtn}
              onPress={() => makeCall(h.number)}
            >
              <Text style={styles.callBtnText}>📞 Call</Text>
            </TouchableOpacity>
          </View>
        ))}

        <Text style={styles.sectionTitle}>24×7 Emergency Hospitals in Vadodara</Text>
        {emergencyFacilities.map(f => (
          <View key={f.id} style={styles.facilityCard}>
            <View style={styles.facilityHeader}>
              <Text style={styles.facilityEmoji}>🏥</Text>
              <Text style={styles.facilityName} numberOfLines={2}>{f.name}</Text>
            </View>
            <Text style={styles.facilityAddr} numberOfLines={2}>📍 {f.address}</Text>
            <View style={styles.facilityActions}>
              <TouchableOpacity
                style={[styles.actionBtn, styles.redBtn]}
                onPress={() => makeCall(f.phone)}
              >
                <Text style={styles.actionBtnText}>📞 Call Now</Text>
              </TouchableOpacity>
              <TouchableOpacity
                style={[styles.actionBtn, styles.outlineBtn]}
                onPress={() => openDirections(f.latitude, f.longitude)}
              >
                <Text style={[styles.actionBtnText, { color: theme.colors.emergency }]}>🗺️ Directions</Text>
              </TouchableOpacity>
            </View>
          </View>
        ))}

        <View style={{ height: 24 }} />
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safe: { flex: 1, backgroundColor: theme.colors.emergencyLight },
  header: {
    backgroundColor: theme.colors.emergency,
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: theme.spacing.md,
    paddingVertical: theme.spacing.sm,
  },
  backBtn: { padding: theme.spacing.xs },
  backText: { color: '#fff', fontSize: theme.fontSize.lg },
  headerTitle: { color: '#fff', fontSize: theme.fontSize.lg, fontWeight: '700', marginLeft: theme.spacing.sm },
  scroll: { flex: 1 },
  banner: {
    backgroundColor: theme.colors.emergency,
    padding: theme.spacing.xl,
    alignItems: 'center',
  },
  bannerTitle: { color: '#fff', fontSize: theme.fontSize.xl, fontWeight: '700' },
  bannerSub: { color: 'rgba(255,255,255,0.8)', fontSize: theme.fontSize.sm, marginTop: 4 },
  sectionTitle: {
    fontSize: theme.fontSize.md,
    fontWeight: '700',
    color: '#b71c1c',
    paddingHorizontal: theme.spacing.lg,
    paddingTop: theme.spacing.lg,
    paddingBottom: theme.spacing.sm,
  },
  helplineCard: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#fff',
    marginHorizontal: theme.spacing.lg,
    marginBottom: theme.spacing.xs,
    borderRadius: theme.radius.md,
    padding: theme.spacing.md,
    elevation: 2,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.1,
    shadowRadius: 2,
  },
  helplineEmoji: { fontSize: 30, marginRight: theme.spacing.md },
  helplineInfo: { flex: 1 },
  helplineName: { fontSize: theme.fontSize.sm, fontWeight: '600', color: theme.colors.text },
  helplineNumber: { fontSize: theme.fontSize.md, fontWeight: '700', color: theme.colors.emergency, marginTop: 2 },
  callBtn: { backgroundColor: theme.colors.emergency, borderRadius: theme.radius.sm, paddingHorizontal: 14, paddingVertical: 8 },
  callBtnText: { color: '#fff', fontSize: theme.fontSize.xs, fontWeight: '700' },
  facilityCard: {
    backgroundColor: '#fff',
    marginHorizontal: theme.spacing.lg,
    marginBottom: theme.spacing.sm,
    borderRadius: theme.radius.md,
    padding: theme.spacing.md,
    elevation: 2,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.1,
    shadowRadius: 2,
  },
  facilityHeader: { flexDirection: 'row', alignItems: 'flex-start', marginBottom: theme.spacing.sm },
  facilityEmoji: { fontSize: 22, marginRight: theme.spacing.sm },
  facilityName: { flex: 1, fontSize: theme.fontSize.md, fontWeight: '700', color: theme.colors.text },
  facilityAddr: { fontSize: theme.fontSize.xs, color: theme.colors.textSecondary, marginBottom: theme.spacing.md },
  facilityActions: { flexDirection: 'row', gap: theme.spacing.sm },
  actionBtn: { flex: 1, paddingVertical: 10, borderRadius: theme.radius.sm, alignItems: 'center' },
  redBtn: { backgroundColor: theme.colors.emergency },
  outlineBtn: { borderWidth: 2, borderColor: theme.colors.emergency, backgroundColor: '#fff' },
  actionBtnText: { color: '#fff', fontSize: theme.fontSize.xs, fontWeight: '700' },
});
