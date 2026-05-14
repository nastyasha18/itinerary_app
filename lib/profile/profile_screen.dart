import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'personal_cabinet_screen.dart';
import '../disign/colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final isLoggedIn = auth.currentUser != null;

    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        title: const Text('Мой профиль', style: TextStyle(color: AppColors.lightGrey, fontSize: 16)),
        backgroundColor: AppColors.navy,
        elevation: 0,
      ),
      body: isLoggedIn
          ? PersonalCabinetScreen(
              onLogout: () {
                auth.logout();
              },
            )
          : LoginScreen(
              onLoginSuccess: () {
                // Обработка не нужна: Provider перестроит виджет
              },
            ),
    );
  }
}