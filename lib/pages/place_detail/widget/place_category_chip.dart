import 'package:flutter/material.dart';

class PlaceDetailChip extends StatelessWidget {
  final String label;
  const PlaceDetailChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      labelPadding: const EdgeInsets.symmetric(horizontal: 5),
      labelStyle: const TextStyle(fontSize: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      label: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 60),
          child: Text(
            label,
            textAlign: TextAlign.center,
          )),
      padding: EdgeInsets.zero,
    );
  }
}
