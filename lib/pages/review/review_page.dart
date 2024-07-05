import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';
import 'package:travellingo/bloc/auth/auth_bloc.dart';
import 'package:travellingo/bloc/review/review_bloc.dart';

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
      body: const Column(
        children: [
          Text("Review Page"),
        ],
      ),
    );
  }
}
