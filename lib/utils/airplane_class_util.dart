enum AirplaneClass { economy, business, first, executive }

class AirplaneClassUtil {
  static const Map<AirplaneClass, String> _airplaneClass = {
    AirplaneClass.economy: "economy",
    AirplaneClass.business: "business",
    AirplaneClass.first: "first",
    AirplaneClass.executive: "executive"
  };

  static AirplaneClass classFromString(String value) {
    return AirplaneClass.values.firstWhere((e) => _airplaneClass[e] == value);
  }

  static String stringFromClass(AirplaneClass value) {
    return _airplaneClass[value]!;
  }
}
