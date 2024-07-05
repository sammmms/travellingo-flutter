import 'package:travellingo/utils/flight_class_util.dart';

class RecentFlightSearch {
  final String from;
  final String to;
  final DateTime date;
  final int passengerCount;
  final FlightClass flightClass;
  DateTime? createdAt;

  RecentFlightSearch(
      {required this.from,
      required this.to,
      required this.date,
      required this.passengerCount,
      required this.flightClass,
      createdAt}) {
    this.createdAt = createdAt ?? DateTime.now();
  }

  Map<String, dynamic> toJson() {
    return {
      'from': from,
      'to': to,
      'date': DateTime(date.year, date.month, date.day).toIso8601String(),
      'passengerCount': passengerCount,
      'flightClass': FlightClassUtil.stringFromClass(flightClass),
      'createdAt': createdAt!.toIso8601String()
    };
  }

  factory RecentFlightSearch.fromJson(Map<String, dynamic> json) {
    return RecentFlightSearch(
        from: json['from'],
        to: json['to'],
        date: DateTime.parse(json['date']),
        passengerCount: json['passengerCount'],
        flightClass: FlightClassUtil.classFromString(json['flightClass']),
        createdAt: DateTime.parse(json['createdAt']));
  }

  bool isEqual(RecentFlightSearch other) {
    return from == other.from &&
        to == other.to &&
        (date.compareTo(other.date) == 0 ? true : false) &&
        passengerCount == other.passengerCount &&
        flightClass == other.flightClass;
  }
}
