import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:travellingo/component/transition_animation.dart';
import 'package:travellingo/models/cart.dart';
import 'package:travellingo/pages/cart_checkout/widget/cart_checkout_card.dart';
import 'package:travellingo/pages/cart_checkout/widget/checkout_extra_prot.dart';
import 'package:travellingo/utils/format_currency.dart';
import 'cart_payment_page.dart';

class CartCheckoutPage extends StatefulWidget {
  final List<CartItems> cartItems;
  const CartCheckoutPage({super.key, required this.cartItems});

  @override
  State<CartCheckoutPage> createState() => _CartCheckoutPageState();
}

class _CartCheckoutPageState extends State<CartCheckoutPage> {
  late int protectionPrice;
  bool isChecked = false;

  @override
  void initState() {
    protectionPrice = (widget.cartItems.fold(0, (prev, cur) {
              return prev + (cur.place.price * cur.quantity);
            }) *
            0.2)
        .toInt();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFF5D161)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'checkout'.getString(context),
        ),
        scrolledUnderElevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'yourTrip'.getString(context),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) {
                      return const Divider(
                        height: 20,
                      );
                    },
                    itemCount: widget.cartItems.length,
                    itemBuilder: (context, index) => CartCheckoutCard(
                      item: widget.cartItems[index],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: [
                          Checkbox(
                            visualDensity: VisualDensity.compact,
                            value: isChecked,
                            side: WidgetStateBorderSide.resolveWith((states) =>
                                BorderSide(
                                  color: Theme.of(context).colorScheme.tertiary,
                                )),
                            fillColor: WidgetStateColor.transparent,
                            checkColor: Theme.of(context).colorScheme.tertiary,
                            shape: const CircleBorder(),
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked = value!;
                              });
                            },
                            activeColor: Theme.of(context).colorScheme.tertiary,
                          ),
                          const SizedBox(width: 8),
                          Text('refundProtection'.getString(context),
                              style: Theme.of(context).textTheme.labelLarge),
                        ],
                      ),
                      Text(
                        formatToIndonesiaCurrency(protectionPrice),
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const CheckoutExtraProtectionCard(),
                ],
              ),
            ),
          ),
          _buildBottomAppBar()
        ],
      ),
    );
  }

  Widget _buildBottomAppBar() {
    int currentSubtotal = widget.cartItems
        .fold<int>(0, (prev, cur) => prev + (cur.place.price * cur.quantity));
    return Container(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    Text(
                      'subtotal'.getString(context),
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(width: 8), // Spacing between text
                    const Icon(
                      Icons.keyboard_arrow_down,
                      size: 20,
                    ), // Info icon
                  ],
                ),
              ),
              Text(
                formatToIndonesiaCurrency(isChecked
                    ? currentSubtotal + protectionPrice
                    : currentSubtotal),
              ),
            ],
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48, minWidth: 160),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.primary),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    slideInFromRight(CartPaymentPage(
                      cartItems: widget.cartItems,
                      additionalPayment: isChecked ? protectionPrice : 0,
                      totalPayment:
                          currentSubtotal + (isChecked ? protectionPrice : 0),
                    )));
              },
              child: Text(
                'proceedToPayment'.getString(context),
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
