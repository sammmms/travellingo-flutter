import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';
import 'package:travellingo/models/recent_flight_search.dart';
import 'package:travellingo/utils/flight_class_util.dart';

class RecentFlightCard extends StatelessWidget {
  final RecentFlightSearch recentFlight;
  final Function() onTap;
  const RecentFlightCard(
      {super.key, required this.recentFlight, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 300,
        margin: const EdgeInsets.only(left: 18, right: 8),
        child: Card(
          surfaceTintColor: Colors.transparent,
          borderOnForeground: true,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
              side: BorderSide(color: Colors.grey.shade300)),
          color: Theme.of(context).colorScheme.surfaceBright,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(recentFlight.from,
                        style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward,
                      size: 18,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    const SizedBox(width: 8),
                    Text(recentFlight.to, style: const TextStyle(fontSize: 14)),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                    "${DateFormat('dd MMM yyyy').format(recentFlight.date)} • ${recentFlight.passengerCount} ${'passenger'.getString(context)} • ${FlightClassUtil.stringFromClass(recentFlight.flightClass).getString(context)}",
                    style: const TextStyle(
                        color: Color(0xFF8C8D89), fontSize: 12)),
                const SizedBox(height: 12),
                Text(DateFormat('dd MMMM yyyy HH:mm')
                    .format(recentFlight.createdAt!))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
