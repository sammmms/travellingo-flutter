import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:rxdart/rxdart.dart';
import 'package:travellingo/component/my_image_loader.dart';
import 'package:travellingo/models/place.dart';
import 'package:travellingo/pages/place_detail/widget/place_category_chip.dart';
import 'package:travellingo/pages/place_detail/widget/place_review_star.dart';
import 'package:travellingo/utils/picture_type_util.dart';
import 'package:travellingo/utils/place_category_util.dart';

class QuantityBottomSheet extends StatefulWidget {
  final BehaviorSubject<int> selectedQuantity;
  final Place place;
  const QuantityBottomSheet(
      {super.key, required this.selectedQuantity, required this.place});

  @override
  State<QuantityBottomSheet> createState() => _QuantityBottomSheetState();
}

class _QuantityBottomSheetState extends State<QuantityBottomSheet> {
  final _quantityTEC = TextEditingController();
  late StreamSubscription sub;

  @override
  void initState() {
    sub = widget.selectedQuantity
        .listen((event) => _quantityTEC.text = event.toString());
    super.initState();
  }

  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        color: Theme.of(context).colorScheme.surfaceBright,
      ),
      child: SingleChildScrollView(
        padding: MediaQuery.viewInsetsOf(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADING
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.close),
              ),
            ),

            // IMAGE AND LABEL
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // IMAGE
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: MyImageLoader(
                      url: widget.place.pictureLink,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      pictureType: PictureType.link),
                ),
                const SizedBox(width: 10),

                // LABEL
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.place.name,
                          style: Theme.of(context).textTheme.headlineMedium),
                      Row(
                        children: [
                          PlaceDetailChip(
                              label: PlaceCategoryUtil.readCategory(
                                  widget.place.category)),
                          const SizedBox(width: 10),
                          PlaceReviewStar(
                              reviewCount: widget.place.reviewAverage),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            Divider(
              height: 40,
              thickness: 0.5,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
            ),

            // QUANTITY CHANGER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "quantity".getString(context),
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                StreamBuilder<int>(
                    stream: widget.selectedQuantity,
                    builder: (context, snapshot) {
                      int quantity = snapshot.data ?? 0;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _buildButton(
                            icon: Icons.remove,
                            onTap: quantity <= 0
                                ? null
                                : () =>
                                    widget.selectedQuantity.add(quantity - 1),
                          ),
                          SizedBox(
                            width: 40,
                            child: TextField(
                              decoration: const InputDecoration(
                                  isDense: true, filled: false),
                              controller: _quantityTEC,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              keyboardType: TextInputType.number,
                              onChanged: (String value) {
                                int number = int.tryParse(value) ?? 0;
                                if (number <= 0) {
                                  widget.selectedQuantity.add(0);
                                  return;
                                }
                                widget.selectedQuantity.add(number);
                              },
                            ),
                          ),
                          _buildButton(
                            onTap: () => widget.selectedQuantity
                                .add(widget.selectedQuantity.value + 1),
                            icon: Icons.add,
                          ),
                        ],
                      );
                    }),
              ],
            ),

            const SizedBox(
              height: 40,
            ),

            // BOOK BUTTON
            StreamBuilder<int>(
                stream: widget.selectedQuantity,
                builder: (context, snapshot) {
                  bool isQuantityValid =
                      snapshot.data != null && snapshot.data! > 0;
                  return Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                          minHeight: 56, minWidth: double.infinity),
                      child: ElevatedButton(
                        onPressed: isQuantityValid
                            ? () {
                                Navigator.pop(context, true);
                              }
                            : null,
                        style: ButtonStyle(
                          elevation: const WidgetStatePropertyAll(10),
                          padding: WidgetStateProperty.all(
                              const EdgeInsets.symmetric(horizontal: 20)),
                          backgroundColor: WidgetStateProperty.all(
                              isQuantityValid
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey.shade600),
                          foregroundColor: WidgetStateProperty.all(
                              Theme.of(context).colorScheme.onPrimary),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        child: Text(
                          "book".getString(context),
                          style: TextStyle(
                              color: isQuantityValid
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Theme.of(context)
                                      .colorScheme
                                      .inverseSurface
                                      .withOpacity(0.2)),
                        ),
                      ),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({required IconData icon, required Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 30,
        decoration: BoxDecoration(
            border: Border.all(
                width: 0.4,
                color: Theme.of(context)
                    .colorScheme
                    .inverseSurface
                    .withOpacity(0.2)),
            borderRadius: BorderRadius.circular(5),
            color: Theme.of(context).colorScheme.surfaceBright),
        child: Icon(
          icon,
          color: onTap == null
              ? Theme.of(context).colorScheme.inverseSurface.withOpacity(0.2)
              : Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
