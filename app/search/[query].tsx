import React, { useMemo } from 'react';
import { View, Text, FlatList, TouchableOpacity, StyleSheet, SafeAreaView } from 'react-native';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { search } from '../../services/searchService';
import DoctorCard from '../../components/DoctorCard';
import { theme } from '../../constants/theme';

export default function SearchResultsScreen() {
  const { query } = useLocalSearchParams<{ query: string }>();
  const router = useRouter();

  const { results, matchedSpeciality } = useMemo(
    () => search(decodeURIComponent(query ?? '')),
    [query],
  );

  return (
    <SafeAreaView style={styles.safe}>
      <View style={styles.header}>
        <TouchableOpacity onPress={() => router.back()} style={styles.backBtn}>
          <Text style={styles.backText}>‹ Back</Text>
        </TouchableOpacity>
        <View style={styles.headerInfo}>
          <Text style={styles.headerTitle} numberOfLines={1}>
            Results for "{decodeURIComponent(query ?? '')}"
          </Text>
          {matchedSpeciality && (
            <Text style={styles.specialityMatch}>
              {matchedSpeciality.emoji} Showing {matchedSpeciality.displayName} doctors
            </Text>
          )}
        </View>
      </View>

      <FlatList
        data={results}
        keyExtractor={r => `${r.doctor.id}-${r.facility.id}`}
        renderItem={({ item }) => (
          <DoctorCard
            doctor={item.doctor}
            doctorFacility={item.doctorFacility}
            facility={item.facility}
            distanceKm={item.distanceKm}
            onPress={() =>
              router.push({
                pathname: '/doctor/[id]',
                params: { id: item.doctor.id, facilityId: item.facility.id },
              })
            }
          />
        )}
        contentContainerStyle={styles.list}
        showsVerticalScrollIndicator={false}
        ListHeaderComponent={
          results.length > 0 ? (
            <Text style={styles.resultCount}>{results.length} result{results.length !== 1 ? 's' : ''} found</Text>
          ) : null
        }
        ListEmptyComponent={
          <View style={styles.empty}>
            <Text style={styles.emptyEmoji}>🔍</Text>
            <Text style={styles.emptyTitle}>No results found</Text>
            <Text style={styles.emptySub}>
              Try searching for a speciality (e.g. "heart", "kidney") or a doctor name.
            </Text>
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
  headerInfo: { flex: 1, marginLeft: theme.spacing.sm },
  headerTitle: { color: '#fff', fontSize: theme.fontSize.md, fontWeight: '600' },
  specialityMatch: { color: 'rgba(255,255,255,0.8)', fontSize: theme.fontSize.xs, marginTop: 2 },
  list: { paddingTop: theme.spacing.sm, paddingBottom: theme.spacing.xl },
  resultCount: { fontSize: theme.fontSize.sm, color: theme.colors.textSecondary, paddingHorizontal: theme.spacing.lg, paddingBottom: theme.spacing.sm },
  empty: { padding: theme.spacing.xxl, alignItems: 'center' },
  emptyEmoji: { fontSize: 56, marginBottom: theme.spacing.md },
  emptyTitle: { fontSize: theme.fontSize.xl, fontWeight: '700', color: theme.colors.text, marginBottom: theme.spacing.sm },
  emptySub: { fontSize: theme.fontSize.sm, color: theme.colors.textSecondary, textAlign: 'center' },
});
