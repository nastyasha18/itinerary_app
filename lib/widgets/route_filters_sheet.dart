import 'package:flutter/material.dart';
import '../disign/colors.dart';

class RouteFiltersSheet extends StatefulWidget {
  final Set<String> selectedFilters;
  final ValueChanged<String> onToggleFilter;
  final VoidCallback onClearAll;

  const RouteFiltersSheet({
    super.key,
    required this.selectedFilters,
    required this.onToggleFilter,
    required this.onClearAll,
  });

  @override
  State<RouteFiltersSheet> createState() => _RouteFiltersSheetState();
}

class _RouteFiltersSheetState extends State<RouteFiltersSheet> {
  @override
  Widget build(BuildContext context) {
    final audienceFilters = <String>['Студенты', 'Семейная', 'Турист'];

    final durationFilters = <String>['30 минут', '~1.5 часа'];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Фильтры',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.dark,
                  ),
                ),
                TextButton(
                  onPressed: widget.onClearAll,
                  child: const Text('Сбросить'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Аудитория',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: audienceFilters.map((filter) {
                  final selected = widget.selectedFilters.contains(filter);
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(filter),
                      selected: selected,
                      onSelected: (_) => widget.onToggleFilter(filter),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Длительность',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: durationFilters.map((filter) {
                  final selected = widget.selectedFilters.contains(filter);
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(filter),
                      selected: selected,
                      onSelected: (_) => widget.onToggleFilter(filter),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Применить',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
