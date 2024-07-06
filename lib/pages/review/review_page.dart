import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';
import 'package:travellingo/bloc/auth/auth_bloc.dart';
import 'package:travellingo/bloc/review/review_bloc.dart';
import 'package:travellingo/component/error_component.dart';
import 'package:travellingo/models/review.dart';
import 'package:travellingo/pages/review/widget/review_card.dart';
import 'package:travellingo/pages/review/widget/review_list_loading.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  late ReviewBloc reviewBloc;

  @override
  void initState() {
    reviewBloc = ReviewBloc(context.read<AuthBloc>());

    reviewBloc.getReview();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("review".getString(context)),
        ),
        body: StreamBuilder(
          stream: reviewBloc.controller,
          builder: (context, snapshot) {
            bool isLoading =
                snapshot.data?.isLoading ?? false || !snapshot.hasData;

            if (isLoading) {
              return const ReviewListLoading();
            }

            bool hasError = snapshot.data?.hasError ?? false;

            if (hasError) {
              return MyErrorComponent(onRefresh: () {
                reviewBloc.getReview();
              });
            }

            List<Review> reviews = snapshot.data?.reviews ?? [];

            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              itemCount: reviews.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                Review review = reviews[index];
                return ReviewCard(review: review);
              },
            );
          },
        ));
  }
}
