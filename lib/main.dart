import 'package:flutter/material.dart';
import 'disign/colors.dart';
import 'details_screen.dart';
import 'search/route_search_delegate.dart';
import 'profile/profile_screen.dart';
import 'menu/menu_screen.dart';
import 'widgets/active_filters_chips.dart';
import 'widgets/route_filters_sheet.dart';

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
  int _currentTabIndex = 0;

  late final List<Map<String, dynamic>> routesList;

  String? selectedAudience;
  String? selectedDuration;

  @override
  void initState() {
    super.initState();
    routesList = [
      {
        'title': 'Звезды Югры',
        'price': '349₽',
        'isPopular': true,
        'seats': 15,
        'audience': 'Турист',
        'description': 'Экскурсия по местам силы Югры',
        'duration': '30 минут',
      },
      {
        'title': 'Звезды Югры',
        'price': '349₽',
        'isPopular': true,
        'seats': 12,
        'audience': 'Семейная',
        'description': 'Экскурсия по местам силы Югры',
        'duration': '~1.5 часа',
      },
      {
        'title': 'Звезды Югры',
        'price': '349₽',
        'isPopular': true,
        'seats': 20,
        'audience': 'Студенты',
        'description': 'Экскурсия по местам силы Югры',
        'duration': '30 минут',
      },
      {
        'title': 'Звезды Югры',
        'price': '349₽',
        'isPopular': true,
        'seats': 20,
        'audience': 'Студенты',
        'description': 'Экскурсия по местам силы Югры',
        'duration': '30 минут',
      },
    ];
  }

  List<Map<String, dynamic>> get filteredRoutes {
    return routesList.where((route) {
      final audienceOk =
          selectedAudience == null || route['audience'] == selectedAudience;

      final durationOk =
          selectedDuration == null || route['duration'] == selectedDuration;

      return audienceOk && durationOk;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentTabIndex == 0
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
                  const Flexible(
                    child: Text(
                      'Маршруты первого нефтяного',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.lightGrey,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.filter_list, color: AppColors.blue),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return RouteFiltersSheet(
                          selectedAudience: selectedAudience,
                          selectedDuration: selectedDuration,
                          onApply: (audience, duration) {
                            setState(() {
                              selectedAudience = audience;
                              selectedDuration = duration;
                            });
                            Navigator.pop(context);
                          },
                        );
                      },
                    );
                  },
                ),
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
          : null,
      body: _currentTabIndex == 0
          ? Column(
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
                ActiveFiltersChips(
                  selectedAudience: selectedAudience,
                  selectedDuration: selectedDuration,
                  onAudienceSelected: (value) {
                    setState(() => selectedAudience = value);
                  },
                  onDurationSelected: (value) {
                    setState(() => selectedDuration = value);
                  },
                  onClearAll: () {
                    setState(() {
                      selectedAudience = null;
                      selectedDuration = null;
                    });
                  },
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredRoutes.length,
                    itemBuilder: (context, index) {
                      final route = filteredRoutes[index];
                      return Column(
                        children: [
                          _buildRouteCard(context, route: route),
                          if (index < filteredRoutes.length - 1)
                            const SizedBox(height: 16),
                        ],
                      );
                    },
                  ),
                ),
              ],
            )
          : _currentTabIndex == 1
          ? const ProfileScreen()
          : const MenuScreen(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.dark,
        selectedItemColor: AppColors.blue,
        unselectedItemColor: AppColors.lightGrey,
        currentIndex: _currentTabIndex,
        onTap: (index) {
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

  Widget _buildRouteCard(
    BuildContext context, {
    required Map<String, dynamic> route,
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
              child: Image.network(
                'https://oboi-ma.ru/f/product/1407_3.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          route['title'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          route['price'],
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.navy,
                          ),
                        ),
                        if (route['isPopular'])
                          const Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Text(
                              '#часто посещают',
                              style: TextStyle(
                                color: AppColors.orange,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    child: ElevatedButton(
                      onPressed: () => _showBookingBottomSheet(context, route),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                      ),
                      child: const Text(
                        'Купить',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
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

  void _showBookingBottomSheet(
    BuildContext context,
    Map<String, dynamic> route,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      route['title'],
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, size: 28),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Мест доступно: ${route['seats']}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('Аудитория: ${route['audience']}'),
                      Text('Длительность: ${route['duration']}'),
                      Text('Стоимость: ${route['price']}'),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Бронь ${route['title']} оформлена! 💳',
                          ),
                          backgroundColor: AppColors.orange,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      'Оформить бронь ${route['price']}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
