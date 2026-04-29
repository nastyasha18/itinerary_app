import 'package:flutter/material.dart';
import 'disign/colors.dart';
import 'details_screen.dart';
import 'search/route_search_delegate.dart';
import 'profile/profile_screen.dart'; // ← ИСПРАВЛЕН ИМПОРТ (убрал itnerary_app/)

void main() {
  runApp(const IniteraryApp());
}

class IniteraryApp extends StatelessWidget {
  const IniteraryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Initerary App',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.lightGrey,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.navy,
          elevation: 0,
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentTabIndex = 0; // ← НОВОЕ: индекс текущего таба
  late final List<Map<String, dynamic>> routesList;

  @override
  void initState() {
    super.initState();
    routesList = [
      {'title': 'Звезды Югры', 'price': '349₽', 'isPopular': true},
      {'title': 'Звезды Югры', 'price': '349₽', 'isPopular': true},
      {'title': 'Звезды Югры', 'price': '349₽', 'isPopular': true},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          _currentTabIndex ==
              0 // ← AppBar только для таба "Маршруты"
          ? AppBar(
              title: Row(
                children: [
                  Image.asset(
                    'assets/icons/logo.png',
                    height: 24,
                    width: 24,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Маршруты первого нефтяного',
                    style: TextStyle(fontSize: 16, color: AppColors.lightGrey),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: Image.asset(
                    'assets/icons/search.png',
                    height: 24,
                    width: 24,
                  ),
                  onPressed: () async {
                    final result = await showSearch<String?>(
                      context: context,
                      delegate: RouteSearchDelegate(routesList),
                    );
                    if (result != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Выбран маршрут: $result')),
                      );
                    }
                  },
                ),
              ],
            )
          : null, // ← Нет AppBar для профиля
      body: _currentTabIndex == 0
          ? Column(
              // ← Таб 0: Маршруты (ваш код без изменений)
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Маршруты',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.dark,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: routesList.length,
                    itemBuilder: (context, index) {
                      final route = routesList[index];
                      return Column(
                        children: [
                          _buildRouteCard(
                            context,
                            title: route['title'],
                            price: route['price'],
                            isPopular: route['isPopular'],
                          ),
                          if (index < routesList.length - 1)
                            const SizedBox(height: 16),
                        ],
                      );
                    },
                  ),
                ),
              ],
            )
          : const ProfileScreen(), // ← Таб 1: Профиль
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.dark,
        selectedItemColor: AppColors.blue,
        unselectedItemColor: AppColors.lightGrey,
        currentIndex: _currentTabIndex,
        onTap: (index) {
          // ← ЛОГИКА ПЕРЕКЛЮЧЕНИЯ ТАБОВ
          setState(() {
            _currentTabIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/itinerary.png',
              height: 24,
              width: 24,
            ),
            label: 'Маршруты',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/profile.png',
              height: 24,
              width: 24,
            ),
            label: 'Мой профиль',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/menu.png', height: 24, width: 24),
            label: 'Меню',
          ),
        ],
      ),
    );
  }

  // ← _buildRouteCard БЕЗ ИЗМЕНЕНИЙ
  Widget _buildRouteCard(
    BuildContext context, {
    required String title,
    required String price,
    required bool isPopular,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailsScreen()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 160,
              decoration: const BoxDecoration(
                color: AppColors.navy,
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              ),
              child: const Center(
                child: Icon(Icons.landscape, color: Colors.white, size: 50),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        price,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.navy,
                        ),
                      ),
                      if (isPopular)
                        const Text(
                          '#часто посещают',
                          style: TextStyle(
                            color: AppColors.orange,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Купить',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
