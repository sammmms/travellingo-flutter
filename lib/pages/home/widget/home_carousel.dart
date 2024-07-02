import 'dart:convert';

import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:travellingo/component/transition_animation.dart';
import 'package:travellingo/models/place.dart';
import 'package:travellingo/pages/place_detail_page.dart';
import 'package:travellingo/utils/picture_type_util.dart';
import 'package:travellingo/utils/place_category_util.dart';

class HomeCarousel extends StatefulWidget {
  final List<Place> places;
  const HomeCarousel({super.key, required this.places});

  @override
  State<HomeCarousel> createState() => _HomeCarouselState();
}

class _HomeCarouselState extends State<HomeCarousel> {
  late List<Place> places;

  @override
  void initState() {
    if (widget.places.isEmpty) {
      places = [];
    } else {
      places = widget.places.length > 5
          ? widget.places.sublist(0, 5)
          : widget.places;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      options: CarouselOptions(
          padEnds: true,
          enableInfiniteScroll: true,
          viewportFraction: 0.8,
          enlargeCenterPage: true,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 5),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          animateToClosest: true,
          pageSnapping: true),
      itemCount: places.length,
      itemBuilder: (context, index, realIndex) {
        Place place = places[index];
        return _CarouselItems(
            place: place,
            onTap: () => Navigator.push(
                context, slideInFromRight(PlaceDetailPage(place: place))));
      },
    );
  }
}

class _CarouselItems extends StatelessWidget {
  final Place place;
  final Function() onTap;
  const _CarouselItems({required this.place, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
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
                    child: place.pictureType == PictureType.link
                        ? FadeInImage(
                            image: NetworkImage(
                              place.pictureLink,
                            ),
                            placeholder: const AssetImage(
                                "assets/images/placeholder.png"),
                            imageErrorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                  "assets/images/placeholder.png");
                            },
                            fit: BoxFit.cover,
                          )
                        : Image.memory(
                            base64Decode(place.pictureLink),
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
                      place.name,
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge!
                          .copyWith(
                              color: Colors.white, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "${PlaceCategoryUtil.readCategory(place.category)} - ${place.city}",
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
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
