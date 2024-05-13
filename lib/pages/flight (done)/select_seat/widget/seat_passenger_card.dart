import 'package:flutter/material.dart';

class SeatPassengerCard extends StatelessWidget {
  const SeatPassengerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      decoration: BoxDecoration(
        border: Border.all(
            color: const Color(0xFF28527A), width: 1.0), // Garis outline
        color: Colors.white,
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
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '1. Luaman Guaamin',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500, // Medium weight
                      fontFamily: 'Inter', // Pastikan font Inter tersedia
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Row(
                    children: [
                      Text(
                        "Economy",
                        style: TextStyle(
                            color: Color(0xFF8C8D89),
                            fontSize: 14,
                            fontFamily: 'Inter'),
                      ),
                      SizedBox(width: 16),
                      Icon(Icons.circle, color: Color(0xFF8C8D89), size: 8),
                      SizedBox(width: 16),
                      Text(
                        "8D",
                        style: TextStyle(
                            color: Color(0xFF8C8D89),
                            fontSize: 14,
                            fontFamily: 'Inter'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.check_circle, color: Color(0xFF57A3BB), size: 20.0),
          ],
        ),
      ),
    );
  }
}
