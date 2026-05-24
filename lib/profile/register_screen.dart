import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../disign/colors.dart';
import 'email_verification_screen.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback onRegisterSuccess;
  const RegisterScreen({super.key, required this.onRegisterSuccess});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _nameError = '';
  String _emailError = '';
  String _passwordError = '';

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_validateFields);
    _emailController.addListener(_validateFields);
    _passwordController.addListener(_validateFields);
  }

  void _validateFields() {
    setState(() {
      // Имя
      final name = _nameController.text.trim();
      if (name.isEmpty) {
        _nameError = '';
      } else if (name.length < 2) {
        _nameError = 'Имя должно содержать хотя бы 2 символа';
      } else {
        _nameError = '';
      }

      // Email
      final email = _emailController.text.trim();
      if (email.isEmpty) {
        _emailError = '';
      } else if (!_isValidEmail(email)) {
        _emailError = 'Введите корректный email (example@mail.com)';
      } else {
        _emailError = '';
      }

      // Пароль
      final password = _passwordController.text;
      if (password.isEmpty) {
        _passwordError = '';
      } else if (password.length < 8) {
        _passwordError = 'Пароль должен быть не менее 8 символов';
      } else {
        _passwordError = '';
      }
    });
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool get _isFormValid =>
      _nameController.text.trim().isNotEmpty &&
      _emailController.text.trim().isNotEmpty &&
      _passwordController.text.isNotEmpty &&
      _nameError.isEmpty &&
      _emailError.isEmpty &&
      _passwordError.isEmpty;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        backgroundColor: AppColors.navy,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset('assets/icons/back.png', height: 24, width: 24),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/icons/logo.png', height: 64, width: 64),
              const SizedBox(height: 32),
              const Text(
                'Регистрация',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.dark),
              ),
              const SizedBox(height: 48),
              _buildTextField('Имя', Icons.person_outline, _nameController, errorText: _nameError),
              const SizedBox(height: 16),
              _buildTextField('Email', Icons.email_outlined, _emailController, errorText: _emailError),
              const SizedBox(height: 16),
              _buildTextField('Пароль', Icons.lock_outline, _passwordController,
                  obscureText: true, errorText: _passwordError),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isFormValid
    ? () async {
        final auth = Provider.of<AuthService>(context, listen: false);
        bool success = await auth.register(
          _nameController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text,
        );
        if (success) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => EmailVerificationScreen(
        email: _emailController.text.trim(),
        name: _nameController.text.trim(),
      ),
    ),
  );
} else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Пользователь с таким email уже существует')),
          );
        }
      }
    : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orange,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Зарегистрироваться', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, TextEditingController controller,
      {bool obscureText = false, String errorText = ''}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              labelText: label,
              prefixIcon: Icon(icon, color: AppColors.navy),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              errorText: null,
            ),
          ),
        ),
        if (errorText.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 4),
            child: Text(
              errorText,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}