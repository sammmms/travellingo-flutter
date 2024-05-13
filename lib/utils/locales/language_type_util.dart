enum LanguageType { id, en }

class LanguageTypeUtil {
  final Map<LanguageType, String> _map = {
    LanguageType.id: "id",
    LanguageType.en: "en"
  };

  String statusTextOf(LanguageType choice) {
    return _map[choice] ?? "id";
  }

  LanguageType typeOf(String string) {
    Map<String, LanguageType> reversedMap =
        _map.map((key, value) => MapEntry(value, key));
    return reversedMap[string] ?? LanguageType.id;
  }
}
