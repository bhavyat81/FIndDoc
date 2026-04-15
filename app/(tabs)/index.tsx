import React, { useState } from 'react';
import {
  View, Text, TextInput, ScrollView, TouchableOpacity,
  StyleSheet, FlatList, StatusBar, SafeAreaView,
} from 'react-native';
import { useRouter } from 'expo-router';
import { vadodaraAreas } from '../../data/areas';
import { specialities } from '../../data/specialities';
import { theme } from '../../constants/theme';
import AreaCard from '../../components/AreaCard';
import SpecialityCard from '../../components/SpecialityCard';

export default function HomeScreen() {
  const router = useRouter();
  const [query, setQuery] = useState('');

  const handleSearch = () => {
    if (!query.trim()) return;
    router.push(`/search/${encodeURIComponent(query.trim())}`);
  };

  const handleSpecialityPress = (name: string) => {
    router.push(`/search/${encodeURIComponent(name)}`);
  };

  return (
    <SafeAreaView style={styles.safe}>
      <StatusBar barStyle="light-content" backgroundColor={theme.colors.primary} />

      {/* AppBar */}
      <View style={styles.appBar}>
        <View>
          <Text style={styles.appTitle}>FindDoc</Text>
          <Text style={styles.appSubtitle}>📍 Vadodara</Text>
        </View>
        <TouchableOpacity onPress={() => router.push('/emergency')}>
          <Text style={styles.emergencyBtn}>🚨 Emergency</Text>
        </TouchableOpacity>
      </View>

      <ScrollView style={styles.scroll} showsVerticalScrollIndicator={false}>
        {/* Search bar */}
        <View style={styles.searchContainer}>
          <TextInput
            style={styles.searchInput}
            placeholder="Search doctor, speciality, or problem…"
            placeholderTextColor={theme.colors.textSecondary}
            value={query}
            onChangeText={setQuery}
            onSubmitEditing={handleSearch}
            returnKeyType="search"
          />
          <TouchableOpacity style={styles.searchBtn} onPress={handleSearch}>
            <Text style={styles.searchBtnText}>🔍</Text>
          </TouchableOpacity>
        </View>

        {/* Quick Actions */}
        <View style={styles.quickActions}>
          <TouchableOpacity style={styles.quickChip} onPress={() => router.push('/emergency')}>
            <Text style={[styles.quickChipText, { color: theme.colors.emergency }]}>🚨 Emergency</Text>
          </TouchableOpacity>
          <TouchableOpacity style={styles.quickChip} onPress={() => handleSpecialityPress('general')}>
            <Text style={styles.quickChipText}>🩺 General</Text>
          </TouchableOpacity>
          <TouchableOpacity style={styles.quickChip} onPress={() => handleSpecialityPress('child')}>
            <Text style={styles.quickChipText}>👶 Pediatrics</Text>
          </TouchableOpacity>
        </View>

        {/* Browse by Speciality */}
        <Text style={styles.sectionTitle}>Browse by Speciality</Text>
        <FlatList
          horizontal
          data={specialities}
          keyExtractor={s => s.id}
          renderItem={({ item }) => (
            <SpecialityCard
              speciality={item}
              onPress={() => handleSpecialityPress(item.name)}
            />
          )}
          contentContainerStyle={styles.specialityList}
          showsHorizontalScrollIndicator={false}
        />

        {/* Browse by Area */}
        <Text style={styles.sectionTitle}>Browse by Area</Text>
        <View style={styles.areaGrid}>
          {vadodaraAreas.map(area => (
            <AreaCard
              key={area.id}
              area={area}
              onPress={() => router.push(`/area/${area.id}`)}
            />
          ))}
        </View>

        <View style={{ height: 24 }} />
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safe: { flex: 1, backgroundColor: theme.colors.primary },
  appBar: {
    backgroundColor: theme.colors.primary,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: theme.spacing.lg,
    paddingVertical: theme.spacing.md,
  },
  appTitle: { color: '#fff', fontSize: theme.fontSize.lg, fontWeight: '700' },
  appSubtitle: { color: 'rgba(255,255,255,0.8)', fontSize: theme.fontSize.xs },
  emergencyBtn: {
    backgroundColor: theme.colors.emergency,
    color: '#fff',
    paddingHorizontal: 10,
    paddingVertical: 6,
    borderRadius: theme.radius.sm,
    fontSize: theme.fontSize.xs,
    fontWeight: '700',
    overflow: 'hidden',
  },
  scroll: { flex: 1, backgroundColor: theme.colors.background },
  searchContainer: {
    flexDirection: 'row',
    margin: theme.spacing.lg,
    backgroundColor: '#fff',
    borderRadius: theme.radius.md,
    alignItems: 'center',
    elevation: 3,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.15,
    shadowRadius: 3,
  },
  searchInput: {
    flex: 1,
    paddingHorizontal: theme.spacing.md,
    paddingVertical: theme.spacing.md,
    fontSize: theme.fontSize.sm,
    color: theme.colors.text,
  },
  searchBtn: { padding: theme.spacing.md },
  searchBtnText: { fontSize: 20 },
  quickActions: {
    flexDirection: 'row',
    paddingHorizontal: theme.spacing.lg,
    gap: theme.spacing.sm,
    marginBottom: theme.spacing.sm,
    flexWrap: 'wrap',
  },
  quickChip: {
    backgroundColor: '#fff',
    borderRadius: theme.radius.full,
    paddingHorizontal: 12,
    paddingVertical: 6,
    elevation: 1,
  },
  quickChipText: { fontSize: theme.fontSize.xs, fontWeight: '600', color: theme.colors.primaryDark },
  sectionTitle: {
    fontSize: theme.fontSize.lg,
    fontWeight: '700',
    color: theme.colors.text,
    paddingHorizontal: theme.spacing.lg,
    marginTop: theme.spacing.lg,
    marginBottom: theme.spacing.sm,
  },
  specialityList: { paddingHorizontal: theme.spacing.lg, paddingBottom: theme.spacing.sm },
  areaGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    paddingHorizontal: theme.spacing.sm,
  },
});
