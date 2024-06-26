import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:travellingo/utils/place_category_util.dart';

class HomeFilterChip extends StatelessWidget {
  final bool isSelected;
  final PlaceCategory selection;
  final Function(PlaceCategory) onSelected;
  const HomeFilterChip({
    super.key,
    required this.isSelected,
    required this.selection,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(PlaceCategoryUtil.stringOf(selection).getString(context)),
      backgroundColor: Colors.white,
      side: BorderSide(
          color: isSelected ? Colors.transparent : Colors.grey.shade500),
      selectedColor: const Color.fromRGBO(87, 163, 187, 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      labelStyle: TextStyle(
          color:
              isSelected ? Colors.white : const Color.fromRGBO(27, 20, 70, 1)),
      showCheckmark: false,
      selectedShadowColor: const Color.fromRGBO(87, 163, 187, 1),
      selected: isSelected,
      onSelected: (value) {
        onSelected(selection);
      },
    );
  }
}
