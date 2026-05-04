import 'package:flutter/material.dart';
import 'disign/colors.dart'; // Подключаем твои цвета

class DetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteGrey,
      body: Column(
        children: [
          // Верхняя часть с картинкой
          Stack(
            children: [
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.navy,
                  image: DecorationImage(
                    image: NetworkImage(
                      //'https://via.placeholder.com/400x300',
                      'https://oboi-ma.ru/f/product/1407_3.jpg',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Кнопка назад
              Positioned(
                top: 40,
                left: 15,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: AppColors.blue),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ],
          ),

          // Контентная часть
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Звёзды Югры',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.dark,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.access_time, color: AppColors.blue),
                      SizedBox(width: 5),
                      Text('70 минут', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                  Divider(height: 30, color: AppColors.lightGrey),
                  Text(
                    'Мемориальные предметы, документы и фотографии выдающихся людей, внесших вклад в развитие нашего региона.',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.navy,
                      height: 1.4,
                    ),
                  ),
                  Text(
                    '  ',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.navy,
                      height: 1.4,
                    ),
                  ),
                  Text(
                    'В этой экскурсии:',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.navy,
                      height: 1.4,
                    ),
                  ),
                  Spacer(),
                  // Нижняя панель с ценой и кнопкой
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Итого: 249₽',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.dark,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.orange,
                          padding: EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Text(
                          'Купить',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
