import React from 'react';
import { View, Text, ScrollView, StyleSheet, SafeAreaView, TouchableOpacity } from 'react-native';
import { theme } from '../../constants/theme';

export default function ProfileScreen() {
  return (
    <SafeAreaView style={styles.safe}>
      <View style={styles.appBar}>
        <Text style={styles.appTitle}>Profile</Text>
      </View>
      <ScrollView style={styles.scroll} showsVerticalScrollIndicator={false}>
        {/* Avatar */}
        <View style={styles.avatarSection}>
          <View style={styles.avatar}>
            <Text style={styles.avatarEmoji}>👤</Text>
          </View>
          <Text style={styles.guestName}>Guest User</Text>
          <Text style={styles.guestSub}>Vadodara, Gujarat</Text>
        </View>

        {/* Info rows */}
        <View style={styles.section}>
          <Text style={styles.sectionTitle}>App Info</Text>
          <InfoRow label="📍 City" value="Vadodara, Gujarat" />
          <InfoRow label="🌐 Language" value="English" />
          <InfoRow label="📱 Version" value="1.0.0" />
        </View>

        <View style={styles.section}>
          <Text style={styles.sectionTitle}>About FindDoc</Text>
          <Text style={styles.aboutText}>
            FindDoc helps you find the right doctor or medical facility in Vadodara quickly. Search by name, speciality, or symptom. Save your favourite doctors for quick access.
          </Text>
        </View>

        <View style={styles.section}>
          <Text style={styles.sectionTitle}>Quick Links</Text>
          <TouchableOpacity style={styles.row}>
            <Text style={styles.rowText}>🚨 Emergency Numbers</Text>
            <Text style={styles.arrow}>›</Text>
          </TouchableOpacity>
          <TouchableOpacity style={styles.row}>
            <Text style={styles.rowText}>ℹ️ About Us</Text>
            <Text style={styles.arrow}>›</Text>
          </TouchableOpacity>
          <TouchableOpacity style={styles.row}>
            <Text style={styles.rowText}>⭐ Rate the App</Text>
            <Text style={styles.arrow}>›</Text>
          </TouchableOpacity>
        </View>

        <View style={{ height: 24 }} />
      </ScrollView>
    </SafeAreaView>
  );
}

function InfoRow({ label, value }: { label: string; value: string }) {
  return (
    <View style={styles.infoRow}>
      <Text style={styles.infoLabel}>{label}</Text>
      <Text style={styles.infoValue}>{value}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  safe: { flex: 1, backgroundColor: theme.colors.background },
  appBar: {
    backgroundColor: theme.colors.primary,
    paddingHorizontal: theme.spacing.lg,
    paddingVertical: theme.spacing.md,
  },
  appTitle: { color: '#fff', fontSize: theme.fontSize.lg, fontWeight: '700' },
  scroll: { flex: 1 },
  avatarSection: { alignItems: 'center', paddingVertical: theme.spacing.xl, backgroundColor: theme.colors.primary },
  avatar: {
    width: 80,
    height: 80,
    borderRadius: 40,
    backgroundColor: 'rgba(255,255,255,0.2)',
    alignItems: 'center',
    justifyContent: 'center',
    marginBottom: theme.spacing.sm,
  },
  avatarEmoji: { fontSize: 40 },
  guestName: { color: '#fff', fontSize: theme.fontSize.xl, fontWeight: '700' },
  guestSub: { color: 'rgba(255,255,255,0.75)', fontSize: theme.fontSize.sm, marginTop: 2 },
  section: {
    backgroundColor: '#fff',
    marginTop: theme.spacing.md,
    paddingHorizontal: theme.spacing.lg,
    paddingVertical: theme.spacing.md,
  },
  sectionTitle: {
    fontSize: theme.fontSize.sm,
    fontWeight: '700',
    color: theme.colors.primary,
    marginBottom: theme.spacing.sm,
    textTransform: 'uppercase',
    letterSpacing: 0.5,
  },
  aboutText: { fontSize: theme.fontSize.sm, color: theme.colors.textSecondary, lineHeight: 20 },
  infoRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    paddingVertical: theme.spacing.sm,
    borderBottomWidth: 1,
    borderBottomColor: theme.colors.border,
  },
  infoLabel: { fontSize: theme.fontSize.sm, color: theme.colors.text },
  infoValue: { fontSize: theme.fontSize.sm, color: theme.colors.textSecondary },
  row: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingVertical: theme.spacing.sm,
    borderBottomWidth: 1,
    borderBottomColor: theme.colors.border,
  },
  rowText: { fontSize: theme.fontSize.sm, color: theme.colors.text },
  arrow: { fontSize: 18, color: theme.colors.textSecondary },
});
