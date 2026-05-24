import 'package:flutter/foundation.dart';

class AdminProvider extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  Future<void> loadMockData() async {
    _loading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 300));
    _loading = false;
    notifyListeners();
  }
}
