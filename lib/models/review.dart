class Review {
  String id;
  String user;
  String place;
  double rating;
  String review;
  bool haveUpdated;
  DateTime createdAt;

  Review({
    required this.id,
    required this.user,
    required this.place,
    required this.rating,
    required this.review,
    required this.haveUpdated,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    if (json["user"] is Map) {
      json["user"] = json["user"]["name"];
    }
    return Review(
      id: json["_id"],
      user: json["user"],
      place: json["place"],
      rating: double.tryParse(json["rating"].toString()) ?? 0,
      review: json["review"],
      haveUpdated: json["haveUpdated"],
      createdAt: DateTime.parse(json["createdAt"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "user": user,
      "place": place,
      "rating": rating,
      "review": review,
      "haveUpdated": haveUpdated,
      "createdAt": createdAt,
    };
  }
}
