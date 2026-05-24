import 'package:flutter/material.dart';
import '../../disign/colors.dart';
import '../../database/database_helper.dart';
import 'route_create_bottom_sheet.dart';
import 'route_edit_bottom_sheet.dart';
import 'route_preview_screen.dart';

class RoutesScreen extends StatefulWidget {
  const RoutesScreen({super.key});

  @override
  State<RoutesScreen> createState() => _RoutesScreenState();
}

class _RoutesScreenState extends State<RoutesScreen> {
  List<Map<String, dynamic>> _routes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRoutes();
  }

  Future<void> _loadRoutes() async {
    setState(() => _isLoading = true);
    final db = DatabaseHelper();
    final routes = await db.getAllRoutes();
    setState(() {
      _routes = routes;
      _isLoading = false;
    });
  }

  Future<void> _openCreateRoute() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const RouteCreateBottomSheet(),
    );

    if (result != null) {
      // Сохраняем в БД
      final db = DatabaseHelper();
      final routeId = await db.insertRoute({
        'title': result['title'],
        'description': result['description'],
        'price': result['price'],
        'duration': result['duration'],
        'audience': result['audience'],
        'imageUrl': result['imagePath'],
        'isPopular': 0,
        'seats': 10,
      });
      // Сохраняем точки маршрута
      final steps = result['steps'] as List<String>;
      for (int i = 0; i < steps.length; i++) {
        await db.insertRoutePoint({
          'routeId': routeId,
          'name': steps[i],
          'orderIndex': i,
        });
      }
      await _loadRoutes(); // обновляем список
      if (!mounted) return;
      // Показываем превью созданного маршрута
      final newRoute = await db.getRouteById(routeId);
      if (newRoute != null) {
        final points = await db.getRoutePoints(routeId);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RoutePreviewScreen(
              route: {
                ...newRoute,
                'steps': points.map((p) => p['name']).toList(),
              },
            ),
          ),
        );
      }
    }
  }

  Future<void> _openEditRoute(int id) async {
    final db = DatabaseHelper();
    final route = await db.getRouteById(id);
    if (route == null) return;
    final points = await db.getRoutePoints(id);
    final steps = points.map((p) => p['name'] as String).toList();

    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RouteEditBottomSheet(
        initialId: id,
        initialTitle: route['title'] ?? '',
        initialPrice: route['price'] ?? '',
        initialDescription: route['description'] ?? '',
        initialImagePath: route['imageUrl'],
        initialSteps: steps,
      ),
    );

    if (result != null) {
      // Обновляем маршрут
      await db.updateRoute(id, {
        'title': result['title'],
        'description': result['description'],
        'price': result['price'],
        'duration': result['duration'],
        'audience': result['audience'],
        'imageUrl': result['imagePath'],
      });
      // Обновляем точки: удаляем старые и вставляем новые
      await db.deleteRoutePointsByRouteId(id);
      final newSteps = result['steps'] as List<String>;
      for (int i = 0; i < newSteps.length; i++) {
        await db.insertRoutePoint({
          'routeId': id,
          'name': newSteps[i],
          'orderIndex': i,
        });
      }
      await _loadRoutes();
    }
  }

  void _openPreview(int id) async {
    final db = DatabaseHelper();
    final route = await db.getRouteById(id);
    if (route == null) return;
    final points = await db.getRoutePoints(id);
    final fullRoute = {
      ...route,
      'steps': points.map((p) => p['name']).toList(),
    };
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RoutePreviewScreen(route: fullRoute),
      ),
    );
  }

  Future<void> _deleteRoute(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text(
          'Удалить маршрут?',
          style: TextStyle(color: AppColors.dark, fontWeight: FontWeight.bold),
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
      ),
    );
    if (confirm == true) {
      final db = DatabaseHelper();
      await db.deleteRoute(id); // каскадно удалятся и точки
      await _loadRoutes();
    }
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
          onChanged: (value) {
            // TODO: фильтрация (можно добавить позже)
          },
        ),
        const SizedBox(height: 16),
        ..._routes.map((route) {
          final id = route['id'] as int;
          return GestureDetector(
            onTap: () => _openEditRoute(id),
            onLongPress: () => _openPreview(id),
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
                    onPressed: () => _deleteRoute(id),
                    icon: const Icon(
                      Icons.delete_outline,
                      color: AppColors.orange,
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
