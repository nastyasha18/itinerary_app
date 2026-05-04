import 'package:flutter/material.dart';
import '../disign/colors.dart';

class RouteFiltersSheet extends StatefulWidget {
  final Set<String> selectedFilters;
  final ValueChanged<Set<String>> onApply;
  final VoidCallback onClearAll;

  const RouteFiltersSheet({
    super.key,
    required this.selectedFilters,
    required this.onApply,
    required this.onClearAll,
  });

  @override
  State<RouteFiltersSheet> createState() => _RouteFiltersSheetState();
}

class _RouteFiltersSheetState extends State<RouteFiltersSheet> {
  late Set<String> tempSelectedFilters;

  @override
  void initState() {
    super.initState();
    tempSelectedFilters = Set<String>.from(widget.selectedFilters);
  }

  void _toggleTempFilter(String filter) {
    setState(() {
      if (tempSelectedFilters.contains(filter)) {
        tempSelectedFilters.remove(filter);
      } else {
        tempSelectedFilters.add(filter);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final audienceFilters = <String>['Студенты', 'Семейная', 'Турист'];

    final durationFilters = <String>['30 минут', '~1.5 часа'];

    Widget buildChip(String filter) {
      final selected = tempSelectedFilters.contains(filter);

      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: FilterChip(
          label: Text(filter),
          selected: selected,
          onSelected: (_) => _toggleTempFilter(filter),
          backgroundColor: AppColors.whiteGrey,
          selectedColor: AppColors.orange,
          checkmarkColor: AppColors.whiteGrey,
          labelStyle: TextStyle(
            color: selected ? AppColors.whiteGrey : AppColors.dark,
          ),
          side: BorderSide(
            color: selected ? AppColors.orange : AppColors.lightGrey,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.whiteGrey,
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
                  onPressed: () {
                    setState(() {
                      tempSelectedFilters.clear();
                    });
                    widget.onClearAll();
                  },
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
              child: Row(children: audienceFilters.map(buildChip).toList()),
            ),
            const SizedBox(height: 20),
            const Text(
              'Длительность',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: durationFilters.map(buildChip).toList()),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.onApply(tempSelectedFilters);
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
                  style: TextStyle(color: AppColors.whiteGrey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
