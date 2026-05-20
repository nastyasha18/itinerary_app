import 'package:flutter/material.dart';
import '../../disign/colors.dart';
import '../../database/database_helper.dart';

class VisitorsScreen extends StatefulWidget {
  const VisitorsScreen({super.key});

  @override
  State<VisitorsScreen> createState() => _VisitorsScreenState();
}

class _VisitorsScreenState extends State<VisitorsScreen> {
  Map<String, dynamic>? _info;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInfo();
  }

  Future<void> _loadInfo() async {
    try {
      final db = DatabaseHelper();
      final info = await db.getVisitorInfo();
      setState(() {
        _info = info;
        _isLoading = false;
      });
    } catch (e) {
      print('Ошибка загрузки информации для посетителей: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.lightGrey,
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset('assets/icons/back.png', height: 24, width: 24),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Посетителям', style: TextStyle(color: AppColors.lightGrey)),
        backgroundColor: AppColors.navy,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Посетителям',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.dark),
              ),
              const SizedBox(height: 24),
              if (_info?['working_hours'] != null && _info!['working_hours'].isNotEmpty)
                _buildInfoItem('Часы работы', _info!['working_hours']),
              if (_info?['contact_phone'] != null && _info!['contact_phone'].isNotEmpty)
                _buildInfoItem('Контактный телефон', _info!['contact_phone']),
              if (_info?['email'] != null && _info!['email'].isNotEmpty)
                _buildInfoItem('Email', _info!['email']),
              if (_info?['how_to_get'] != null && _info!['how_to_get'].isNotEmpty)
                _buildInfoItem('Как добраться', _info!['how_to_get']),
              if (_info?['rules'] != null && _info!['rules'].isNotEmpty)
                _buildInfoItem('Правила посещения', _info!['rules']),
              if (_info == null ||
                  (_info!['working_hours'] == '' &&
                   _info!['contact_phone'] == '' &&
                   _info!['email'] == '' &&
                   _info!['how_to_get'] == '' &&
                   _info!['rules'] == ''))
                const Text(
                  'Информация для посетителей отсутствует.',
                  style: TextStyle(fontSize: 16, height: 1.6, color: Colors.black54),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.dark)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 15, color: Colors.black54, height: 1.4)),
        ],
      ),
    );
  }
}