class CurrentUser {
  static UserModel? _user;

  static UserModel get user => _user!;
  static bool get isLoggedIn => _user != null;

  static void setUser(UserModel user) {
    _user = user;
  }

  static UserModel? getUser() {
    return _user;
  }

  static bool isAuthenticated() {
    return _user != null;
  }

  static void clearUser() {
    _user = null;
  }
}

class UserModel {
  String id;
  String name;
  String? phone;
  String? bio;
  String? image;
  String? country;
  String? status;
  DateTime? lastLoginAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  UserModel({
    required this.id,
    required this.name,
    this.phone,
    this.bio,
    this.image,
    this.country,
    this.status,
    this.lastLoginAt,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  /// Computed getters
  bool get hasPhone => phone != null && phone!.trim().isNotEmpty;
  bool get isProfileComplete => name.trim().length >= 2;

  /// Constructor for initializing from JSON
  UserModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        name = json['name'] as String,
        phone = json['phone'] as String?,
        bio = json['bio'] as String?,
        image = json['image'] as String?,
        country = json['country'] as String?,
        status = json['status'] as String?,
        lastLoginAt = json['last_login_at'] != null
            ? DateTime.parse(json['last_login_at'] as String)
            : null,
        createdAt = json['created_at'] != null
            ? DateTime.parse(json['created_at'] as String)
            : null,
        updatedAt = json['updated_at'] != null
            ? DateTime.parse(json['updated_at'] as String)
            : null,
        deletedAt = json['deleted_at'] != null
            ? DateTime.parse(json['deleted_at'] as String)
            : null;

  /// Method to convert the object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'bio': bio,
      'image': image,
      'country': country,
      'status': status,
      'last_login_at': lastLoginAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  /// Method to convert the object to JSON (alias for toMap)
  Map<String, dynamic> toJson() => toMap();

  /// Copy with method
  UserModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? bio,
    String? image,
    String? country,
    String? status,
    DateTime? lastLoginAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
      image: image ?? this.image,
      country: country ?? this.country,
      status: status ?? this.status,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
