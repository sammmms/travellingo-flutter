import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travellingo/component/my_image_loader.dart';
import 'package:travellingo/models/place.dart';

class HomeNearby extends StatelessWidget {
  final Place place;
  final Function() onTap;
  const HomeNearby({super.key, required this.place, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints:
            const BoxConstraints(maxWidth: 200, minHeight: 300, maxHeight: 300),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 0.2),
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(15)),
                child: MyImageLoader(
                  url: place.pictureLink,
                  width: 200,
                  height: 150,
                  fit: BoxFit.cover,
                )),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(place.name),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_pin,
                          color: Theme.of(context).colorScheme.onSurface,
                          size: 15,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "${place.country.toUpperCase()}, ${place.city.toUpperCase()}",
                          style: const TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      NumberFormat.compactCurrency(
                              locale: 'id', symbol: 'Rp', decimalDigits: 0)
                          .format(place.price),
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 12,
                        ),
                        Text(
                          place.reviewAverage.toString(),
                          style: Theme.of(context).textTheme.labelSmall,
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
