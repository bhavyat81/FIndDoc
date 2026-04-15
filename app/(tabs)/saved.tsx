import React, { useMemo } from 'react';
import { View, Text, FlatList, StyleSheet, SafeAreaView, TouchableOpacity } from 'react-native';
import { useRouter } from 'expo-router';
import { useSaved } from '../../contexts/SavedContext';
import { doctors, doctorFacilities } from '../../data/doctors';
import { facilities } from '../../data/facilities';
import DoctorCard from '../../components/DoctorCard';
import { theme } from '../../constants/theme';
import { calculateDistance } from '../../services/distanceService';
import { USER_LOCATION } from '../../services/locationService';

export default function SavedScreen() {
  const router = useRouter();
  const { savedIds } = useSaved();

  const savedItems = useMemo(() => {
    const doctorMap = new Map(doctors.map((d) => [d.id, d]));
    const facilityMap = new Map(facilities.map((f) => [f.id, f]));

    return savedIds.flatMap((id) => {
      const df = doctorFacilities.find((d) => d.doctorId === id);
      if (!df) return [];
      const doctor = doctorMap.get(id);
      const facility = facilityMap.get(df.facilityId);
      if (!doctor || !facility) return [];
      const distanceKm = calculateDistance(USER_LOCATION.lat, USER_LOCATION.lng, facility.latitude, facility.longitude);
      return [{ doctor, doctorFacility: df, facility, distanceKm }];
    });
  }, [savedIds]);

  if (savedItems.length === 0) {
    return (
      <SafeAreaView style={styles.safe}>
        <View style={styles.appBar}>
          <Text style={styles.appTitle}>Saved Doctors</Text>
        </View>
        <View style={styles.empty}>
          <Text style={styles.emptyEmoji}>🔖</Text>
          <Text style={styles.emptyTitle}>No saved doctors yet</Text>
          <Text style={styles.emptySubtitle}>Bookmark doctors from their profile to find them here quickly.</Text>
          <TouchableOpacity style={styles.exploreBtn} onPress={() => router.push('/')}>
            <Text style={styles.exploreBtnText}>Explore Doctors</Text>
          </TouchableOpacity>
        </View>
      </SafeAreaView>
    );
  }

  return (
    <SafeAreaView style={styles.safe}>
      <View style={styles.appBar}>
        <Text style={styles.appTitle}>Saved Doctors</Text>
        <Text style={styles.count}>{savedItems.length} saved</Text>
      </View>
      <FlatList
        data={savedItems}
        keyExtractor={item => item.doctor.id}
        renderItem={({ item }) => (
          <DoctorCard
            {...item}
            onPress={() =>
              router.push({
                pathname: '/doctor/[id]',
                params: {
                  id: item.doctor.id,
                  facilityId: item.facility.id,
                },
              })
            }
          />
        )}
        contentContainerStyle={styles.list}
        showsVerticalScrollIndicator={false}
      />
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safe: { flex: 1, backgroundColor: theme.colors.background },
  appBar: {
    backgroundColor: theme.colors.primary,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: theme.spacing.lg,
    paddingVertical: theme.spacing.md,
  },
  appTitle: { color: '#fff', fontSize: theme.fontSize.lg, fontWeight: '700' },
  count: { color: 'rgba(255,255,255,0.8)', fontSize: theme.fontSize.sm },
  list: { paddingTop: theme.spacing.md, paddingBottom: theme.spacing.xl },
  empty: { flex: 1, alignItems: 'center', justifyContent: 'center', padding: theme.spacing.xl },
  emptyEmoji: { fontSize: 64, marginBottom: theme.spacing.lg },
  emptyTitle: { fontSize: theme.fontSize.xl, fontWeight: '700', color: theme.colors.text, marginBottom: theme.spacing.sm },
  emptySubtitle: { fontSize: theme.fontSize.sm, color: theme.colors.textSecondary, textAlign: 'center', marginBottom: theme.spacing.xl },
  exploreBtn: { backgroundColor: theme.colors.primary, paddingHorizontal: 24, paddingVertical: 12, borderRadius: theme.radius.md },
  exploreBtnText: { color: '#fff', fontSize: theme.fontSize.md, fontWeight: '600' },
});
