import 'package:flutter/material.dart';

class FlightCard extends StatelessWidget {
  const FlightCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(left: 18, right: 8),
      child: Card(
        surfaceTintColor: Colors.white,
        borderOnForeground: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: BorderSide(color: Colors.grey.shade300)),
        color: Colors.white,
        child: const Padding(
          padding: EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Kobe", style: TextStyle(fontSize: 14)),
                  SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward,
                    size: 18,
                    color: Colors.black,
                  ),
                  SizedBox(width: 8),
                  Text("Arima Onsen", style: TextStyle(fontSize: 14)),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: Colors.black,
                  ),
                ],
              ),
              SizedBox(height: 12),
              Text("24 Feb 2023 • 1 passenger • Economy",
                  style: TextStyle(color: Color(0xFF8C8D89), fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
