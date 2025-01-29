class CurrentUser {
  static UserModel? user;

  static void setUser(UserModel userModel) {
    user = userModel;
  }

  static UserModel? getUser() {
    return user;
  }
}

class UserModel {
  String uId;
  String name;
  String email;
  String? phone;
  String? country;
  String? image;
  String? bio;
  bool isEmailVerified;

  UserModel({
    required this.uId,
    required this.name,
    required this.email,
    this.phone,
    this.image,
    this.country,
    this.bio,
    this.isEmailVerified = false,
  });

  // Constructor for initializing from JSON
  UserModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'],
        phone = json['phone'],
        uId = json['uId'],
        image = json['image'],
        country = json['country'],
        bio = json['bio'],
        isEmailVerified = json['isEmailVerified'] ?? false;

  // Method to convert the object to a Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'uId': uId,
      'image': image,
      "country": country,
      'bio': bio,
      'isEmailVerified': isEmailVerified,
    };
  }
}
