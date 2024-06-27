class User {
  final String objectId;
  String name;
  String email;
  String phone;
  DateTime birthday;
  String? gender;
  String? id;
  String? pictureLink;

  User(
      {required this.objectId,
      required this.name,
      required this.birthday,
      required this.email,
      required this.phone,
      this.gender,
      this.id,
      this.pictureLink});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      objectId: json["_id"],
      name: json["name"],
      email: json["email"],
      phone: json["phone"],
      birthday: DateTime.parse(json["birthday"]),
      gender: json["gender"] ?? "",
      id: json["id"] ?? "",
      pictureLink: json["pictureLink"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": objectId,
      "name": name,
      "email": email,
      "phone": phone,
      "birthday": birthday.toIso8601String(),
    };
  }

  User copyWith({
    String? objectId,
    String? name,
    String? email,
    String? phone,
    DateTime? birthday,
    String? gender,
    String? id,
    String? pictureLink,
  }) {
    return User(
      objectId: objectId ?? this.objectId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      birthday: birthday ?? this.birthday,
      gender: gender ?? this.gender,
      id: id ?? this.id,
      pictureLink: pictureLink ?? this.pictureLink,
    );
  }
}
