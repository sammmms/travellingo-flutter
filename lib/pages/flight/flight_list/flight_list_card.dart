import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:travellingo/component/airplane_animation_component.dart';
import 'package:travellingo/component/dotted_divider_component.dart';
import 'package:travellingo/component/my_image_loader.dart';
import 'package:travellingo/component/transition_animation.dart';
import 'package:travellingo/models/flight.dart';
import 'package:travellingo/pages/flight/flight_detail/flight_detail_page.dart';
import 'package:travellingo/utils/format_currency.dart';

class FlightListCard extends StatelessWidget {
  final Flight flight;
  final int passengerCount;

  const FlightListCard({
    super.key,
    required this.flight,
    required this.passengerCount,
  });

  @override
  Widget build(BuildContext context) {
    bool isAvailable = flight.availableSeats > passengerCount;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              slideInFromRight(FlightDetailPage(
                flight: flight,
              )),
            );
          },
          child: Card(
            color: Theme.of(context).colorScheme.surfaceBright,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyImageLoader(
                        url: flight.pictureLink,
                        fit: BoxFit.cover,
                        pictureType: flight.pictureType,
                        height: 32,
                      ),
                      // Harga dan ketersediaan di sisi kanan
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            formatToIndonesiaCurrency(
                                flight.price), // Menampilkan harga
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                          Text(
                            isAvailable
                                ? "available".getString(context)
                                : "notAvailable".getString(
                                    context), // Menampilkan status ketersediaan
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: isAvailable
                                  ? Colors.green.shade400
                                  : Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const DottedDivider(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        flight.departure,
                        style: GoogleFonts.inter(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        flight.arrival,
                        style: GoogleFonts.inter(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat("hh:mm").format(flight.departureTime),
                      ),
                      const AirplaneAnimation(),
                      Text(
                        DateFormat("hh:mm").format(flight.arrivalTime),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat("d MMM yyyy hh:mm")
                            .format(flight.departureTime),
                      ),
                      Text(
                        "${flight.duration.inHours}h ${flight.duration.inMinutes.remainder(60)}m",
                      ),
                      Text(
                        DateFormat("d MMM yyyy hh:mm")
                            .format(flight.arrivalTime),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
