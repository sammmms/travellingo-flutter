import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travellingo/component/airplane_animation_component.dart';
import 'package:travellingo/component/dotted_divider_component.dart';
import 'package:travellingo/component/route_animator_component.dart';
import '../ticket_detail/ticket_detail_page.dart';

class TicketListCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const TicketListCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Menentukan warna berdasarkan ketersediaan
    Color availableColor =
        data['available'] == "Available" ? const Color(0xFF28C584) : Colors.red;

    return InkWell(
        onTap: () {
          Navigator.push(
            context,
            createRouteFromRight(TicketDetailPage(data: data)),
          );
        },
        child: Container(
          height: 194,
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 32,
                    width: 52,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(data['image']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Harga dan ketersediaan di sisi kanan
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${data['price'].toStringAsFixed(2)}', // Menampilkan harga
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: const Color(0xFF3E84A8),
                        ),
                      ),
                      Text(
                        data['available'], // Menampilkan status ketersediaan
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: availableColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const DottedDivider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    data['origin'],
                    style: GoogleFonts.inter(
                      color: const Color(0xFF8C8D89),
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    data['destination'],
                    style: GoogleFonts.inter(
                      color: const Color(0xFF8C8D89),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    data['departureTime'],
                    style: GoogleFonts.inter(
                      color: const Color(0xFF141511),
                      fontSize: 16,
                    ),
                  ),
                  const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.circle, color: Color(0xFF3E84A8), size: 8),
                      SizedBox(width: 8),
                      AirplaneAnimation(),
                      SizedBox(width: 8),
                      Icon(Icons.circle, color: Color(0xFF3E84A8), size: 8),
                    ],
                  ),
                  Text(
                    data['arrivalTime'],
                    style: GoogleFonts.inter(
                      color: const Color(0xFF141511),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    data['date'],
                    style: GoogleFonts.inter(
                      color: const Color(0xFF8C8D89),
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    "Duration ${data['duration']}",
                    style: GoogleFonts.inter(
                      color: const Color(0xFF8C8D89),
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    data['date'],
                    style: GoogleFonts.inter(
                      color: const Color(0xFF8C8D89),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
