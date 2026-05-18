class UserModel {
  final String id;
  final String email;
  final String name;
  final String phone;
  final List<String> sports;
  final String level;
  final String? photoUrl;
  final String? refreshTokenHash;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.sports,
    required this.level,
    this.photoUrl,
    this.refreshTokenHash,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
      sports: _stringList(json['sports']),
      level: (json['level'] ?? '').toString(),
      photoUrl: json['photoUrl']?.toString(),
      refreshTokenHash: json['refreshTokenHash']?.toString(),
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'sports': sports,
      'level': level,
      'photoUrl': photoUrl,
      'refreshTokenHash': refreshTokenHash,
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
}
