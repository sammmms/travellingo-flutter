import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:travellingo/bloc/cart/cart_bloc.dart';
import 'package:travellingo/bloc/cart/cart_state.dart';
import 'package:travellingo/component/my_no_data_component.dart';
import 'package:travellingo/component/error_component.dart';
import 'package:travellingo/component/transition_animation.dart';
import 'package:travellingo/models/cart.dart';
import 'package:travellingo/pages/cart/widget/cart_list.dart';
import '../checkout/checkout_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final _totalController = BehaviorSubject<int>.seeded(0);
  late CartBloc bloc;

  @override
  void initState() {
    bloc = context.read<CartBloc>();
    if (bloc.controller.valueOrNull?.data != null) {
      bloc.getCart();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceTint,
        title: Text("cart".getString(context)),
        scrolledUnderElevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<CartState>(
                stream: bloc.controller,
                builder: (context, snapshot) {
                  bool isLoading = snapshot.data?.isLoading ?? false;
                  if (!snapshot.hasData || isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  CartState state = snapshot.data!;

                  bool hasError = state.hasError;

                  if (hasError) {
                    return MyErrorComponent(onRefresh: () async {
                      bloc.getCart();
                    });
                  }

                  bool noItemAvailable = state.data?.items.isEmpty ?? true;
                  if (noItemAvailable) {
                    return MyNoDataComponent(
                      onRefresh: () {
                        bloc.getCart();
                      },
                    );
                  }

                  Cart cart = state.data!;
                  return Provider<CartBloc>.value(
                    value: bloc,
                    child: CartList(
                      totalController: _totalController,
                      cart: cart,
                    ),
                  );
                }),
          ),
          StreamBuilder<int>(
              stream: _totalController,
              initialData: 0,
              builder: (context, snapshot) {
                int totals = snapshot.data ?? 0;
                if (totals == 0) {
                  return const SizedBox();
                }
                return Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'subtotal'.getString(context).toUpperCase(),
                            style: const TextStyle(
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            'Rp $totals',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      _checkoutButton(),
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }

  Widget _checkoutButton() {
    return OutlinedButton(
      style: ButtonStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          minimumSize: WidgetStateProperty.all<Size>(const Size(171, 48))),
      onPressed: () {
        Navigator.push(context, slideInFromBottom(const CheckoutPage()));
      },
      child: Text(
        'checkout'.getString(context),
        style: const TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
