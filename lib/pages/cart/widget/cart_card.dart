import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:travellingo/bloc/cart/cart_bloc.dart';
import 'package:travellingo/component/snackbar_component.dart';
import 'package:travellingo/models/cart.dart';
import 'package:travellingo/models/place.dart';
import 'package:travellingo/utils/app_error.dart';
import 'package:travellingo/utils/format_currency.dart';
import 'package:travellingo/utils/picture_type_util.dart';

class CartCard extends StatefulWidget {
  final CartItems cartItems;
  final Function(String) onTap;
  const CartCard({super.key, required this.cartItems, required this.onTap});

  @override
  State<CartCard> createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  late BehaviorSubject<int> quantity;
  late CartBloc cartBloc;

  @override
  void initState() {
    cartBloc = context.read<CartBloc>();
    quantity = BehaviorSubject<int>.seeded(widget.cartItems.quantity);
    quantity.debounceTime(const Duration(seconds: 1)).listen((event) async {
      if (event == widget.cartItems.quantity) return;
      AppError? hasError =
          await cartBloc.updateItemQuantity(widget.cartItems.place.id, event);
      if (hasError != null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).clearSnackBars();
        showMySnackBar(context, hasError.message, SnackbarStatus.failed);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    bool quantityDifference = widget.cartItems.quantity != quantity.valueOrNull;
    if (quantityDifference) {
      cartBloc.updateItemQuantity(widget.cartItems.place.id, quantity.value);
    }
    quantity.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Place place = widget.cartItems.place;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Card(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: SizedBox(
              height: 120,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Row(
                  children: [
                    if (place.pictureType == PictureType.link)
                      AspectRatio(
                          aspectRatio: 1,
                          child: Image.network(place.pictureLink,
                              width: 100, fit: BoxFit.cover))
                    else if (place.pictureType == PictureType.base64)
                      AspectRatio(
                          aspectRatio: 1,
                          child: Image.memory(base64Decode(place.pictureLink),
                              width: 100, fit: BoxFit.cover)),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              place.name,
                              style: Theme.of(context).textTheme.headlineMedium,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text("${place.country}, ${place.city}"),
                            const Spacer(),
                            Text(
                              "Rp ${NumberFormat("###,###", "id_ID").format(place.price)}",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Checkbox(
                          value: context.watch<List<String>>().firstWhereOrNull(
                                  (value) => value == place.id) !=
                              null,
                          onChanged: (_) {
                            widget.onTap(place.id);
                          },
                          side: WidgetStateBorderSide.resolveWith(
                            (state) => BorderSide(
                                color: Theme.of(context).colorScheme.primary),
                          ),
                          checkColor: Theme.of(context).colorScheme.secondary,
                          shape: const CircleBorder(),
                          fillColor: WidgetStateColor.transparent,
                        ),
                        _buildQuantity(),
                      ],
                    ),
                  ],
                ),
              ),
            )),
        const SizedBox(
          height: 10,
        ),
        StreamBuilder<int>(
            stream: quantity,
            initialData: 0,
            builder: (context, snapshot) {
              return Container(
                margin: const EdgeInsets.only(right: 10),
                child: Text(
                    "Total : ${formatToIndonesiaCurrency(place.price * snapshot.data!)}",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold)),
              );
            })
      ],
    );
  }

  Widget _buildQuantity() {
    return Container(
      margin: const EdgeInsets.only(right: 5, bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.onSurface),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.zero,
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {
              if (quantity.value - 1 < 1) {
                bool confirmDeleteItem = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text("deleteItem".getString(context)),
                          content:
                              Text("deleteItemConfirmation".getString(context)),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                                child: Text("no".getString(context))),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context, true);
                                },
                                child: Text("yesDelete".getString(context))),
                          ],
                        ));
                if (confirmDeleteItem) {
                  quantity.add(0);
                }
                return;
              }
              quantity.add(quantity.value - 1);
            },
            child: Container(
              color: Colors.transparent,
              padding: const EdgeInsets.all(5),
              child: Icon(
                Icons.remove,
                color: Theme.of(context).colorScheme.onSurface,
                size: 15,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          StreamBuilder<int>(
              stream: quantity,
              builder: (context, snapshot) {
                return Text(
                  snapshot.data.toString(),
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.bold),
                );
              }),
          const SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: () {
              quantity.add(quantity.value + 1);
            },
            child: Container(
              color: Colors.transparent,
              padding: const EdgeInsets.all(5),
              child: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.onSurface,
                size: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
