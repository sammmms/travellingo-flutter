import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:travellingo/pages/flight%20(done)/widget/flight_choice.dart';

class AppBarStack extends StatelessWidget {
  const AppBarStack({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 180, // Tinggi simulasi AppBar
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            image: DecorationImage(
              opacity: 0.5,
              colorFilter: ColorFilter.mode(Colors.black54, BlendMode.lighten),
              image: AssetImage("assets/flight/flight.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon:
                        const Icon(Icons.arrow_back, color: Color(0xFFF5D161)),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 8),
                  Text('flight'.getString(context),
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold))
                ],
              ),
            ),
          ),
        ),
        // Konten yang menindih bagian dari simulasi AppBar
        const Padding(
          padding: EdgeInsets.only(top: 120.0),
          child: Center(child: FlightChoice()),
        ),
      ],
    );
  }
}
