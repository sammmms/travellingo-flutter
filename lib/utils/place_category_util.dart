enum PlaceCategory { hotel, restaurant, attraction, zoo, all }

class PlaceCategoryUtil {
  static const Map<PlaceCategory, String> _placeCategoryMap = {
    PlaceCategory.hotel: 'Hotel',
    PlaceCategory.restaurant: 'Restaurant',
    PlaceCategory.attraction: 'Attraction',
    PlaceCategory.zoo: 'Zoo',
    PlaceCategory.all: 'All'
  };

  static String stringOf(PlaceCategory placeCategory) {
    return _placeCategoryMap[placeCategory]!.toLowerCase();
  }

  static PlaceCategory categoryOf(String placeCategory) {
    return _placeCategoryMap.entries
        .firstWhere((element) => element.value.toLowerCase() == placeCategory)
        .key;
  }

  static String readCategory(PlaceCategory placeCategory) {
    return _placeCategoryMap[placeCategory]!;
  }
}
