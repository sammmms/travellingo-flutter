import 'package:travellingo/models/review.dart';
import 'package:travellingo/utils/picture_type_util.dart';
import 'package:travellingo/utils/place_category_util.dart';

class Place {
  String id;
  String name;
  int price;
  String description;
  String city;
  String country;
  String pictureLink;
  PictureType pictureType;
  PlaceCategory category;
  List<Review> reviews;
  double reviewAverage;

  Place(
      {required this.id,
      required this.name,
      required this.price,
      required this.description,
      required this.city,
      required this.country,
      required this.pictureLink,
      required this.pictureType,
      required this.category,
      required this.reviews,
      required this.reviewAverage});

  factory Place.fromJson(Map<String, dynamic> json) {
    List? jsonReview = json["reviews"];

    late List<Review> reviews;
    if (jsonReview != null) {
      reviews = jsonReview.map((e) => Review.fromJson(e)).toList();
    }

    return Place(
      id: json["_id"],
      name: json["name"],
      price: json['price'],
      description: json["description"],
      city: json["city"],
      country: json["country"],
      pictureLink: json["pictureLink"],
      pictureType: PictureTypeUtil.typeOf(json["pictureType"]),
      category: PlaceCategoryUtil.categoryOf(json["type"]),
      reviews: reviews,
      reviewAverage: double.tryParse(json["reviewAverage"].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "name": name,
      "price": price,
      "description": description,
      "city": city,
      "country": country,
      "pictureLink": pictureLink,
      "pictureType": PictureTypeUtil.stringOf(pictureType),
      "type": PlaceCategoryUtil.stringOf(category),
      if (reviews.isNotEmpty)
        "reviews": reviews.map((e) => e.toJson()).toList(),
    };
  }
}
