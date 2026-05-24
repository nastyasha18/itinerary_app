import 'package:flutter/material.dart';
import '../../disign/colors.dart';
import '../../database/database_helper.dart';

class AboutMuseumScreen extends StatefulWidget {
  const AboutMuseumScreen({super.key});

  @override
  State<AboutMuseumScreen> createState() => _AboutMuseumScreenState();
}

class _AboutMuseumScreenState extends State<AboutMuseumScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _contactsController = TextEditingController();
  final _hoursController = TextEditingController();
  bool _isLoading = true;
  int? _infoId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final db = DatabaseHelper();
    final info = await db.getMuseumInfo();
    if (info != null) {
      _infoId = info['id'];
      _titleController.text = info['title'] ?? '';
      _descriptionController.text = info['description'] ?? '';
      _addressController.text = info['address'] ?? '';
      _contactsController.text = info['contacts'] ?? '';
      _hoursController.text = info['working_hours'] ?? '';
    }
    setState(() => _isLoading = false);
  }

Future<void> _saveData() async {
  final db = DatabaseHelper();
  final Map<String, dynamic> info = {
    'title': _titleController.text.trim(),
    'description': _descriptionController.text.trim(),
    'address': _addressController.text.trim(),
    'contacts': _contactsController.text.trim(),
    'working_hours': _hoursController.text.trim(),
    'imageUrl': '',
  };
  if (_infoId == null) {
    await db.insertMuseumInfo(info);
  } else {
    info['id'] = _infoId; // теперь ошибки не будет, так как тип Map<String, dynamic>
    await db.updateMuseumInfo(info);
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
          'О музее',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.dark),
        ),
        const SizedBox(height: 12),
        _field(controller: _titleController, label: 'Название музея'),
        _field(controller: _descriptionController, label: 'Описание', maxLines: 4),
        _field(controller: _addressController, label: 'Адрес'),
        _field(controller: _contactsController, label: 'Контакты'),
        _field(controller: _hoursController, label: 'Часы работы'),
        const SizedBox(height: 16),
        Container(
          height: 160,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Center(
            child: Text('Загрузить фото', style: TextStyle(color: AppColors.navy)),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _saveData,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.navy,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(54),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: const Text('Сохранить'),
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