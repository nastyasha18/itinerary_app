import 'package:flutter/material.dart';
import 'package:itinerary_app/disign/colors.dart';

class RouteSearchDelegate extends SearchDelegate<String?> {
  final List<Map<String, dynamic>> routesList;

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: AppBarTheme(
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        backgroundColor: AppColors.dark, // Ваши цвета
        iconTheme: const IconThemeData(color: Colors.white),
      ),
    );
  }

  @override
  TextStyle? get searchFieldStyle => const TextStyle(
    color: AppColors.lightGrey, // Цвет вводимого текста
    fontSize: 15, // Размер шрифта
  );
  RouteSearchDelegate(this.routesList);

  @override
  List<Widget> buildActions(BuildContext context) => [
    IconButton(
      icon: const Icon(Icons.clear),
      color: AppColors.blue,
      onPressed: () => query = '',
    ),
  ];

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Image.asset(
        'assets/icons/back.png', // Ваша иконка "назад"
        height: 24,
        width: 24,
      ),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = routesList
        .where(
          (route) => route['title'].toString().toLowerCase().contains(
            query.toLowerCase(),
          ),
        )
        .toList();
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, i) => ListTile(
        leading: const Icon(Icons.route),
        title: Text(results[i]['title']),
        subtitle: Text(results[i]['price']),
        trailing: results[i]['isPopular']
            ? const Icon(Icons.star, color: Colors.amber)
            : null,
        onTap: () => close(context, results[i]['title']),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = routesList
        .where(
          (route) => route['title'].toString().toLowerCase().startsWith(
            query.toLowerCase(),
          ),
        )
        .toList();
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, i) => ListTile(
        title: Text(suggestions[i]['title']),
        onTap: () {
          query = suggestions[i]['title'];
          showResults(context);
        },
      ),
    );
  }
}
