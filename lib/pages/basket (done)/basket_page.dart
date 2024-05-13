import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:travellingo/component/route_animator_component.dart';
import 'package:travellingo/pages/basket%20(done)/widget/basket_list.dart';
import '../checkout/checkout_page.dart';

class BasketPage extends StatefulWidget {
  const BasketPage({super.key});

  @override
  State<BasketPage> createState() => _BasketPageState();
}

class _BasketPageState extends State<BasketPage> {
  ValueNotifier<double> total = ValueNotifier<double>(0);
  double totals = 0;
  // Sample basket data

  @override
  void initState() {
    total.addListener(() {
      setState(() {
        totals = total.value;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    total.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("transaction".getString(context)),
        scrolledUnderElevation: 0,
      ),
      body: Column(
        children: <Widget>[
          BasketList(total: total),
          Container(
            decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade300))),
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'subtotal'.getString(context).toUpperCase(),
                      style: const TextStyle(
                        color: Color(0xFF6B7B78),
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      '\$${totals.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Color(0xFF292F2E),
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                OutlinedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all<Size>(
                        const Size(171, 48)), // Set the button's size
                  ),
                  onPressed: totals == 0
                      ? null
                      : () {
                          Navigator.push(context,
                              createRouteFromBottom(const CheckoutPage()));
                        },
                  child: Text(
                    'checkout'.getString(context),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
