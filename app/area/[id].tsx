import React, { useState } from 'react';
import {
  View, Text, FlatList, TouchableOpacity, StyleSheet,
  SafeAreaView,
} from 'react-native';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { vadodaraAreas } from '../../data/areas';
import { facilities } from '../../data/facilities';
import { theme } from '../../constants/theme';
import FacilityCard from '../../components/FacilityCard';
import { calculateDistance } from '../../services/distanceService';
import { USER_LOCATION } from '../../services/locationService';

const FILTERS = ['All', 'Hospital', 'Clinic', 'Lab'];

export default function AreaDetailScreen() {
  const { id } = useLocalSearchParams<{ id: string }>();
  const router = useRouter();
  const [filter, setFilter] = useState('All');

  const area = vadodaraAreas.find((a) => a.id === id);
  const areaFacilities = facilities
    .filter((f) => f.areaId === id)
    .filter((f) => filter === 'All' || f.type === filter.toLowerCase())
    .map((f) => ({
      ...f,
      distanceKm: calculateDistance(USER_LOCATION.lat, USER_LOCATION.lng, f.latitude, f.longitude),
    }));

  return (
    <SafeAreaView style={styles.safe}>
      <View style={styles.header}>
        <TouchableOpacity onPress={() => router.back()} style={styles.backBtn}>
          <Text style={styles.backText}>‹ Back</Text>
        </TouchableOpacity>
        <Text style={styles.headerTitle}>{area?.name ?? 'Area'}</Text>
      </View>

      {/* Filter chips */}
      <View style={styles.filterRow}>
        {FILTERS.map(f => (
          <TouchableOpacity
            key={f}
            style={[styles.filterChip, filter === f && styles.filterChipActive]}
            onPress={() => setFilter(f)}
          >
            <Text style={[styles.filterChipText, filter === f && styles.filterChipTextActive]}>
              {f}
            </Text>
          </TouchableOpacity>
        ))}
      </View>

      <FlatList
        data={areaFacilities}
        keyExtractor={f => f.id}
        renderItem={({ item }) => (
          <FacilityCard
            facility={item}
            distanceKm={item.distanceKm}
            onPress={() => router.push(`/facility/${item.id}`)}
          />
        )}
        contentContainerStyle={styles.list}
        showsVerticalScrollIndicator={false}
        ListEmptyComponent={
          <View style={styles.empty}>
            <Text style={styles.emptyText}>No {filter === 'All' ? '' : filter.toLowerCase() + ' '}facilities found in {area?.name}.</Text>
          </View>
        }
      />
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
  headerTitle: { flex: 1, color: '#fff', fontSize: theme.fontSize.md, fontWeight: '700', marginLeft: theme.spacing.sm },
  filterRow: {
    flexDirection: 'row',
    padding: theme.spacing.md,
    gap: theme.spacing.sm,
    backgroundColor: '#fff',
    borderBottomWidth: 1,
    borderBottomColor: theme.colors.border,
  },
  filterChip: {
    paddingHorizontal: 14,
    paddingVertical: 6,
    borderRadius: theme.radius.full,
    backgroundColor: theme.colors.background,
    borderWidth: 1,
    borderColor: theme.colors.border,
  },
  filterChipActive: { backgroundColor: theme.colors.primary, borderColor: theme.colors.primary },
  filterChipText: { fontSize: theme.fontSize.xs, color: theme.colors.text, fontWeight: '600' },
  filterChipTextActive: { color: '#fff' },
  list: { paddingTop: theme.spacing.md, paddingBottom: theme.spacing.xl },
  empty: { padding: theme.spacing.xl, alignItems: 'center' },
  emptyText: { fontSize: theme.fontSize.sm, color: theme.colors.textSecondary, textAlign: 'center' },
});
