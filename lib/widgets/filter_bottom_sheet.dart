import 'package:flutter/material.dart';

class FilterBottomSheet extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onSelectCategory;

  const FilterBottomSheet({
    super.key,
    required this.selectedCategory,
    required this.onSelectCategory,
  });

  final List<String> categories = const [
    'Semua',
    'AI',
    'Mobile',
    'IoT',
    'Cybersecurity',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter Kategori',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: categories.map((cat) {
              final isSelected = selectedCategory == cat;
              return FilterChip(
                label: Text(cat),
                selected: isSelected,
                onSelected: (_) {
                  onSelectCategory(cat);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}