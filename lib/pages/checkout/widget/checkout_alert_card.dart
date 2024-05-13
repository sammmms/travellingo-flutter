import 'package:flutter/material.dart';

class CheckoutAlertCard extends StatelessWidget {
  const CheckoutAlertCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16), // Padding inside the container
      color:
          const Color(0xFFFDE6EB), // Change this to your desired danger color
      child: const Row(
        children: <Widget>[
          Icon(Icons.access_time,
              color: Color(0xFFEE3D60)), // Icon with danger color
          SizedBox(width: 8), // Spacing between icon and text
          Text(
            "The remaining time of order 00:05:49", // Your alert message
            style: TextStyle(
              color: Color(0xFFEE3D60), // Text color for danger
              fontSize: 14, // Adjust the font size as needed
              fontWeight: FontWeight.bold, // Bold font weight for alert message
            ),
          ),
        ],
      ),
    );
  }
}
