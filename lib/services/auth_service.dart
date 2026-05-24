import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/database_helper.dart';
import '../database/user_model.dart';

class AuthService extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  User? _currentUser;

  User? get currentUser => _currentUser;

  AuthService() {
    _loadSession(); // загружаем сессию при создании сервиса
  }

  // Загрузка сохранённого email и восстановление пользователя из БД
  Future<void> _loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('userEmail');
    if (email != null && email.isNotEmpty) {
      final user = await _dbHelper.getUserByEmail(email);
      if (user != null) {
        _currentUser = user;
        notifyListeners();
      }
    }
  }

  // Сохранение сессии после успешного входа
  Future<void> _saveSession(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userEmail', email);
  }

  // Удаление сессии при выходе
  Future<void> _clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userEmail');
  }

  // Регистрация
  Future<bool> register(String name, String email, String password) async {
    final existingUser = await _dbHelper.getUserByEmail(email);
    if (existingUser != null) return false;
    final user = User(name: name, email: email, password: password);
    await _dbHelper.insertUser(user);
    _currentUser = user;
    await _saveSession(email);
    notifyListeners();
    return true;
  }

  // Вход
  Future<bool> login(String email, String password) async {
    final user = await _dbHelper.getUserByEmail(email);
    if (user != null && user.password == password) {
      _currentUser = user;
      await _saveSession(email);
      notifyListeners();
      return true;
    }
    return false;
  }

  // Выход
  Future<void> logout() async {
    _currentUser = null;
    await _clearSession();
    notifyListeners();
  }
}