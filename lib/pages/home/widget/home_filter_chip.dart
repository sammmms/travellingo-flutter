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
    return Theme(
      data: Theme.of(context).copyWith(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
      ),
      child: ChoiceChip(
        label: Text(PlaceCategoryUtil.stringOf(selection).getString(context)),
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        side: BorderSide(
            color: isSelected
                ? Colors.transparent
                : Theme.of(context).colorScheme.outline),
        selectedColor: const Color.fromRGBO(87, 163, 187, 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        labelStyle: TextStyle(
            color: isSelected
                ? Colors.white
                : const Color.fromRGBO(27, 20, 70, 1)),
        showCheckmark: false,
        selectedShadowColor: const Color.fromRGBO(87, 163, 187, 1),
        selected: isSelected,
        onSelected: (value) {
          onSelected(selection);
        },
      ),
    );
  }
}
