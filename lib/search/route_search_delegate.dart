import 'package:flutter/material.dart';
import 'package:itinerary_app/disign/colors.dart';

class RouteSearchDelegate extends SearchDelegate<String?> {
  final List<Map<String, dynamic>> routesList;

  RouteSearchDelegate(this.routesList);

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: AppBarTheme(
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        backgroundColor: AppColors.dark,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
    );
  }

  @override
  TextStyle? get searchFieldStyle =>
      const TextStyle(color: AppColors.lightGrey, fontSize: 15);

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
      icon: Image.asset('assets/icons/back.png', height: 24, width: 24),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final filteredRoutes = query.isEmpty
        ? routesList
        : routesList
              .where(
                (route) => route['title'].toString().toLowerCase().contains(
                  query.toLowerCase(),
                ),
              )
              .toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredRoutes.length,
      itemBuilder: (context, index) {
        final route = filteredRoutes[index];
        return _buildSimpleListTile(route, context);
      },
    );
  }

  Widget _buildSimpleListTile(
    Map<String, dynamic> route,
    BuildContext context,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.lightGrey.withOpacity(0.3),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
        color: AppColors.dark.withOpacity(0.1),
      ),
      child: ListTile(
        title: Text(
          route['title'],
          style: const TextStyle(
            color: AppColors.navy,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          route['price'] ?? '',
          style: TextStyle(color: AppColors.navy, fontSize: 14),
        ),
        onTap: () {
          close(context, route['title']);
        },
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }
}
