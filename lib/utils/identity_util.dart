enum IdentityType {
  idCard,
  passport,
  driverLicense,
}

class IdentityTypeUtil {
  static const Map<IdentityType, String> identityType = {
    IdentityType.idCard: "ID Card",
    IdentityType.passport: "Passport",
    IdentityType.driverLicense: "Driver License",
  };

  static IdentityType fromString(String value) {
    return identityType.entries
        .firstWhere((element) => element.value == value)
        .key;
  }

  static String getString(IdentityType value) {
    return identityType[value]!;
  }
}
