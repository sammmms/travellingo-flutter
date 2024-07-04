import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:travellingo/component/my_image_loader.dart';
import 'package:travellingo/models/cart.dart';
import 'package:travellingo/models/place.dart';

class CheckoutCard extends StatefulWidget {
  final CartItems item;
  const CheckoutCard({super.key, required this.item});

  @override
  State<CheckoutCard> createState() => _CheckoutCardState();
}

class _CheckoutCardState extends State<CheckoutCard> {
  late CartItems items;
  late Place place;

  @override
  void initState() {
    items = widget.item;
    place = items.place;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            MyImageLoader(
                url: widget.item.place.pictureLink,
                pictureType: widget.item.place.pictureType,
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
                items.place.name,
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
              "${items.quantity}x",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        )
      ],
    );
  }
}
