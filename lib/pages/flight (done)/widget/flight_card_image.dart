import 'package:flutter/material.dart';

class FlightCardImage extends StatelessWidget {
  final String heading;
  final String? heading2;
  final String? subheading;
  final String? subheading2;
  final String? image;
  const FlightCardImage({
    super.key,
    required this.heading,
    this.heading2,
    this.subheading,
    this.subheading2,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 175,
      width: 350,
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade500,
        image: image == null
            ? null
            : DecorationImage(
                colorFilter:
                    const ColorFilter.mode(Colors.black26, BlendMode.darken),
                image: AssetImage(image!),
                fit: BoxFit.cover,
              ),
      ),
      child: Stack(
        children: [
          if (heading2 != null)
            Positioned(
              bottom: 75,
              left: 10,
              child: Text(
                heading2!,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 20),
              ),
            ),
          Positioned(
            bottom: 25,
            left: 10,
            child: Text(
              heading,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 35),
            ),
          ),
          if (subheading != null)
            Positioned(
              bottom: 10,
              left: 10,
              child: Text(
                subheading!.toLowerCase(),
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 12),
              ),
            ),
          if (subheading2 != null)
            Positioned(
              bottom: 10,
              right: 10,
              child: Text(
                subheading2!.toLowerCase(),
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 10),
              ),
            ),
        ],
      ),
    );
  }
}
