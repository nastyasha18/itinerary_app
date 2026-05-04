import 'package:flutter/material.dart';
import '../disign/colors.dart';

class ActiveFiltersChips extends StatelessWidget {
  final Set<String> selectedFilters;
  final ValueChanged<String> onToggleFilter;
  final VoidCallback onClearAll;

  const ActiveFiltersChips({
    super.key,
    required this.selectedFilters,
    required this.onToggleFilter,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    final filters = <String>[
      'Студенты',
      'Семейная',
      'Турист',
      '30 минут',
      '~1.5 часа',
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Быстрые фильтры',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.dark,
                  ),
                ),
              ),
              TextButton(onPressed: onClearAll, child: const Text('Сбросить')),
            ],
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: filters.map((filter) {
                final isSelected = selectedFilters.contains(filter);

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (_) => onToggleFilter(filter),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
