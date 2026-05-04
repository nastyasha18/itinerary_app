import 'package:flutter/material.dart';
import '../disign/colors.dart';
import './review_bottom_sheet.dart';

class PersonalCabinetScreen extends StatefulWidget {
  final VoidCallback? onLogout;
  const PersonalCabinetScreen({super.key, this.onLogout});

  @override
  State<PersonalCabinetScreen> createState() => _PersonalCabinetScreenState();
}

class _PersonalCabinetScreenState extends State<PersonalCabinetScreen> {
  final List<Map<String, dynamic>> _purchases = [
    {'title': 'Звезды Югры', 'price': '349₽', 'active': false},
    {'title': 'Маршрут по Ханты-Мансийску', 'price': '499₽', 'active': true},
    {'title': 'Тур по Сургуту', 'price': '599₽', 'active': false},
  ];

  void _handleReviewSubmitted(
    int rating,
    String comment,
    List<String> selectedOptions,
  ) {
    debugPrint('Rating: $rating');
    debugPrint('Comment: $comment');
    debugPrint('Selected: $selectedOptions');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 72,
                  width: 72,
                  decoration: BoxDecoration(
                    color: AppColors.navy,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Настёна Теш',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'ateshkina@bk.ru',
                        style: TextStyle(fontSize: 16, color: AppColors.navy),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'Мои покупки',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.dark,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: _purchases.length,
                itemBuilder: (context, index) {
                  final purchase = _purchases[index];
                  return Stack(
                    children: [
                      _buildPurchaseCard(
                        purchase['title'] as String,
                        purchase['price'] as String,
                        purchase['active'] as bool,
                      ),
                      if (!(purchase['active'] as bool))
                        Positioned(
                          right: 8,
                          bottom: 8,
                          child: GestureDetector(
                            onTap: () => showReviewBottomSheet(
                              context,
                              routeName: purchase['title'] as String,
                              onReviewSubmitted: _handleReviewSubmitted,
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.orange,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.orange.withOpacity(0.4),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.rate_review_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: widget.onLogout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.navy,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Выйти',
                  style: TextStyle(fontSize: 18, color: AppColors.lightGrey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPurchaseCard(String title, String price, bool active) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: active ? AppColors.navy : Colors.grey[400],
                shape: BoxShape.circle,
              ),
              child: Icon(
                active ? Icons.play_arrow : Icons.check,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    price,
                    style: const TextStyle(fontSize: 16, color: AppColors.navy),
                  ),
                  Text(
                    active ? 'Активна' : 'Пройдено',
                    style: TextStyle(
                      color: active ? AppColors.orange : Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
