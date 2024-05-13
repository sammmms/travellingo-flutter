import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PurchaseCard extends StatelessWidget {
  final String status;
  final String type;
  final String date;
  final double price;
  final String invoice;
  final String imageUrl;

  const PurchaseCard({
    super.key,
    required this.status,
    required this.type,
    required this.date,
    required this.price,
    required this.invoice,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.all(14.0),
      child: Container(
        height: 160.0,
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  status,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF28527A),
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  date,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF000000),
                    fontSize: 8,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      type,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF000000),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      '\$$price', // Ensure the price is formatted correctly
                      style: GoogleFonts.inter(
                        color: const Color(0xFFE25A0D),
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
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
                        Icons
                            .arrow_forward_ios, // Use the appropriate arrow icon
                        size: 13.0, // Adjust the size to match your design
                        color: Color(0xFF57A3BB),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 12.0),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 14.0),
                  child: Container(
                    width: 27.0,
                    height: 15.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Text(
                  'Garuda Indonesia', // This could also be passed in if different per card
                  style: GoogleFonts.inter(
                    color: const Color(0xFF000000),
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                invoice,
                style: GoogleFonts.inter(
                  color: const Color(0xFF7C7C7C),
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
