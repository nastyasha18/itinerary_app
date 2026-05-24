import 'package:flutter/material.dart';
import '../../disign/colors.dart';
import '../../database/database_helper.dart';

class AboutMuseumScreen extends StatefulWidget {
  const AboutMuseumScreen({super.key});

  @override
  State<AboutMuseumScreen> createState() => _AboutMuseumScreenState();
}

class _AboutMuseumScreenState extends State<AboutMuseumScreen> {
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
    final info = await db.getMuseumInfo();
    setState(() {
      _info = info;
      _isLoading = false;
    });
  } catch (e) {
    print('Ошибка загрузки информации о музее: $e');
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
        title: const Text('О музее', style: TextStyle(color: AppColors.lightGrey)),
        backgroundColor: AppColors.navy,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _info?['title'] ?? 'О музее',
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.dark),
              ),
              const SizedBox(height: 24),
              Text(
                _info?['description'] ?? 'Информация о музее отсутствует.',
                style: const TextStyle(fontSize: 16, height: 1.6, color: Colors.black54),
              ),
              const SizedBox(height: 20),
              if (_info?['address'] != null && _info!['address'].isNotEmpty) ...[
                const Text('Адрес:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(_info!['address'], style: const TextStyle(fontSize: 14, color: Colors.black54)),
                const SizedBox(height: 12),
              ],
              if (_info?['contacts'] != null && _info!['contacts'].isNotEmpty) ...[
                const Text('Контакты:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(_info!['contacts'], style: const TextStyle(fontSize: 14, color: Colors.black54)),
                const SizedBox(height: 12),
              ],
              if (_info?['working_hours'] != null && _info!['working_hours'].isNotEmpty) ...[
                const Text('Часы работы:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(_info!['working_hours'], style: const TextStyle(fontSize: 14, color: Colors.black54)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}