import 'package:travellingo/utils/identity_util.dart';

class Passenger {
  String identityNumber;
  String fullName;
  IdentityType identityType;
  String seat;

  Passenger({
    this.identityNumber = "",
    this.fullName = "",
    this.identityType = IdentityType.idCard,
    this.seat = "",
  });

  Map<String, dynamic> toJson() {
    return {
      'identityNumber': identityNumber,
      'fullName': fullName,
      'identityType': IdentityTypeUtil.getString(identityType),
      'seat': seat,
    };
  }

  factory Passenger.fromJson(Map<String, dynamic> json) {
    return Passenger(
      identityNumber: json['identityNumber'],
      fullName: json['fullName'],
      identityType: IdentityTypeUtil.fromString(json['identityType']),
      seat: json['seat'],
    );
  }
}
