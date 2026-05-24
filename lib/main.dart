import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'disign/colors.dart';
import 'details_screen.dart';
import 'search/route_search_delegate.dart';
import 'profile/profile_screen.dart';
import 'menu/menu_screen.dart';
import 'widgets/active_filters_chips.dart';
import 'widgets/route_filters_sheet.dart';
import 'services/auth_service.dart';
import 'database/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await DatabaseHelper.startSqlInspector();
  runApp(const IniteraryApp());
}

class IniteraryApp extends StatelessWidget {
  const IniteraryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: MaterialApp(
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
      ),
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
  List<Map<String, dynamic>> _routes = [];
  bool _isLoading = true;
  final Set<String> selectedFilters = {};

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

  List<Map<String, dynamic>> get filteredRoutes {
    if (selectedFilters.isEmpty) return _routes;
    return _routes.where((route) {
      final audience = route['audience'] as String? ?? '';
      final duration = route['duration'] as String? ?? '';

      final audienceFilters = {'Студенты', 'Семейная', 'Турист'};
      final durationFilters = {'30 минут', '~1.5 часа'};

      final selectedAudienceFilters = selectedFilters.intersection(
        audienceFilters,
      );
      final selectedDurationFilters = selectedFilters.intersection(
        durationFilters,
      );

      final audienceOk =
          selectedAudienceFilters.isEmpty ||
          selectedAudienceFilters.contains(audience);
      final durationOk =
          selectedDurationFilters.isEmpty ||
          selectedDurationFilters.contains(duration);
      return audienceOk && durationOk;
    }).toList();
  }

  void _toggleFilter(String filter) {
    setState(() {
      if (selectedFilters.contains(filter)) {
        selectedFilters.remove(filter);
      } else {
        selectedFilters.add(filter);
      }
    });
  }

  void _clearAllFilters() {
    setState(() => selectedFilters.clear());
  }

  void _applyFilters(Set<String> newFilters) {
    setState(() {
      selectedFilters.clear();
      selectedFilters.addAll(newFilters);
    });
  }

  // Вызывается после возврата из админ-панели, чтобы обновить список маршрутов
  Future<void> _refreshRoutes() async {
    await _loadRoutes();
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
                      builder: (context) => RouteFiltersSheet(
                        selectedFilters: selectedFilters,
                        onApply: _applyFilters,
                        onClearAll: _clearAllFilters,
                      ),
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
                      delegate: RouteSearchDelegate(
                        _routes,
                      ), // передаём актуальный список
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
          ? _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
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
                        selectedFilters: selectedFilters,
                        onToggleFilter: _toggleFilter,
                        onClearAll: _clearAllFilters,
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
        onTap: (index) async {
          if (index == 0) {
            // если переключаемся на вкладку маршрутов, обновляем список (на случай изменений в админке)
            await _refreshRoutes();
          }
          setState(() {
            _currentTabIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/itinerary.png')),
            label: 'Маршруты',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/profile.png')),
            label: 'Мой профиль',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/menu.png')),
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
          MaterialPageRoute(
            builder: (context) => DetailsScreen(routeId: route['id']),
          ),
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
                route['imageUrl'] ?? 'https://oboi-ma.ru/f/product/1407_3.jpg',
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
                          route['title'] ?? '',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          route['price'] ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.navy,
                          ),
                        ),
                        if (route['isPopular'] == 1)
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
                      route['title'] ?? '',
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
                        'Мест доступно: ${route['seats'] ?? 10}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('Аудитория: ${route['audience'] ?? ''}'),
                      Text('Длительность: ${route['duration'] ?? ''}'),
                      Text('Стоимость: ${route['price'] ?? ''}'),
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
