import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

class SeeAllButton extends StatelessWidget {
  const SeeAllButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Row(
        children: [
          Text(
            "seeAll".getString(context),
            style: TextStyle(color: Colors.grey.shade500),
          ),
          const SizedBox(
            width: 10,
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.grey.shade500,
            size: 10,
          )
        ],
      ),
    );
  }
}
