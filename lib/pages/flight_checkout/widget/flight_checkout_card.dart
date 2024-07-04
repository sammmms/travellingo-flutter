import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:travellingo/component/airplane_animation_component.dart';
import 'package:travellingo/component/dotted_divider_component.dart';
import 'package:travellingo/component/my_image_loader.dart';
import 'package:travellingo/models/cart.dart';

class FlightCheckoutCard extends StatelessWidget {
  final CartItems items;
  const FlightCheckoutCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
        mainAxisAlignment:
            MainAxisAlignment.spaceEvenly, // Distribute the children evenly
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyImageLoader(
                url: items.place.pictureLink,
                pictureType: items.place.pictureType,
                height: 32,
                fit: BoxFit.cover,
              ),
              Text(
                'viewDetails'.getString(context),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
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
