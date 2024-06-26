import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

class PassengerDetailCard extends StatelessWidget {
  const PassengerDetailCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        gradient: LinearGradient(
          colors: [
            Colors.lightBlue.shade100,
            Colors.white,
          ],
        ), // Adjust the color to match your design
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Luaman Guaamin",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Color(0xFF59597C),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "wayneenterprise@mail.com",
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          OutlinedButton(
            style: const ButtonStyle(
                padding: MaterialStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 8))),
            onPressed: () {
              // Handle your onPressed event here
            },
            child: Container(
              constraints: const BoxConstraints(maxWidth: 125),
              child: Text(
                "addPassenger".getString(context),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
