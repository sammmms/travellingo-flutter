import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PurchaseCard extends StatelessWidget {
  final String status;
  final String type;
  final String date;
  final double price;
  final String invoice;
  final String imageUrl;
  final String brand;

  const PurchaseCard({
    super.key,
    required this.status,
    required this.type,
    required this.date,
    required this.price,
    required this.invoice,
    required this.imageUrl,
    required this.brand,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 194,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:  Theme.of(context).colorScheme.surfaceBright,
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
                "Payment Successful",
                style: GoogleFonts.inter(
                  color: const Color(0xFF57A3BB),
                  fontSize: 14,
                ),
              ),
              // Harga dan ketersediaan di sisi kanan
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    date,
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
                    "Flight",
                    style: GoogleFonts.inter(
                      color: Theme.of(context).colorScheme.tertiary,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '\$${price.toStringAsFixed(2)}', // Menampilkan harga
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
                  // Handle your on-press action here
                },
                child: Row(
                  mainAxisSize: MainAxisSize
                      .min, // Use MainAxisSize.min so that the Row only takes up as much space as needed
                  children: <Widget>[
                    Text(
                      'Details',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF57A3BB),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios, // Use the appropriate arrow icon
                      size: 13.0, // Adjust the size to match your design
                      color: Color(0xFF57A3BB),
                    ),
                  ],
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 32,
                width: 52,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              Text(
                brand,
                style: GoogleFonts.inter(
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
                invoice,
                style: GoogleFonts.inter(
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
