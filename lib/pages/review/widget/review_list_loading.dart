import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:travellingo/models/review.dart';
import 'package:travellingo/pages/review/widget/review_card.dart';

class ReviewListLoading extends StatelessWidget {
  const ReviewListLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        itemCount: 7,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          return ReviewCard(review: Review.generateDummy());
        },
      ),
    );
  }
}
