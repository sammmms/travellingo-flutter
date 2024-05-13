import 'package:flutter/material.dart';
import 'package:travellingo/pages/basket%20(done)/widget/basket_card.dart';
import 'package:travellingo/utils/dummy_data.dart';

class BasketList extends StatefulWidget {
  final ValueNotifier<double> total;
  const BasketList({super.key, required this.total});

  @override
  State<BasketList> createState() => _BasketListState();
}

class _BasketListState extends State<BasketList> {
  List<bool> isChecked = List<bool>.filled(baskets.length, false);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.72,
      child: ListView.separated(
        shrinkWrap: true,
        separatorBuilder: (context, index) => const SizedBox(
          height: 10,
        ),
        itemCount: baskets.length, // Just an example item count
        itemBuilder: (BuildContext context, int index) {
          // return BasketCard(basketData: baskets[index]);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                // Checkbox on the left side
                Expanded(
                    flex: 1,
                    child: Checkbox(
                      value: isChecked[index],
                      shape: const CircleBorder(),
                      side: MaterialStateBorderSide.resolveWith((states) =>
                          const BorderSide(color: Color(0xFF28527A))),
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked[index] = value!;

                          // Calculate total
                          widget.total.value = 0;
                          for (int i = 0; i < isChecked.length; i++) {
                            if (isChecked[i]) {
                              widget.total.value += baskets[i]['price'];
                            }
                          }
                        });
                      },
                      activeColor: Colors.transparent,
                      checkColor: const Color(0xFF28527A),
                    )),
                Expanded(
                  flex: 15,
                  child: BasketCard(basketData: baskets[index]),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
