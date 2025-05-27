import 'package:flutter/material.dart';
import '../models/special.dart';
import '../theme/app_colors.dart';
import '../widgets/cards/special_card.dart';
import '../services/api_service.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

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

  List<Special> _specials = [];
  bool _isLoading = true;
  String? _error;

  late ApiService _apiService;

  @override
  void initState() {
    super.initState();
    // _fetchSpecials(); // Call in didChangeDependencies
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final authService = Provider.of<AuthService>(context);
    _apiService = ApiService(authService);
    _fetchSpecials();
  }

  Future<void> _fetchSpecials() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final specials = await _apiService.getSpecials();
      setState(() {
        _specials = specials;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
      print('Error fetching specials: $e');
    }
  }

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
          if (_isLoading)
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.pink),
                ),
              ),
            )
          else if (_error != null)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error loading specials',
                      style: TextStyle(color: AppColors.pink),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _fetchSpecials,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          else if (_filteredSpecials.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: Text(
                  'No specials available',
                  style: TextStyle(
                    color: AppColors.white70,
                    fontSize: 16,
                  ),
                ),
              ),
            )
          else
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
