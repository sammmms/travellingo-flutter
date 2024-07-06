import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:travellingo/component/my_image_loader.dart';
import 'package:travellingo/component/transition_animation.dart';
import 'package:travellingo/models/book_flight.dart';
import 'package:travellingo/models/flight.dart';
import 'package:travellingo/models/transaction.dart';
import 'package:travellingo/pages/flight/flight_detail/flight_detail_page.dart';
import 'package:travellingo/pages/transaction/transaction_detail/flight_transaction_detail_page.dart';
import 'package:travellingo/utils/flight_class_util.dart';
import 'package:travellingo/utils/format_currency.dart';
import 'package:travellingo/utils/transaction_status_util.dart';

class TransactionFlightCard extends StatelessWidget {
  final Transaction transaction;
  final TransactionItems transactionItems;
  const TransactionFlightCard({
    super.key,
    required this.transactionItems,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    Flight flight = transactionItems.bookFlight!.flight;
    BookFlight bookFlight = transactionItems.bookFlight!;

    return Container(
      height: 194,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceBright,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                TransactionStatusUtil.textOf(transaction.status)
                    .getString(context),
                style: GoogleFonts.inter(
                  color: TransactionStatusUtil.colorOf(transaction.status),
                  fontSize: 16,
                ),
              ),
              // Harga dan ketersediaan di sisi kanan
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    DateFormat('dd MMMM yyyy')
                        .format(transaction.transactionDate),
                    style: GoogleFonts.inter(
                      color: const Color(0xFF8C8D89),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${"flight".getString(context)} • ${FlightClassUtil.stringFromClass(flight.flightClass).getString(context)}",
                    style: GoogleFonts.inter(
                      color: Theme.of(context).colorScheme.tertiary,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    formatToIndonesiaCurrency(
                        transaction.total), // Menampilkan harga
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: const Color(0xFFE25A0D),
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      slideInFromRight(FlightTransactionDetailPage(
                        transactionId: transaction.id,
                      )));
                },
                child: Row(
                  mainAxisSize: MainAxisSize
                      .min, // Use MainAxisSize.min so that the Row only takes up as much space as needed
                  children: <Widget>[
                    Text(
                      'details'.getString(context),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios, // Use the appropriate arrow icon
                      size: 13.0, // Adjust the size to match your design
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ],
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              MyImageLoader(
                url: flight.pictureLink,
                pictureType: flight.pictureType,
                height: 32,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
                  shape: BoxShape.circle,
                ),
              ),
              Text(
                flight.airline,
                style: const TextStyle(
                  //  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "${flight.departure} - ${flight.arrival}",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
