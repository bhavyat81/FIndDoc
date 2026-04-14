import 'package:flutter/material.dart';
import '../data/areas.dart';
import '../data/specialities.dart';
import '../models/area.dart';
import '../widgets/area_card.dart';
import '../widgets/speciality_card.dart';
import 'area_detail_screen.dart';
import 'emergency_screen.dart';
import 'search_results_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  void _onSearch(String query) {
    if (query.trim().isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SearchResultsScreen(query: query.trim()),
      ),
    );
  }

  void _navigateToArea(Area area) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AreaDetailScreen(area: area)),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'FindDoc',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Row(
              children: const [
                Icon(Icons.location_on, size: 12),
                SizedBox(width: 2),
                Text('Vadodara', style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                onSubmitted: _onSearch,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText:
                      'Search by doctor, speciality, or problem (e.g. kidney)',
                  prefixIcon: const Icon(Icons.search, color: Colors.teal),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.arrow_forward, color: Colors.teal),
                    onPressed: () => _onSearch(_searchController.text),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                ),
              ),
            ),

            // Quick filter chips
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _filterChip('Nearby', Icons.near_me),
                  _filterChip('Open Now', Icons.access_time),
                  _filterChip('Top Rated', Icons.star),
                  _filterChip('Emergency', Icons.emergency, onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const EmergencyScreen()),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Browse by Area
            _sectionHeader('Browse by Area (Vadodara)'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2.2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: vadodaraAreas.length,
                itemBuilder: (context, index) {
                  final area = vadodaraAreas[index];
                  return AreaCard(
                    area: area,
                    onTap: () => _navigateToArea(area),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Featured specialities
            _sectionHeader('Featured Specialities'),
            SizedBox(
              height: 110,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: specialities.length,
                itemBuilder: (context, index) {
                  final sp = specialities[index];
                  return SpecialityCard(
                    speciality: sp,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              SearchResultsScreen(query: sp.keywords.first),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _filterChip(String label, IconData icon, {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: ActionChip(
        label: Text(label),
        avatar: Icon(icon, size: 16),
        onPressed: onTap ?? () {},
        backgroundColor: Colors.teal.shade50,
        side: BorderSide(color: Colors.teal.shade200),
        labelStyle:
            TextStyle(color: Colors.teal.shade800, fontWeight: FontWeight.w500),
      ),
    );
  }
}
