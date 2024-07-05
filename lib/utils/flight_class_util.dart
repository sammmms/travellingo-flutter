enum FlightClass {
  all,
  economy,
  business,
  first,
  executive,
}

class FlightClassUtil {
  static const Map<FlightClass, String> _airplaneClass = {
    FlightClass.economy: "economy",
    FlightClass.business: "business",
    FlightClass.first: "first",
    FlightClass.executive: "executive",
    FlightClass.all: "all"
  };

  static FlightClass classFromString(String value) {
    return FlightClass.values
        .firstWhere((e) => _airplaneClass[e] == value.toLowerCase());
  }

  static String stringFromClass(FlightClass value) {
    return _airplaneClass[value]!;
  }
}
