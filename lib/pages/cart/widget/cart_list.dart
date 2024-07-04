import 'package:flutter/material.dart';
import 'package:travellingo/component/transition_animation.dart';
import 'package:travellingo/models/cart.dart';
import 'package:travellingo/pages/cart/widget/cart_card.dart';
import 'package:travellingo/pages/place_detail/place_detail_page.dart';

class CartList extends StatefulWidget {
  final Cart cart;
  final Function(String) onCheckmarkTap;
  const CartList({super.key, required this.cart, required this.onCheckmarkTap});

  @override
  State<CartList> createState() => _CartListState();
}

class _CartListState extends State<CartList> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 20),
      separatorBuilder: (context, index) => const SizedBox(
        height: 10,
      ),
      itemCount: widget.cart.items.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                slideInFromBottom(
                    PlaceDetailPage(place: widget.cart.items[index].place)));
          },
          child: CartCard(
            onTap: widget.onCheckmarkTap,
            cartItems: widget.cart.items[index],
          ),
        );
      },
    );
  }
}
