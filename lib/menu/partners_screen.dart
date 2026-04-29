import 'package:flutter/material.dart';
import '../../disign/colors.dart';

class PartnersScreen extends StatelessWidget {
  const PartnersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset(
            'assets/icons/back.png', // ← ЗАМЕНИТЕ НА СВОЮ
            height: 24,
            width: 24,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Партнёры',
          style: TextStyle(color: AppColors.lightGrey),
        ),
        backgroundColor: AppColors.navy,
        elevation: 0,
      ),
      body: const Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Партнеры',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.dark,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Наши партнеры:\n\n'
              'Список партнеров музея\n'
              'Специальные предложения\n'
              'Контактная информация',
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
