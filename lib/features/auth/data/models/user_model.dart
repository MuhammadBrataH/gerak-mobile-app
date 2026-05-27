class UserModel {
  final String id;
  final String email;
  final String name;
  final String phone;
  final List<String> sports;
  final String level;
  final String accountType;
  final String? photoUrl;
  final String? refreshTokenHash;
  final String? gender;
  final DateTime? dateOfBirth;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.sports,
    required this.level,
    required this.accountType,
    this.photoUrl,
    this.refreshTokenHash,
    this.gender,
    this.dateOfBirth,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final email = (json['email'] ?? '').toString();
    final name = (json['name'] ?? '').toString();
    return UserModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      email: email,
      name: name,
      phone: (json['phone'] ?? '').toString(),
      sports: _stringList(json['sports']),
      level: (json['level'] ?? '').toString(),
      accountType: _resolveAccountType(json['accountType'], name, email),
      photoUrl: json['photoUrl']?.toString(),
      refreshTokenHash: json['refreshTokenHash']?.toString(),
      gender: json['gender']?.toString(),
      dateOfBirth: _parseDate(json['dateOfBirth']),
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
      'accountType': accountType,
      'photoUrl': photoUrl,
      'refreshTokenHash': refreshTokenHash,
      'gender': gender,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
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

  static String _resolveAccountType(dynamic value, String name, String email) {
    final String accountType = value == null ? '' : value.toString();
    if (accountType == 'personal' || accountType == 'community') {
      return accountType;
    }

    final haystack = '$name $email'.toLowerCase();
    const communityKeywords = ['xtc', 'polban', 'usf'];
    return communityKeywords.any((keyword) => haystack.contains(keyword))
        ? 'community'
        : 'personal';
  }
}
