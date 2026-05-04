import 'package:flutter/material.dart';
import 'dart:ui'; // Для эффекта размытия (BackdropFilter)
import 'disign/colors.dart';

class DetailsScreen extends StatelessWidget {
  final List<Map<String, String>> exhibits = [
    {
      'name': 'Экспонат 1',
      'image':
          'https://i.pinimg.com/1200x/70/83/62/7083628471bd31dbd826d6640d8b2429.jpg',
    },
    {
      'name': 'Экспонат 2 ',
      'image':
          'https://i.pinimg.com/1200x/43/4d/57/434d578b2acd85cb44d311ebe181beab.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteGrey,
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.navy,
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://oboi-ma.ru/f/product/1407_3.jpg',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 40,
                left: 15,
                child: CircleAvatar(
                  backgroundColor: AppColors.whiteGrey,
                  child: IconButton(
                    icon: Image.asset(
                      'assets/icons/back.png', // Ваша иконка "назад"
                      height: 24,
                      width: 24,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: SingleChildScrollView(
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
                        Text(
                          '70 минут',
                          style: TextStyle(color: AppColors.navy),
                        ),
                      ],
                    ),
                    Divider(height: 30, color: AppColors.lightGrey),
                    Text(
                      'Мемориальные предметы, документы и фотографии выдающихся людей.',
                      style: TextStyle(fontSize: 16, color: AppColors.dark),
                    ),
                    Divider(height: 30),
                    Text(
                      'В этой экскурсии:',
                      style: TextStyle(
                        fontSize: 18,
                        //fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15),
                    ...exhibits.asMap().entries.map((entry) {
                      return ExhibitTimelineItem(
                        imageUrl: entry.value['image']!,
                        title: entry.value['name']!,
                        isLast: entry.key == exhibits.length - 1,
                      );
                    }).toList(),
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

class ExhibitTimelineItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final bool isLast;

  const ExhibitTimelineItem({
    required this.imageUrl,
    required this.title,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            GestureDetector(
              onTap: () => _openFullImage(context, imageUrl),
              // Кружочек с оранжевым контуром
              child: Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.orange, width: 3),
                ),
                padding: EdgeInsets.all(3),
                child: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: AppColors.orange,
                margin: EdgeInsets.symmetric(vertical: 5),
              ),
          ],
        ),
        SizedBox(width: 15),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 15),
            child: Text(
              title,
              style: TextStyle(fontSize: 16, color: AppColors.dark),
            ),
          ),
        ),
      ],
    );
  }

  void _openFullImage(BuildContext context, String url) {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false, // Прозрачность экрана
        pageBuilder: (_, __, ___) => Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              // Размытый фон
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(color: Colors.black.withOpacity(0.4)),
              ),
              // Само фото
              Center(child: InteractiveViewer(child: Image.network(url))),
              // Кнопка закрытия
              Positioned(
                top: 50,
                right: 20,
                child: IconButton(
                  icon: const Icon(Icons.clear),
                  color: AppColors.blue,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
