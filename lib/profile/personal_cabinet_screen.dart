import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../disign/colors.dart';
import 'review_bottom_sheet.dart';
import 'purchased_route_screen.dart';

class PersonalCabinetScreen extends StatefulWidget {
  final VoidCallback? onLogout;

  const PersonalCabinetScreen({super.key, this.onLogout});

  @override
  State<PersonalCabinetScreen> createState() => _PersonalCabinetScreenState();
}

class _PersonalCabinetScreenState extends State<PersonalCabinetScreen> {
  final List<Map<String, dynamic>> _purchases = [
    {'id': 1, 'title': 'Звезды Югры', 'price': '349₽', 'completed': false},
    {
      'id': 2,
      'title': 'Маршрут по Ханты-Мансийску',
      'price': '499₽',
      'completed': true,
    },
    {'id': 3, 'title': 'Тур по Сургуту', 'price': '599₽', 'completed': false},
  ];

  List<RouteStep> _demoStepsFor(String title) {
    return [
      RouteStep(
        type: 'guide',
        title: '$title ',
        description: 'Идите прямо к первому залу и поверните направо.',
        imageUrl: 'https://oboi-ma.ru/f/product/1407_3.jpg',
      ),
      RouteStep(
        type: 'exhibit',
        title: '$title',
        description:
            'Здесь отображается подробная информация об экспонате маршрута.',
        imageUrl:
            'https://i.pinimg.com/1200x/70/83/62/7083628471bd31dbd826d6640d8b2429.jpg',
      ),
      RouteStep(
        type: 'guide',
        title: '$title ',
        description: 'Продолжайте движение к следующей точке маршрута.',
        imageUrl: 'https://oboi-ma.ru/f/product/1407_3.jpg',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final user = auth.currentUser;
    final bottomBarHeight = kBottomNavigationBarHeight;

    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: bottomBarHeight + 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 72,
                    width: 72,
                    decoration: const BoxDecoration(
                      color: AppColors.navy,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? 'Гость',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.dark,
                          ),
                        ),
                        Text(
                          user?.email ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.navy,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const Text(
                'Мои покупки',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.dark,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: _purchases.length,
                  itemBuilder: (context, index) {
                    final purchase = _purchases[index];
                    final completed = purchase['completed'] as bool;
                    final title = purchase['title'] as String;
                    final price = purchase['price'] as String;
                    final routeId = purchase['id'] as int;

                    return Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (!completed) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PurchasedRouteScreen(
                                    routeTitle: title,
                                    steps: _demoStepsFor(title),
                                  ),
                                ),
                              );
                            }
                          },
                          child: _buildPurchaseCard(title, price, completed),
                        ),
                        Positioned(
                          right: 8,
                          bottom: 8,
                          child: GestureDetector(
                            onTap: () {
                              final auth = Provider.of<AuthService>(
                                context,
                                listen: false,
                              );
                              final currentUser = auth.currentUser;
                              if (currentUser?.id != null) {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                  ),
                                  builder: (context) => ReviewBottomSheet(
                                    routeId: routeId,
                                    userId: currentUser!.id!,
                                    routeName: title,
                                  ),
                                );
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.orange,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.orange.withOpacity(0.4),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.rate_review_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () async {
                    final auth = Provider.of<AuthService>(
                      context,
                      listen: false,
                    );
                    await auth.logout();
                    widget.onLogout?.call();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.navy,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Выйти',
                    style: TextStyle(fontSize: 18, color: AppColors.lightGrey),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPurchaseCard(String title, String price, bool completed) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: completed ? Colors.grey[400] : AppColors.navy,
                shape: BoxShape.circle,
              ),
              child: Icon(
                completed ? Icons.check : Icons.play_arrow,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    price,
                    style: const TextStyle(fontSize: 16, color: AppColors.navy),
                  ),
                  Text(
                    completed ? 'Пройдено' : 'Не пройдено',
                    style: TextStyle(
                      color: completed ? Colors.grey[600] : AppColors.orange,
                      fontSize: 12,
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
