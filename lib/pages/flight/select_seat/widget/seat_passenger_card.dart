import 'package:flutter/material.dart';
import 'package:travellingo/models/flight.dart';
import 'package:travellingo/models/passenger.dart';
import 'package:travellingo/utils/flight_class_util.dart';

class SeatPassengerCard extends StatelessWidget {
  final Flight flight;
  final Passenger passenger;
  const SeatPassengerCard(
      {super.key, required this.passenger, required this.flight});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      decoration: BoxDecoration(
        border: Border.all(
            color: const Color(0xFF28527A), width: 1.0), // Garis outline
        color: Theme.of(context).colorScheme.surfaceBright,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    passenger.fullName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      Text(
                        FlightClassUtil.readableStringFromClass(
                            flight.flightClass),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.circle,
                          color: Theme.of(context).colorScheme.onSurface,
                          size: 8),
                      const SizedBox(width: 16),
                      Text("Seat ${passenger.seat}",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                          )),
                    ],
                  ),
                ],
              ),
            ),
            if (passenger.seat.isNotEmpty)
              Icon(Icons.check_circle,
                  color: Theme.of(context).colorScheme.tertiary, size: 20.0),
          ],
        ),
      ),
    );
  }
}
