import 'package:flutter/material.dart';
import '../disign/colors.dart';
import '../main.dart'; // для MainScreen
import 'login_screen.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String email;
  final String name;

  const EmailVerificationScreen({
    super.key,
    required this.email,
    required this.name,
  });

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final TextEditingController _codeController = TextEditingController();
  String _generatedCode = '';

  @override
  void initState() {
    super.initState();
    _generateCode();
  }

  void _generateCode() {
    // Генерация 6 случайных цифр
    _generatedCode = List.generate(6, (_) => (DateTime.now().microsecondsSinceEpoch % 10).toString()).join();
    print('📧 Код подтверждения для ${widget.email}: $_generatedCode');

    // Показать код в SnackBar для удобства отладки
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Тестовый код: $_generatedCode'),
          backgroundColor: AppColors.orange,
          duration: const Duration(seconds: 5),
        ),
      );
    });
  }

  void _verifyCode() {
    final enteredCode = _codeController.text.trim();
    if (enteredCode == _generatedCode) {
      // Переходим на экран входа, передаём функцию успешного входа
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(
            onLoginSuccess: () {
              // После успешного входа заменяем текущий экран на MainScreen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MainScreen()),
              );
            },
          ),
        ),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Неверный код. Попробуйте снова.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        backgroundColor: AppColors.navy,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Image.asset('assets/icons/back.png', height: 24, width: 24),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.email_outlined, size: 80, color: AppColors.orange),
              const SizedBox(height: 24),
              const Text(
                'Проверьте почту',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.dark,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Мы отправили код подтверждения на ваш email:',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: AppColors.navy),
              ),
              const SizedBox(height: 8),
              Text(
                widget.email,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.orange,
                ),
              ),
              const SizedBox(height: 32),
              Container(
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
                  controller: _codeController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: const InputDecoration(
                    labelText: 'Код из письма',
                    hintText: 'Введите 6 цифр',
                    counterText: '',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _verifyCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orange,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Отправить код',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  _generateCode();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Новый код отправлен: $_generatedCode (тестовый)'),
                      backgroundColor: AppColors.navy,
                    ),
                  );
                },
                child: const Text('Отправить код повторно'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}