import 'package:travellingo/utils/flight_class_util.dart';
import 'package:travellingo/utils/picture_type_util.dart';

class Flight {
  final String id;
  final String airline;
  final String flightNumber;
  final String departure;
  final String arrival;
  final int price;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final Duration duration;
  final int seats;
  final int availableSeats;
  final FlightClass flightClass;
  // A network image
  final String pictureLink;
  final PictureType pictureType;

  Flight({
    required this.id,
    required this.airline,
    required this.flightNumber,
    required this.departure,
    required this.arrival,
    required this.price,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.seats,
    this.availableSeats = 0,
    this.flightClass = FlightClass.economy,
    this.pictureLink = "",
    this.pictureType = PictureType.link,
  });

  factory Flight.fromJson(Map<String, dynamic> json) {
    DateTime departureTime = DateTime.parse(json['departureTime']);
    DateTime arrivalTime = DateTime.parse(json['arrivalTime']);

    // Find duration from departure time and arrival time
    Duration duration = arrivalTime.difference(departureTime);
    return Flight(
      id: json['_id'],
      airline: json['airline'],
      flightNumber: json['flightNumber'],
      price: json['price'],
      departureTime: departureTime,
      arrivalTime: arrivalTime,
      departure: json['departure'],
      arrival: json['arrival'],
      duration: duration,
      seats: json['seats'],
      availableSeats: json['availableSeats'],
      flightClass: FlightClassUtil.classFromString(json['flightClass']),
      pictureLink: json['pictureLink'],
      pictureType: PictureTypeUtil.typeOf(json['pictureType']),
    );
  }

  factory Flight.generateDummy() {
    return Flight(
      id: "1",
      airline: "Airline",
      flightNumber: "123",
      departure: "Departure",
      arrival: "Arrival",
      price: 100,
      departureTime: DateTime.now(),
      arrivalTime: DateTime.now().add(const Duration(hours: 2)),
      duration: const Duration(hours: 2),
      seats: 100,
      availableSeats: 100,
      flightClass: FlightClass.economy,
      pictureLink: "https://picsum.photos/250?image=9",
      pictureType: PictureType.link,
    );
  }
}
