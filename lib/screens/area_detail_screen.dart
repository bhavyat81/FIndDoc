import 'package:flutter/material.dart';
import '../data/facilities.dart';
import '../models/area.dart';
import '../models/facility.dart';
import '../services/distance_service.dart';
import '../services/location_service.dart';
import '../widgets/facility_card.dart';
import 'facility_detail_screen.dart';

class AreaDetailScreen extends StatefulWidget {
  final Area area;

  const AreaDetailScreen({super.key, required this.area});

  @override
  State<AreaDetailScreen> createState() => _AreaDetailScreenState();
}

class _AreaDetailScreenState extends State<AreaDetailScreen> {
  String _selectedFilter = 'all';
  final LocationService _location = LocationService();

  List<Facility> get _filteredFacilities {
    final areaFacilities =
        facilities.where((f) => f.areaId == widget.area.id).toList();
    if (_selectedFilter == 'all') return areaFacilities;
    return areaFacilities
        .where((f) => f.type == _selectedFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final displayed = _filteredFacilities;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.area.name),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Filter row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _filterChip('All', 'all'),
                  _filterChip('Hospitals', 'hospital'),
                  _filterChip('Clinics', 'clinic'),
                  _filterChip('Labs', 'lab'),
                ],
              ),
            ),
          ),
          Expanded(
            child: displayed.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off,
                            size: 60, color: Colors.grey),
                        const SizedBox(height: 12),
                        Text(
                          'No facilities found in ${widget.area.name}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: displayed.length,
                    itemBuilder: (context, index) {
                      final facility = displayed[index];
                      final dist = DistanceService.calculate(
                        _location.latitude,
                        _location.longitude,
                        facility.latitude,
                        facility.longitude,
                      );
                      return FacilityCard(
                        facility: facility,
                        distanceKm: dist,
                        showViewDoctors: true,
                        onViewDoctors: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  FacilityDetailScreen(facility: facility),
                            ),
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

  Widget _filterChip(String label, String value) {
    final selected = _selectedFilter == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => setState(() => _selectedFilter = value),
        selectedColor: Colors.teal,
        labelStyle: TextStyle(
          color: selected ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
