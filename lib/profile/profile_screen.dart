import 'package:flutter/material.dart';
import '../disign/colors.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'personal_cabinet_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentIndex = 0;

  void _goToCabinet() => setState(() => _currentIndex = 2);
  void _goToLogin() => setState(() => _currentIndex = 0);
  void _goToRegister() => setState(() => _currentIndex = 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        title: const Text(
          'Мой профиль',
          style: TextStyle(color: AppColors.lightGrey, fontSize: 16),
        ),
        backgroundColor: AppColors.navy,
        elevation: 0,
        automaticallyImplyLeading: true, // ✅ Кнопка назад
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          LoginScreen(onLogin: _goToCabinet, onGoToRegister: _goToRegister),
          RegisterScreen(onRegister: _goToCabinet),
          PersonalCabinetScreen(onLogout: _goToLogin),
        ],
      ),
      // ✅ УБРАНА BottomNavigationBar!
    );
  }
}
