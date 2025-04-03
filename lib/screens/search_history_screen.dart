import 'package:flutter/material.dart';
import '../services/search_service.dart';

class SearchHistoryScreen extends StatelessWidget {
  final Function(String) onSearchSelected;

  const SearchHistoryScreen({
    Key? key,
    required this.onSearchSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recentSearches = SearchService.getRecentSearches();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Searches',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (recentSearches.isNotEmpty)
                TextButton(
                  onPressed: () {
                    // Clear recent searches functionality would go here
                    // In a real app, this would clear SharedPreferences
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Search history cleared'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: const Text('Clear'),
                ),
            ],
          ),
        ),
        if (recentSearches.isEmpty)
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 80,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No recent searches',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (recentSearches.isNotEmpty)
          Expanded(
            child: ListView.builder(
              itemCount: recentSearches.length,
              itemBuilder: (context, index) {
                final search = recentSearches[index];
                return ListTile(
                  leading: const Icon(Icons.history),
                  title: Text(search),
                  onTap: () => onSearchSelected(search),
                  trailing: const Icon(Icons.north_west, size: 16),
                );
              },
            ),
          ),
      ],
    );
  }
}
