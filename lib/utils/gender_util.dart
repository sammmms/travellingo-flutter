enum Gender { male, female, notSet }

class GenderUtil {
  final Map<Gender, String> _map = {
    Gender.male: "male",
    Gender.female: "female",
    Gender.notSet: '',
  };

  String statusTextOf(Gender choice) {
    return _map[choice] ?? "male";
  }

  Gender typeOf(String string) {
    Map<String, Gender> reversedMap =
        _map.map((key, value) => MapEntry(value, key));
    return reversedMap[string] ?? Gender.male;
  }
}
