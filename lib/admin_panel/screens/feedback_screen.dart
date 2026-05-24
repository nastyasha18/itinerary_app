import 'package:flutter/material.dart';
import '../../disign/colors.dart';
import '../../database/database_helper.dart';
import '../../models/review.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  List<Review> _reviews = [];
  bool _isLoading = true;
  final Map<int, TextEditingController> _replyControllers = {};

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    final db = DatabaseHelper();
    final reviews = await db.getAllReviews();
    setState(() {
      _reviews = reviews;
      _isLoading = false;
    });
    // Инициализируем контроллеры для каждого отзыва
    for (var review in reviews) {
      _replyControllers[review.id!] = TextEditingController(text: review.adminReply ?? '');
    }
  }

  Future<void> _saveReply(int reviewId) async {
    final reply = _replyControllers[reviewId]?.text.trim() ?? '';
    final db = DatabaseHelper();
    await db.updateReviewAdminReply(reviewId, reply);
    // Обновляем локальный список
    setState(() {
      final index = _reviews.indexWhere((r) => r.id == reviewId);
      if (index != -1) {
        _reviews[index] = Review(
          id: _reviews[index].id,
          userId: _reviews[index].userId,
          routeId: _reviews[index].routeId,
          rating: _reviews[index].rating,
          comment: _reviews[index].comment,
          quickOptions: _reviews[index].quickOptions,
          createdAt: _reviews[index].createdAt,
          adminReply: reply,
        );
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ответ сохранён')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Отзывы',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.dark),
        ),
        const SizedBox(height: 12),
        ..._reviews.map((review) => Card(
          margin: const EdgeInsets.only(bottom: 16),
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Маршрут ID ${review.routeId}',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.dark),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.orange.withOpacity(0.14),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${review.rating} / 10',
                        style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.dark),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(review.comment, style: const TextStyle(color: AppColors.navy)),
                if (review.quickOptions.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: review.quickOptions.map((opt) => Chip(
                      label: Text(opt, style: const TextStyle(fontSize: 12)),
                      backgroundColor: AppColors.lightGrey,
                    )).toList(),
                  ),
                ],
                const SizedBox(height: 16),
                const Divider(),
                TextField(
                  controller: _replyControllers[review.id],
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Ответ администратора',
                    filled: true,
                    fillColor: AppColors.lightGrey.withOpacity(0.55),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () => _saveReply(review.id!),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Отправить'),
                  ),
                ),
              ],
            ),
          ),
        )),
        if (_reviews.isEmpty)
          const Center(child: Text('Нет отзывов', style: TextStyle(color: AppColors.navy))),
      ],
    );
  }
}