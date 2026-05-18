class RatingModel {
  final String id;
  final String eventId;
  final String userId;
  final int score;
  final String? review;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const RatingModel({
    required this.id,
    required this.eventId,
    required this.userId,
    required this.score,
    this.review,
    this.createdAt,
    this.updatedAt,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      id: _extractId(json['_id'], json['id']),
      eventId: _extractId(json['eventId'], null),
      userId: _extractId(json['userId'], null),
      score: _toInt(json['score']) ?? 0,
      review: json['review']?.toString(),
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventId': eventId,
      'userId': userId,
      'score': score,
      'review': review,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  static String _extractId(dynamic value, dynamic fallback) {
    final resolved = value ?? fallback;
    if (resolved is Map) {
      final mapId = resolved['_id'] ?? resolved['id'];
      return mapId?.toString() ?? '';
    }
    return resolved?.toString() ?? '';
  }

  static DateTime? _parseDate(dynamic value) {
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  static int? _toInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }
}
