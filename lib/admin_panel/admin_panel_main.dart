import 'package:flutter/material.dart';
import '/disign/colors.dart';
import '/admin_panel/screens/admin_dashboard_screen.dart';
import '/admin_panel/screens/routes_screen.dart';
import '/admin_panel/screens/about_museum_screen.dart';
import '/admin_panel/screens/visitors_screen.dart';
import '/admin_panel/screens/feedback_screen.dart';

class AdminPanelMain extends StatefulWidget {
  const AdminPanelMain({super.key});

  @override
  State<AdminPanelMain> createState() => _AdminPanelMainState();
}

class _AdminPanelMainState extends State<AdminPanelMain> {
  int _index = 0;

  final _screens = const [
    AdminDashboardScreen(),
    RoutesScreen(),
    AboutMuseumScreen(),
    VisitorsScreen(),
    FeedbackScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
        title: const Text('Админ-панель'),
        centerTitle: true,
      ),
      body: _screens[_index],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: AppColors.orange.withOpacity(0.16),
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (value) => setState(() => _index = value),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard),
              label: 'Дашборд',
            ),
            NavigationDestination(
              icon: Icon(Icons.route_outlined),
              selectedIcon: Icon(Icons.route),
              label: 'Маршруты',
            ),
            NavigationDestination(
              icon: Icon(Icons.museum_outlined),
              selectedIcon: Icon(Icons.museum),
              label: 'О музее',
            ),
            NavigationDestination(
              icon: Icon(Icons.groups_outlined),
              selectedIcon: Icon(Icons.groups),
              label: 'Посетители',
            ),
            NavigationDestination(
              icon: Icon(Icons.rate_review_outlined),
              selectedIcon: Icon(Icons.rate_review),
              label: 'Отзывы',
            ),
          ],
        ),
      ),
    );
  }
}
