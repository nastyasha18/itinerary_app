import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:itinerary_app/disign/colors.dart';
import 'package:itinerary_app/database/database_helper.dart';

class DetailsScreen extends StatefulWidget {
  final int routeId;
  const DetailsScreen({super.key, required this.routeId});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  Map<String, dynamic>? _route;
  List<Map<String, dynamic>> _points = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final db = DatabaseHelper();
    final route = await db.getRouteById(widget.routeId);
    final points = await db.getRoutePoints(widget.routeId);
    setState(() {
      _route = route;
      _points = points;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.whiteGrey,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_route == null) {
      return Scaffold(
        backgroundColor: AppColors.whiteGrey,
        body: const Center(child: Text('Маршрут не найден')),
      );
    }

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
                    image: NetworkImage(_route!['imageUrl'] ?? 'https://oboi-ma.ru/f/product/1407_3.jpg'),
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
                    icon: Image.asset('assets/icons/back.png', height: 24, width: 24),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _route!['title'] ?? '',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.dark),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.access_time, color: AppColors.blue),
                        const SizedBox(width: 5),
                        Text(_route!['duration'] ?? '', style: const TextStyle(color: AppColors.navy)),
                      ],
                    ),
                    Divider(height: 30, color: AppColors.lightGrey),
                    Text(
                      _route!['description'] ?? '',
                      style: const TextStyle(fontSize: 16, color: AppColors.dark),
                    ),
                    const Divider(height: 30),
                    const Text(
                      'В этой экскурсии:',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 15),
                    ..._points.asMap().entries.map((entry) {
                      final point = entry.value;
                      return ExhibitTimelineItem(
                        imageUrl: 'https://i.pinimg.com/1200x/70/83/62/7083628471bd31dbd826d6640d8b2429.jpg', // заглушка
                        title: point['name'] ?? '',
                        isLast: entry.key == _points.length - 1,
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
    super.key,
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
              child: Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.orange, width: 3),
                ),
                padding: const EdgeInsets.all(3),
                child: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: AppColors.orange,
                margin: const EdgeInsets.symmetric(vertical: 5),
              ),
          ],
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Text(title, style: const TextStyle(fontSize: 16, color: AppColors.dark)),
          ),
        ),
      ],
    );
  }

  void _openFullImage(BuildContext context, String url) {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) => Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(color: Colors.black.withOpacity(0.4)),
              ),
              Center(child: InteractiveViewer(child: Image.network(url))),
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