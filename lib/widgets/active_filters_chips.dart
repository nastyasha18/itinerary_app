import 'package:flutter/material.dart';
import '../disign/colors.dart';

class ActiveFiltersChips extends StatelessWidget {
  final String? selectedAudience;
  final String? selectedDuration;
  final ValueChanged<String?> onAudienceSelected;
  final ValueChanged<String?> onDurationSelected;
  final VoidCallback onClearAll;

  const ActiveFiltersChips({
    super.key,
    required this.selectedAudience,
    required this.selectedDuration,
    required this.onAudienceSelected,
    required this.onDurationSelected,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
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
              children: [
                FilterChip(
                  label: const Text('Все'),
                  selected:
                      selectedAudience == null && selectedDuration == null,
                  onSelected: (value) {
                    if (value) {
                      onAudienceSelected(null);
                      onDurationSelected(null);
                    } else {
                      onClearAll();
                    }
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Студенты'),
                  selected: selectedAudience == 'Студенты',
                  onSelected: (value) {
                    onAudienceSelected(value ? 'Студенты' : null);
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Семейная'),
                  selected: selectedAudience == 'Семейная',
                  onSelected: (value) {
                    onAudienceSelected(value ? 'Семейная' : null);
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Турист'),
                  selected: selectedAudience == 'Турист',
                  onSelected: (value) {
                    onAudienceSelected(value ? 'Турист' : null);
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('30 минут'),
                  selected: selectedDuration == '30 минут',
                  onSelected: (value) {
                    onDurationSelected(value ? '30 минут' : null);
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('~1.5 часа'),
                  selected: selectedDuration == '~1.5 часа',
                  onSelected: (value) {
                    onDurationSelected(value ? '~1.5 часа' : null);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
