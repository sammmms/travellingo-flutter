import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:travellingo/component/my_image_loader.dart';
import 'package:travellingo/models/place.dart';

class StackingPlaceQuantity extends StatelessWidget {
  final Place place;
  final int quantity;
  const StackingPlaceQuantity(
      {super.key, required this.place, required this.quantity});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            MyImageLoader(
                url: place.pictureLink,
                pictureType: place.pictureType,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                roundedRadius: 20,
                darken: true),
            const SizedBox(
              height: 20,
            )
          ],
        ),
        Positioned(
          bottom: 0,
          child: Card(
            color: Theme.of(context).colorScheme.surfaceBright,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                place.name,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.surfaceBright,
            child: Text(
              "${quantity}x",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        )
      ],
    );
  }
}
