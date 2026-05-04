import 'package:flutter/material.dart';
import '../disign/colors.dart';

class ActiveFiltersChips extends StatelessWidget {
  final String? selectedAudience;
  final bool onlyPopular;
  final bool onlyShort;
  final ValueChanged<String?> onAudienceSelected;
  final ValueChanged<bool> onPopularChanged;
  final ValueChanged<bool> onShortChanged;
  final VoidCallback onClearAll;

  const ActiveFiltersChips({
    super.key,
    required this.selectedAudience,
    required this.onlyPopular,
    required this.onlyShort,
    required this.onAudienceSelected,
    required this.onPopularChanged,
    required this.onShortChanged,
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
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ChoiceChip(
                label: const Text('Все'),
                selected: selectedAudience == null,
                onSelected: (_) => onAudienceSelected(null),
              ),
              ChoiceChip(
                label: const Text('Студенты'),
                selected: selectedAudience == 'Студенты',
                onSelected: (_) => onAudienceSelected('Студенты'),
              ),
              ChoiceChip(
                label: const Text('Семейная'),
                selected: selectedAudience == 'Семейная',
                onSelected: (_) => onAudienceSelected('Семейная'),
              ),
              ChoiceChip(
                label: const Text('Турист'),
                selected: selectedAudience == 'Турист',
                onSelected: (_) => onAudienceSelected('Турист'),
              ),
              FilterChip(
                label: const Text('30 минут'),
                selected: onlyPopular,
                onSelected: onPopularChanged,
              ),
              FilterChip(
                label: const Text('~1.5 часа'),
                selected: onlyPopular,
                onSelected: onPopularChanged,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
