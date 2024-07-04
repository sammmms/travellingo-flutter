import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:svg_flutter/svg.dart';
import 'package:travellingo/pages/place_detail/widget/place_category_chip.dart';

class PlaceReviewStar extends StatelessWidget {
  final double reviewCount;
  const PlaceReviewStar({super.key, required this.reviewCount});

  @override
  Widget build(BuildContext context) {
    List<Widget> reviewStar = [];
    for (int i = 1; i <= 5; i++) {
      if (i <= reviewCount) {
        reviewStar.add(SvgPicture.asset(
          "assets/svg/star_full_icon.svg",
          height: 18,
        ));
      }
    }

    if (reviewStar.isEmpty) {
      reviewStar.add(PlaceDetailChip(label: "noReviewYet".getString(context)));
    }
    return Row(
      children: reviewStar,
    );
  }
}
