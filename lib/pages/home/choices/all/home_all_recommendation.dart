import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:travellingo/pages/home/widget/home_recommendation.dart';

class HomeAllRecommendation extends StatefulWidget {
  const HomeAllRecommendation({super.key});

  @override
  State<HomeAllRecommendation> createState() => _HomeAllState();
}

class _HomeAllState extends State<HomeAllRecommendation> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              HomeRecommendation(),
              HomeRecommendation(),
              HomeRecommendation(),
            ],
          ),
        ),
      ],
    );
  }
}
