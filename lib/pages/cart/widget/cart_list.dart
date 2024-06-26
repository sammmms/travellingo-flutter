import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:travellingo/models/cart.dart';
import 'package:travellingo/pages/cart/widget/cart_card.dart';

class CartList extends StatefulWidget {
  final BehaviorSubject<int> totalController;
  final Cart cart;
  const CartList(
      {super.key, required this.totalController, required this.cart});

  @override
  State<CartList> createState() => _CartListState();
}

class _CartListState extends State<CartList> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      separatorBuilder: (context, index) => const SizedBox(
        height: 10,
      ),
      itemCount: widget.cart.items.length,
      itemBuilder: (BuildContext context, int index) {
        return CartCard(
          cartItems: widget.cart.items[index],
        );
      },
    );
  }
}
