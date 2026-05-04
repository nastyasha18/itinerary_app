import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../disign/colors.dart';

class LoginScreen extends StatelessWidget {
  final VoidCallback onLogin;
  final VoidCallback onGoToRegister; // ✅ Новый callback!

  const LoginScreen({
    super.key,
    required this.onLogin,
    required this.onGoToRegister,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          // ✅ добавлен
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/icons/logo.png', height: 64, width: 64),
              const SizedBox(height: 32),
              const Text(
                'Вход в профиль',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.dark,
                ),
              ),
              const SizedBox(height: 48),
              _buildTextField('Email или телефон', Icons.email_outlined),
              const SizedBox(height: 16),
              _buildTextField('Пароль', Icons.lock_outline, obscureText: true),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: onLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.navy,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Войти',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: onGoToRegister,
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: AppColors.dark, fontSize: 16),
                    children: [
                      const TextSpan(text: 'Нет аккаунта? '),
                      const TextSpan(
                        text: 'Зарегистрируйтесь',
                        style: TextStyle(
                          color: AppColors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    IconData icon, {
    bool obscureText = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: AppColors.navy),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
