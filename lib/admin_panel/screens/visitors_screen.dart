import 'package:flutter/material.dart';
import '../../disign/colors.dart';
import '../../database/database_helper.dart';

class VisitorsScreen extends StatefulWidget {
  const VisitorsScreen({super.key});

  @override
  State<VisitorsScreen> createState() => _VisitorsScreenState();
}

class _VisitorsScreenState extends State<VisitorsScreen> {
  final _workingHoursController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _rulesController = TextEditingController();
  final _howToGetController = TextEditingController();
  bool _isLoading = true;
  int? _infoId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final db = DatabaseHelper();
    final info = await db.getVisitorInfo();
    if (info != null) {
      _infoId = info['id'];
      _workingHoursController.text = info['working_hours'] ?? '';
      _phoneController.text = info['contact_phone'] ?? '';
      _emailController.text = info['email'] ?? '';
      _rulesController.text = info['rules'] ?? '';
      _howToGetController.text = info['how_to_get'] ?? '';
    }
    setState(() => _isLoading = false);
  }

  Future<void> _saveData() async {
    final db = DatabaseHelper();
    final Map<String, dynamic> info = {
      'working_hours': _workingHoursController.text.trim(),
      'contact_phone': _phoneController.text.trim(),
      'email': _emailController.text.trim(),
      'rules': _rulesController.text.trim(),
      'how_to_get': _howToGetController.text.trim(),
    };
    if (_infoId == null) {
      await db.insertVisitorInfo(info);
    } else {
      info['id'] = _infoId;
      await db.updateVisitorInfo(info);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Информация сохранена')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Для посетителей',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.dark),
        ),
        const SizedBox(height: 12),
        _field(controller: _workingHoursController, label: 'Рабочие часы'),
        _field(controller: _phoneController, label: 'Контактный телефон'),
        _field(controller: _emailController, label: 'Email'),
        _field(controller: _rulesController, label: 'Правила посещения', maxLines: 4),
        _field(controller: _howToGetController, label: 'Как добраться', maxLines: 4),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _saveData,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.orange,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(54),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: const Text('Сохранить изменения'),
        ),
      ],
    );
  }

  Widget _field({required TextEditingController controller, required String label, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}