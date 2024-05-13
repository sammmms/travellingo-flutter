import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:rxdart/rxdart.dart';

class HomeFilterChip extends StatelessWidget {
  final String label;
  final Function onSelected;
  final BehaviorSubject controller;
  const HomeFilterChip(
      {super.key,
      required this.label,
      required this.onSelected,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: controller.stream,
        initialData: "all",
        builder: (context, snapshot) {
          bool isSelected = snapshot.data == label;
          return ChoiceChip(
            label: Text(label.getString(context)),
            backgroundColor: Colors.white,
            side: BorderSide(
                color: isSelected ? Colors.transparent : Colors.grey.shade500),
            selectedColor: const Color.fromRGBO(87, 163, 187, 1),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            labelStyle: TextStyle(
                color: isSelected
                    ? Colors.white
                    : const Color.fromRGBO(27, 20, 70, 1)),
            showCheckmark: false,
            selectedShadowColor: const Color.fromRGBO(87, 163, 187, 1),
            selected: isSelected,
            onSelected: (value) {
              onSelected(label);
            },
          );
        });
  }
}
