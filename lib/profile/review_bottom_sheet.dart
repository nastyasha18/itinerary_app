import 'package:flutter/material.dart';
import '../disign/colors.dart';
import '../database/database_helper.dart';
import '../models/review.dart';

class ReviewBottomSheet extends StatefulWidget {
  final int routeId;
  final int userId;
  final String routeName;

  const ReviewBottomSheet({
    super.key,
    required this.routeId,
    required this.userId,
    required this.routeName,
  });

  @override
  State<ReviewBottomSheet> createState() => _ReviewBottomSheetState();
}

class _ReviewBottomSheetState extends State<ReviewBottomSheet> {
  int _selectedRating = 5;
  final TextEditingController _commentController = TextEditingController();

  final List<String> _checkOptions = [
    'Всё понравилось',
    'Удобный маршрут',
    'Красивые виды',
    'Хочу ещё',
  ];
  final List<bool> _checkedStates = [false, false, false, false];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _toggleChip(int index) {
    setState(() {
      _checkedStates[index] = !_checkedStates[index];
    });
  }

  Future<void> _submitReview() async {
    final selectedOptions = _checkOptions
        .asMap()
        .entries
        .where((entry) => _checkedStates[entry.key])
        .map((entry) => entry.value)
        .toList();

    final review = Review(
      userId: widget.userId,
      routeId: widget.routeId,
      rating: _selectedRating,
      comment: _commentController.text.trim(),
      quickOptions: selectedOptions,
      createdAt: DateTime.now(),
      adminReply: null,
    );

    final db = DatabaseHelper();
    await db.insertReview(review);

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Спасибо за ваш отзыв!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Оставьте отзыв',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.dark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.routeName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 16),
            const Text('Оценка:'),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(10, (index) {
                  final number = index + 1;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedRating = number),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: number <= _selectedRating ? AppColors.orange : AppColors.whiteGrey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$number',
                        style: TextStyle(
                          color: number <= _selectedRating ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Комментарий:'),
            const SizedBox(height: 8),
            TextField(
              controller: _commentController,
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                hintText: 'Напишите ваш отзыв...',
              ),
            ),
            const SizedBox(height: 16),
            const Text('Быстрые ответы:'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(_checkOptions.length, (index) {
                return FilterChip(
                  label: Text(
                    _checkOptions[index],
                    style: TextStyle(
                      fontSize: 13,
                      color: _checkedStates[index] ? Colors.white : Colors.black87,
                    ),
                  ),
                  selected: _checkedStates[index],
                  onSelected: (_) => _toggleChip(index),
                  selectedColor: AppColors.orange,
                  checkmarkColor: Colors.white,
                  backgroundColor: AppColors.whiteGrey,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                );
              }),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _submitReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.navy,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Отправить отзыв',
                  style: TextStyle(fontSize: 16, color: AppColors.lightGrey),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}