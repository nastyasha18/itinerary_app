import 'package:flutter/material.dart';
import '../../disign/colors.dart';
import 'about_museum_screen.dart';
import 'visitors_screen.dart';
import 'partners_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        title: const Text('Меню', style: TextStyle(color: AppColors.lightGrey)),
        backgroundColor: AppColors.navy,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Перейти к разделу',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.dark,
              ),
            ),
            const SizedBox(height: 32),
            _buildMenuItem(
              context,
              icon: Icons.info_outline,
              title: 'О музее',
              color: AppColors.navy,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutMuseumScreen()),
              ),
            ),
            const SizedBox(height: 16),
            _buildMenuItem(
              context,
              icon: Icons.people_outline,
              title: 'Посетителям',
              color: AppColors.orange,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const VisitorsScreen()),
              ),
            ),
            const SizedBox(height: 16),
            _buildMenuItem(
              context,
              icon: Icons.handshake_outlined,
              title: 'Партнеры',
              color: AppColors.blue,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PartnersScreen()),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
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
        child: Row(
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.dark,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.navy,
            ),
          ],
        ),
      ),
    );
  }
}
