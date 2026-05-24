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

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      AdminDashboardScreen(onNavigate: _setIndex),
      RoutesScreen(),
      const AboutMuseumScreen(),
      const VisitorsScreen(),
      FeedbackScreen(),
    ];
  }

  void _setIndex(int index) {
    setState(() {
      _index = index;
    });
  }

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
          backgroundColor: AppColors.dark,
          indicatorColor: AppColors.blue.withOpacity(0.16),
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.lightGrey,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (value) => setState(() => _index = value),
          destinations: const [
            NavigationDestination(
              icon: ImageIcon(
                AssetImage('assets/icons/dashboard.png'),
                color: AppColors.blue,
              ),
              label: 'Дашборд',
            ),
            NavigationDestination(
              icon: ImageIcon(
                AssetImage('assets/icons/itinerary.png'),
                color: AppColors.blue,
              ),
              label: 'Маршруты',
            ),
            NavigationDestination(
              icon: Icon(Icons.museum_outlined, color: AppColors.blue),
              label: 'О музее',
            ),
            NavigationDestination(
              icon: Icon(Icons.groups_outlined, color: AppColors.blue),
              label: 'Посетители',
            ),
            NavigationDestination(
              icon: Icon(Icons.rate_review_outlined, color: AppColors.blue),
              label: 'Отзывы',
            ),
          ],
        ),
      ),
    );
  }
}
