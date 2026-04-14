import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/saved_provider.dart';
import '../services/search_service.dart';
import '../services/timing_utils.dart';
import '../widgets/doctor_card.dart';
import 'doctor_detail_screen.dart';

class SearchResultsScreen extends StatefulWidget {
  final String query;

  const SearchResultsScreen({super.key, required this.query});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  late final SearchService _searchService;
  late List<SearchResult> _results;

  String _distanceFilter = 'all';
  bool _openNowFilter = false;

  @override
  void initState() {
    super.initState();
    _searchService = SearchService();
    _results = _searchService.search(widget.query);
  }

  List<SearchResult> get _filtered {
    return _results.where((r) {
      if (_distanceFilter == '2km' && r.distanceKm >= 2) return false;
      if (_distanceFilter == '2-5km' &&
          (r.distanceKm < 2 || r.distanceKm > 5)) return false;
      if (_distanceFilter == '5km' && r.distanceKm <= 5) return false;
      if (_openNowFilter && !isOpenNow(r.doctorFacility.timings)) return false;
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final matched = _searchService.matchedSpeciality;
    final displayed = _filtered;

    return Scaffold(
      appBar: AppBar(
        title: Text('Results: "${widget.query}"'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Matched speciality banner
          if (matched != null)
            Container(
              width: double.infinity,
              color: Colors.teal.shade50,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Text(matched.emoji, style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          matched.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.teal.shade800,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          matched.displayName,
                          style: TextStyle(
                            color: Colors.teal.shade600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Filters
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _distanceChip('All', 'all'),
                  _distanceChip('< 2 km', '2km'),
                  _distanceChip('2–5 km', '2-5km'),
                  _distanceChip('> 5 km', '5km'),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('Open Now'),
                    selected: _openNowFilter,
                    onSelected: (v) => setState(() => _openNowFilter = v),
                    selectedColor: Colors.teal,
                    labelStyle: TextStyle(
                      color: _openNowFilter ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '${displayed.length} doctor${displayed.length == 1 ? '' : 's'} found',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
          ),
          const SizedBox(height: 4),

          // Results
          Expanded(
            child: displayed.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off,
                            size: 60, color: Colors.grey),
                        const SizedBox(height: 12),
                        const Text('No doctors found.',
                            style: TextStyle(color: Colors.grey)),
                        const SizedBox(height: 4),
                        Text('Try a different search or filter.',
                            style: TextStyle(color: Colors.grey.shade400)),
                      ],
                    ),
                  )
                : Consumer<SavedProvider>(
                    builder: (context, savedProvider, _) {
                      return ListView.builder(
                        itemCount: displayed.length,
                        itemBuilder: (context, index) {
                          final r = displayed[index];
                          return DoctorCard(
                            doctor: r.doctor,
                            doctorFacility: r.doctorFacility,
                            facility: r.facility,
                            distanceKm: r.distanceKm,
                            isSaved: savedProvider
                                .isDoctorSaved(r.doctor.id),
                            onSaveToggle: () => savedProvider
                                .toggleDoctor(r.doctor.id),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DoctorDetailScreen(
                                    doctor: r.doctor,
                                    doctorFacility: r.doctorFacility,
                                    facility: r.facility,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _distanceChip(String label, String value) {
    final selected = _distanceFilter == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => setState(() => _distanceFilter = value),
        selectedColor: Colors.teal,
        labelStyle: TextStyle(
          color: selected ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
