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
}
