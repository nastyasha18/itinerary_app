import 'package:flutter/material.dart';
import '../disign/colors.dart';

class RouteFiltersSheet extends StatefulWidget {
  final String? selectedAudience;
  final String? selectedDuration;
  final void Function(String? audience, String? duration) onApply;

  const RouteFiltersSheet({
    super.key,
    required this.selectedAudience,
    required this.selectedDuration,
    required this.onApply,
  });

  @override
  State<RouteFiltersSheet> createState() => _RouteFiltersSheetState();
}

class _RouteFiltersSheetState extends State<RouteFiltersSheet> {
  late String? tempAudience;
  late String? tempDuration;

  @override
  void initState() {
    super.initState();
    tempAudience = widget.selectedAudience;
    tempDuration = widget.selectedDuration;
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
                      tempDuration = null;
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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ChoiceChip(
                    label: const Text('Все'),
                    selected: tempAudience == null,
                    onSelected: (_) => setState(() => tempAudience = null),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Студенты'),
                    selected: tempAudience == 'Студенты',
                    onSelected: (_) =>
                        setState(() => tempAudience = 'Студенты'),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Семейная'),
                    selected: tempAudience == 'Семейная',
                    onSelected: (_) =>
                        setState(() => tempAudience = 'Семейная'),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Турист'),
                    selected: tempAudience == 'Турист',
                    onSelected: (_) => setState(() => tempAudience = 'Турист'),
                  ),
                ],
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
                children: [
                  ChoiceChip(
                    label: const Text('Все'),
                    selected: tempDuration == null,
                    onSelected: (_) => setState(() => tempDuration = null),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('30 минут'),
                    selected: tempDuration == '30 минут',
                    onSelected: (_) =>
                        setState(() => tempDuration = '30 минут'),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('~1.5 часа'),
                    selected: tempDuration == '~1.5 часа',
                    onSelected: (_) =>
                        setState(() => tempDuration = '~1.5 часа'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.onApply(tempAudience, tempDuration);
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
