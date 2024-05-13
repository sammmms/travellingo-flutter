import 'package:flutter/material.dart';
import 'package:travellingo/component/airplane_animation_component.dart';
import 'package:travellingo/component/dotted_divider_component.dart';

class CheckoutCard extends StatelessWidget {
  const CheckoutCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 194, // Set the card height
      padding: const EdgeInsets.all(16),
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
        mainAxisAlignment:
            MainAxisAlignment.spaceEvenly, // Distribute the children evenly
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 32,
                width: 52,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        'https://i.pinimg.com/originals/2f/88/4b/2f884b66c1a53b93a9e4826e5f4c459d.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const Text(
                'View Details',
                style: TextStyle(
                  color: Color(0xFF3E84A8),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const DottedDivider(),
          const SizedBox(height: 8), // Add space between elements
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Kobe',
                style: TextStyle(
                  color: Color(0xFF8C8D89),
                  fontSize: 14,
                ),
              ),
              Text(
                'Himeji Castle',
                style: TextStyle(
                  color: Color(0xFF8C8D89),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '19.00 PM',
                style: TextStyle(
                  color: Color(0xFF141511),
                  fontSize: 16,
                ),
              ),
              Row(
                mainAxisSize:
                    MainAxisSize.min, // Use the minimum amount of space
                children: [
                  Icon(
                    Icons.circle,
                    color: Color(0xFF3E84A8),
                    size: 8,
                  ),
                  SizedBox(width: 8), // Add space between icons
                  AirplaneAnimation(),
                  SizedBox(width: 8), // Add space between icons
                  Icon(
                    Icons.lens,
                    color: Color(0xFF3E84A8),
                    size: 8,
                  ),
                ],
              ),
              Text(
                '19.10 PM',
                style: TextStyle(
                  color: Color(0xFF141511),
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '01 April 2024',
                style: TextStyle(
                  color: Color(0xFF8C8D89),
                  fontSize: 12,
                ),
              ),
              Text(
                'Duration 10m',
                style: TextStyle(
                  color: Color(0xFF8C8D89),
                  fontSize: 12,
                ),
              ),
              Text(
                '01 April 2024',
                style: TextStyle(
                  color: Color(0xFF8C8D89),
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
