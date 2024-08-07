import 'package:travellingo/models/flight.dart';
import 'package:travellingo/models/passenger.dart';

class BookFlight {
  final String id;
  final Flight flight;
  final List<Passenger> passengers;
  final int total;
  final DateTime? expiredAt;
  final DateTime createdAt;

  BookFlight({
    required this.id,
    required this.flight,
    required this.passengers,
    required this.total,
    required this.expiredAt,
    required this.createdAt,
  });

  factory BookFlight.fromJson(Map<String, dynamic> json) {
    List? jsonPassengers = json['passengers'];
    late List<Passenger> passengers;
    if (jsonPassengers != null) {
      passengers = jsonPassengers.map((e) => Passenger.fromJson(e)).toList();
    } else {
      passengers = [];
    }

    return BookFlight(
      id: json['_id'],
      flight: Flight.fromJson(json['flight']),
      passengers: passengers,
      total: json['total'],
      expiredAt: json['expiredAt'] == null
          ? null
          : DateTime.parse(json['expiredAt']).toLocal(),
      createdAt: DateTime.parse(json['createdAt']).toLocal(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'flight': flight.toJson(),
      'passengers': passengers.map((e) => e.toJson()).toList(),
      'total': total,
      'expiredAt': expiredAt?.toUtc().toIso8601String(),
      'createdAt': createdAt.toUtc().toIso8601String(),
    };
  }
}
