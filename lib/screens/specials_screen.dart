import 'package:flutter/material.dart';
import '../models/special.dart';
import '../theme/app_colors.dart';
import '../widgets/cards/special_card.dart';

class SpecialsScreen extends StatefulWidget {
  const SpecialsScreen({Key? key}) : super(key: key);

  @override
  State<SpecialsScreen> createState() => _SpecialsScreenState();
}

class _SpecialsScreenState extends State<SpecialsScreen> {
  String _selectedFilter = 'All';
  final List<String> _filterOptions = [
    'All',
    'Weekend',
    'Spa',
    'Tour',
    'Other'
  ];

  // Demo specials data
  final List<Special> _specials = [
    Special(
      id: '1',
      title: 'Beach Resort Weekend',
      description: 'Enjoy a luxurious weekend at our beach resort',
      venueId: '1',
      venueName: 'The Elements',
      imageUrl: 'https://picsum.photos/id/1010/400/300',
      startDate: DateTime(2025, 6, 1),
      endDate: DateTime(2025, 6, 30),
      type: 'Weekend',
      discountPercentage: 30.0,
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Special(
      id: '2',
      title: 'Spa Retreat Package',
      description: 'Relax and rejuvenate with our special spa package',
      venueId: '2',
      venueName: 'Urban Loft',
      imageUrl: 'https://picsum.photos/id/1011/400/300',
      startDate: DateTime(2025, 5, 1),
      endDate: DateTime(2025, 5, 31),
      type: 'Spa',
      discountPercentage: 25.0,
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Special(
      id: '3',
      title: 'City Tour Bundle',
      description: 'Explore the city with our comprehensive tour package',
      venueId: '3',
      venueName: 'Country Mansion',
      imageUrl: 'https://picsum.photos/id/1012/400/300',
      startDate: DateTime(2025, 7, 1),
      endDate: DateTime(2025, 7, 31),
      type: 'Tour',
      discountPercentage: 40.0,
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  List<Special> get _filteredSpecials {
    if (_selectedFilter == 'All') {
      return _specials;
    }
    return _specials
        .where((special) =>
            special.type.toLowerCase() == _selectedFilter.toLowerCase())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: true,
            pinned: true,
            backgroundColor: AppColors.black,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Special Offers',
                style: TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://picsum.photos/id/1018/800/400',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 60,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filterOptions.length,
                itemBuilder: (context, index) {
                  final filter = _filterOptions[index];
                  final isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedFilter = filter;
                          });
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF2C0B3F)
                                : Colors.purple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.purpleAccent
                                  : Colors.purple.withOpacity(0.3),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              filter,
                              style: TextStyle(
                                color: isSelected
                                    ? AppColors.white
                                    : Colors.purple,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final special = _filteredSpecials[index];
                  return SpecialCard(special: special);
                },
                childCount: _filteredSpecials.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
