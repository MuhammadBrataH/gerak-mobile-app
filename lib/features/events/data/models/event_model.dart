class EventModel {
  final String id;
  final String name;
  final String? description;
  final String sport;
  final String level;
  final DateTime? startTime;
  final DateTime? endTime;
  final String location;
  final String city;
  final String? district;
  final Map<String, dynamic>? coordinates;
  final int? maxSlots;
  final int? totalSlots;
  final List<String> joinedUsers;
  final String adminPhone;
  final String? imageUrl;
  final double? averageRating;
  final int? reviewCount;
  final String? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const EventModel({
    required this.id,
    required this.name,
    required this.sport,
    required this.level,
    required this.location,
    required this.city,
    required this.adminPhone,
    this.description,
    this.startTime,
    this.endTime,
    this.district,
    this.coordinates,
    this.maxSlots,
    this.totalSlots,
    this.joinedUsers = const <String>[],
    this.imageUrl,
    this.averageRating,
    this.reviewCount,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      description: json['description']?.toString(),
      sport: (json['sport'] ?? '').toString(),
      level: (json['level'] ?? '').toString(),
      startTime: _parseDate(json['startTime']),
      endTime: _parseDate(json['endTime']),
      location: (json['location'] ?? '').toString(),
      city: (json['city'] ?? '').toString(),
      district: json['district']?.toString(),
      coordinates: _mapValue(json['coordinates']),
      maxSlots: _toInt(json['maxSlots']),
      totalSlots: _toInt(json['totalSlots']),
      joinedUsers: _stringList(json['joinedUsers']),
      adminPhone: (json['adminPhone'] ?? '').toString(),
      imageUrl: json['imageUrl']?.toString(),
      averageRating: _toDouble(json['averageRating']),
      reviewCount: _toInt(json['reviewCount']),
      createdBy: json['createdBy']?.toString(),
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'sport': sport,
      'level': level,
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'location': location,
      'city': city,
      'district': district,
      'coordinates': coordinates,
      'maxSlots': maxSlots,
      'totalSlots': totalSlots,
      'joinedUsers': joinedUsers,
      'adminPhone': adminPhone,
      'imageUrl': imageUrl,
      'averageRating': averageRating,
      'reviewCount': reviewCount,
      'createdBy': createdBy,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  static List<String> _stringList(dynamic value) {
    if (value is List) {
      return value.map((item) => item.toString()).toList();
    }
    return <String>[];
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

  static double? _toDouble(dynamic value) {
    if (value is double) {
      return value;
    }
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }

  static Map<String, dynamic>? _mapValue(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return value.map((key, val) => MapEntry(key.toString(), val));
    }
    return null;
  }
}
