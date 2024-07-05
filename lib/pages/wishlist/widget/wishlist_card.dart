import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:travellingo/models/place.dart';
import 'package:travellingo/utils/format_currency.dart';
import 'package:travellingo/utils/picture_type_util.dart';

class WishlistCard extends StatelessWidget {
  final Place place;
  const WishlistCard({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          height: 125,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Row(
              children: [
                if (place.pictureType == PictureType.link)
                  AspectRatio(
                      aspectRatio: 1,
                      child: Image.network(place.pictureLink,
                          width: 100, fit: BoxFit.cover))
                else if (place.pictureType == PictureType.base64)
                  AspectRatio(
                      aspectRatio: 1,
                      child: Image.memory(base64Decode(place.pictureLink),
                          width: 100, fit: BoxFit.cover)),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          place.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Icon(Icons.location_on,
                                size: 15,
                                color: Theme.of(context).colorScheme.error),
                            Text("${place.country}, ${place.city}"),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          formatToIndonesiaCurrency(place.price),
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
