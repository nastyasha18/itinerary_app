import 'package:flutter/material.dart';
import '../disign/colors.dart';

class RouteFiltersSheet extends StatefulWidget {
  final String? selectedAudience;
  final bool onlyPopular;
  final bool onlyShort;
  final void Function(String? audience, bool popular, bool short) onApply;

  const RouteFiltersSheet({
    super.key,
    required this.selectedAudience,
    required this.onlyPopular,
    required this.onlyShort,
    required this.onApply,
  });

  @override
  State<RouteFiltersSheet> createState() => _RouteFiltersSheetState();
}

class _RouteFiltersSheetState extends State<RouteFiltersSheet> {
  late String? tempAudience;
  late bool tempPopular;
  late bool tempShort;

  @override
  void initState() {
    super.initState();
    tempAudience = widget.selectedAudience;
    tempPopular = widget.onlyPopular;
    tempShort = widget.onlyShort;
  }

  @override
  Widget build(BuildContext context) {
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
                  onPressed: () {
                    setState(() {
                      tempAudience = null;
                      tempPopular = false;
                      tempShort = false;
                    });
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
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('Все'),
                  selected: tempAudience == null,
                  onSelected: (_) => setState(() => tempAudience = null),
                ),
                ChoiceChip(
                  label: const Text('Студенты'),
                  selected: tempAudience == 'Студенты',
                  onSelected: (_) => setState(() => tempAudience = 'Студенты'),
                ),
                ChoiceChip(
                  label: const Text('Семейная'),
                  selected: tempAudience == 'Семейная',
                  onSelected: (_) => setState(() => tempAudience = 'Семейная'),
                ),
                ChoiceChip(
                  label: const Text('Турист'),
                  selected: tempAudience == 'Турист',
                  onSelected: (_) => setState(() => tempAudience = 'Турист'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Длительность',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilterChip(
                  label: const Text('30 минут'),
                  selected: tempPopular,
                  onSelected: (value) => setState(() => tempPopular = value),
                ),
                FilterChip(
                  label: const Text('~1.5 часа'),
                  selected: tempPopular,
                  onSelected: (value) => setState(() => tempShort = value),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.onApply(tempAudience, tempPopular, tempShort);
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
