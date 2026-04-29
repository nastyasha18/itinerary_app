import 'package:flutter/material.dart';
import '../../disign/colors.dart';

class AboutMuseumScreen extends StatelessWidget {
  const AboutMuseumScreen({super.key});

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
          'О музее',
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
              'О музее',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.dark,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Здесь будет информация о музее.\n\n'
              'История, миссия, коллекции, контакты и другая информация.',
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
