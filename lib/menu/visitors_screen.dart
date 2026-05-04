import 'package:flutter/material.dart';
import '../../disign/colors.dart';

class VisitorsScreen extends StatelessWidget {
  const VisitorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset('assets/icons/back.png', height: 24, width: 24),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Посетителям',
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
              'Посетителям',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.dark,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Информация для посетителей:\n\n'
              'Часы работы\n'
              'Стоимость билетов\n'
              'Как добраться\n'
              'Правила посещения\n'
              'Контакты',
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
