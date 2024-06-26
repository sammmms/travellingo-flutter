import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:travellingo/models/place.dart';
import 'package:travellingo/utils/picture_type_util.dart';
import 'package:travellingo/utils/place_category_util.dart';
import 'package:travellingo/utils/theme_data/light_theme.dart';

class HomeCarousel extends StatefulWidget {
  final Place place;
  final Function() onTap;
  const HomeCarousel({super.key, required this.place, required this.onTap});

  @override
  State<HomeCarousel> createState() => _HomeCarouselState();
}

class _HomeCarouselState extends State<HomeCarousel> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Stack(
        children: [
          // THE PICTURE
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: widget.place.pictureType == PictureType.link
                      ? Image.network(
                          widget.place.pictureLink,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        )
                      : Image.memory(
                          base64Decode(widget.place.pictureLink),
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                ),
                Container(
                  color: Colors.black.withOpacity(0.3),
                )
              ],
            ),
          ),

          // THE TEXT
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.place.name,
                    style: textStyle.headlineLarge!.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "${PlaceCategoryUtil.readCategory(widget.place.category)} - ${widget.place.city}",
                    style: textStyle.labelLarge!.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
