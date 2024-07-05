enum FlightClass { economy, business, first, executive, all }

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

  static String readableStringFromClass(FlightClass value) {
    switch (value) {
      case FlightClass.economy:
        return "Economy";
      case FlightClass.business:
        return "Business";
      case FlightClass.first:
        return "First";
      case FlightClass.executive:
        return "Executive";
      case FlightClass.all:
        return "All";
    }
  }
}
