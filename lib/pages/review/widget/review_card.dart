import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';
import 'package:travellingo/component/transition_animation.dart';
import 'package:travellingo/models/review.dart';
import 'package:travellingo/pages/place_detail/place_detail_page.dart';
import 'package:travellingo/pages/place_detail/widget/place_review_star.dart';

class ReviewCard extends StatelessWidget {
  final Review review;
  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            slideInFromRight(
              PlaceDetailPage(placeId: review.place),
            ));
      },
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PlaceReviewStar(reviewCount: review.rating),
                  Text(DateFormat('d/m/yyyy').format(review.createdAt)),
                ],
              ),
              if (review.haveUpdated) ...[
                const SizedBox(height: 5),
                Text("edited".getString(context))
              ],
              const Divider(
                height: 30,
                thickness: 0.5,
              ),
              Text(review.review, maxLines: 2, overflow: TextOverflow.ellipsis)
            ],
          ),
        ),
      ),
    );
  }
}
