import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:travellingo/models/flight.dart';
import 'package:travellingo/pages/flight/flight_list/flight_list_card.dart';

class FlightListLoading extends StatelessWidget {
  const FlightListLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
        child: ListView.builder(
            itemCount: 7,
            itemBuilder: (contxt, index) => FlightListCard(
                  flight: Flight.generateDummy(),
                  passengerCount: 200,
                )));
  }
}
