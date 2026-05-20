import 'package:flutter/material.dart';
import '../../disign/colors.dart';
import '../../database/database_helper.dart';

class AdminDashboardScreen extends StatefulWidget {
  final Function(int) onNavigate;
  const AdminDashboardScreen({super.key, required this.onNavigate});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _routesCount = 0;
  int _reviewsCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCounts();
  }

  Future<void> _loadCounts() async {
    setState(() => _isLoading = true);
    final db = DatabaseHelper();
    final routes = await db.getAllRoutes();
    final reviews = await db.getAllReviews();
    setState(() {
      _routesCount = routes.length;
      _reviewsCount = reviews.length;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.navy, AppColors.deepNavy],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Добро пожаловать, администратор',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Управляйте маршрутами, информацией и отзывами',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (_isLoading)
          const Center(child: CircularProgressIndicator())
        else
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _StatCard(
                title: 'Маршруты',
                value: '$_routesCount',
                icon: Icons.route,
                onTap: () => widget.onNavigate(1),
              ),
              _StatCard(
                title: 'Отзывы',
                value: '$_reviewsCount',
                icon: Icons.rate_review,
                onTap: () => widget.onNavigate(4),
              ),
              _StatCard(
                title: 'Музей',
                value: '1',
                icon: Icons.museum,
                onTap: () => widget.onNavigate(2),
              ),
              _StatCard(
                title: 'Посетители',
                value: '1',
                icon: Icons.groups,
                onTap: () => widget.onNavigate(3),
              ),
            ],
          ),
        const SizedBox(height: 16),
        _ActionCard(
          title: 'Быстрые действия',
          items: [
            {'title': 'Создать маршрут', 'index': 1, 'extra': 'create'},
            {'title': 'Обновить информацию о музее', 'index': 2},
            {'title': 'Отредактировать блок для посетителей', 'index': 3},
            {'title': 'Проверить новые отзывы', 'index': 4},
          ],
          onItemTap: (item) {
            // Переключаемся на нужную вкладку
            widget.onNavigate(item['index'] as int);
            // Дополнительно: если нужно открыть форму создания маршрута, можно после переключения отправить сигнал. 
            // Для простоты просто переключаем, а пользователь сам нажмёт кнопку "Создать маршрут" на вкладке.
          },
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final VoidCallback? onTap;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width / 2 - 24,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: AppColors.orange.withOpacity(0.14),
              child: Icon(icon, color: AppColors.orange),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.dark,
              ),
            ),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(color: AppColors.navy)),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> items;
  final Function(Map<String, dynamic>) onItemTap;

  const _ActionCard({
    required this.title,
    required this.items,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.dark,
            ),
          ),
          const SizedBox(height: 12),
          ...items.map(
            (item) => GestureDetector(
              onTap: () => onItemTap(item),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    const Icon(Icons.circle, size: 8, color: AppColors.orange),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item['title'] as String,
                        style: const TextStyle(color: AppColors.navy),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}