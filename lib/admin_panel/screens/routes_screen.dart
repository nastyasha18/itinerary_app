import 'package:flutter/material.dart';
import '../../disign/colors.dart';
import 'route_create_bottom_sheet.dart';
import 'route_edit_bottom_sheet.dart';
import 'route_preview_screen.dart';

class RoutesScreen extends StatefulWidget {
  const RoutesScreen({super.key});

  @override
  State<RoutesScreen> createState() => _RoutesScreenState();
}

class _RoutesScreenState extends State<RoutesScreen> {
  final List<Map<String, dynamic>> _routes = [
    {
      'title': 'Звёзды Югры',
      'price': '349 ₽',
      'description': 'Краткий маршрут по музею с интересными экспонатами.',
      'imagePath': null,
      'steps': ['Вход в музей', 'Основная экспозиция', 'Зал традиций'],
    },
    {
      'title': 'Северный путь',
      'price': '499 ₽',
      'description': 'Маршрут с упором на историю региона и экспозиции.',
      'imagePath': null,
      'steps': ['История края', 'Артефакты', 'Современная часть'],
    },
    {
      'title': 'Легенды края',
      'price': '599 ₽',
      'description': 'Погружение в традиции, артефакты и атмосферу музея.',
      'imagePath': null,
      'steps': ['Традиции', 'Экспонаты', 'Финальный зал'],
    },
  ];

  Future<void> _openCreateRoute() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const RouteCreateBottomSheet(),
    );

    if (result != null) {
      setState(() {
        _routes.insert(0, result);
      });

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RoutePreviewScreen(route: result),
        ),
      );
    }
  }

  Future<void> _openEditRoute(int index) async {
    final route = _routes[index];

    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RouteEditBottomSheet(
        initialTitle: route['title'] ?? '',
        initialPrice: route['price'] ?? '',
        initialDescription: route['description'] ?? '',
        initialImagePath: route['imagePath'],
        initialSteps: List<String>.from(route['steps'] ?? []),
      ),
    );

    if (result != null) {
      setState(() {
        _routes[index] = result;
      });
    }
  }

  void _openPreview(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RoutePreviewScreen(route: _routes[index]),
      ),
    );
  }

  Future<void> _deleteRoute(int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            'Удалить маршрут?',
            style: TextStyle(
              color: AppColors.dark,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Это действие нельзя будет отменить.',
            style: TextStyle(color: AppColors.navy),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text(
                'Отмена',
                style: TextStyle(color: AppColors.navy),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              child: const Text('Удалить'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      setState(() {
        _routes.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Маршруты',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.dark,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          decoration: InputDecoration(
            hintText: 'Поиск маршрута',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...List.generate(_routes.length, (index) {
          final route = _routes[index];
          return GestureDetector(
            onTap: () => _openEditRoute(index),
            onLongPress: () => _openPreview(index),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.orange.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.route,
                      color: AppColors.orange,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          route['title'] ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.dark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          route['description'] ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.navy,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          route['price'] ?? '',
                          style: const TextStyle(
                            color: AppColors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => _deleteRoute(index),
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.redAccent,
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: AppColors.navy),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton.icon(
            onPressed: _openCreateRoute,
            icon: const Icon(Icons.add),
            label: const Text('Создать маршрут'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
