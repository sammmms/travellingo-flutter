import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

class TransportButton extends StatelessWidget {
  final String icon;
  final String label;
  final Widget? routeTo;
  const TransportButton(
      {super.key, required this.icon, required this.label, this.routeTo});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: routeTo == null
          ? null
          : () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => routeTo!));
            },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11),
              color: const Color.fromRGBO(62, 132, 168, 1),
            ),
            width: 56,
            height: 56,
            padding: const EdgeInsets.all(8),
            child: Image.asset(icon),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            label.getString(context),
            style: const TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
