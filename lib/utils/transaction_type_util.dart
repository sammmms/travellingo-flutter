enum TransactionType { all, flight, place }

class TransactionTypeUtil {
  static const Map<TransactionType, String> typeMap = {
    TransactionType.all: "all",
    TransactionType.flight: "flight",
    TransactionType.place: "place",
  };

  static TransactionType fromString(String type) {
    return typeMap.keys.firstWhere((element) => typeMap[element] == type);
  }

  static String textOf(TransactionType type) {
    return typeMap[type]!;
  }
}
