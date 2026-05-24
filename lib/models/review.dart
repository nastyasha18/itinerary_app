class Review {
  final int? id;
  final int userId;
  final int routeId;
  final int rating;
  final String comment;
  final List<String> quickOptions;
  final DateTime createdAt;
  final String? adminReply;

  Review({
    this.id,
    required this.userId,
    required this.routeId,
    required this.rating,
    required this.comment,
    required this.quickOptions,
    required this.createdAt,
    this.adminReply,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'route_id': routeId,
      'rating': rating,
      'comment': comment,
      'quick_options': quickOptions.join(','),
      'created_at': createdAt.toIso8601String(),
      'admin_reply': adminReply,
    };
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['id'],
      userId: map['user_id'],
      routeId: map['route_id'],
      rating: map['rating'],
      comment: map['comment'],
      quickOptions: (map['quick_options'] as String?)?.split(',').where((s) => s.isNotEmpty).toList() ?? [],
      createdAt: DateTime.parse(map['created_at']),
      adminReply: map['admin_reply'],
    );
  }
}