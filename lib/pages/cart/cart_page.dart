import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:travellingo/bloc/cart/cart_bloc.dart';
import 'package:travellingo/bloc/cart/cart_state.dart';
import 'package:travellingo/component/my_no_data_component.dart';
import 'package:travellingo/component/error_component.dart';
import 'package:travellingo/component/transition_animation.dart';
import 'package:travellingo/models/cart.dart';
import 'package:travellingo/pages/cart/widget/cart_list.dart';
import 'package:travellingo/utils/format_currency.dart';
import '../cart_checkout/cart_checkout_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final _totalController = BehaviorSubject<int>.seeded(0);
  late CartBloc bloc;

  final _isCheckedId = BehaviorSubject<List<String>>.seeded([]);

  @override
  void initState() {
    bloc = context.read<CartBloc>();
    if (bloc.controller.valueOrNull?.data != null) {
      bloc.getCart();
    }

    bloc.controller.listen((event) {
      if (event.data?.items.isNotEmpty ?? false) {
        List<String> currentChecked = _isCheckedId.valueOrNull ?? [];
        List<CartItems> items = event.data!.items;

        int tallyPoints = currentChecked.fold<int>(0, (prev, cur) {
          CartItems? item =
              items.firstWhereOrNull((item) => item.place.id == cur);
          if (item == null) return 0;
          return prev + (item.place.price * item.quantity);
        });

        _totalController.add(tallyPoints);
      }
    });

    _isCheckedId.listen((event) {
      if (bloc.controller.valueOrNull?.data?.items.isNotEmpty ?? false) {
        List<String> currentChecked = _isCheckedId.valueOrNull ?? [];
        List<CartItems> items = bloc.controller.value.data!.items;

        int tallyPoints = currentChecked.fold<int>(0, (prev, cur) {
          CartItems? item =
              items.firstWhereOrNull((item) => item.place.id == cur);
          if (item == null) return 0;
          return prev + (item.place.price * item.quantity);
        });

        _totalController.add(tallyPoints);
      }
    });

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
                    return Center(
                        child: Skeletonizer(
                      enabled: isLoading,
                      child: ListView.builder(
                        itemCount: 7,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: SizedBox(
                                  height: 100,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Row(
                                      children: [
                                        AspectRatio(
                                            aspectRatio: 1,
                                            child: Image.network(
                                                "https://fastly.picsum.photos/id/386/300/300.jpg?hmac=d6FbS5fber4u6kKm85UMyvPMNGXhkx3_gjHz7pkIMug",
                                                width: 100,
                                                fit: BoxFit.cover)),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Seaside Restaurant",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headlineMedium,
                                                ),
                                                const Text("Indonesia, Medan"),
                                                const Spacer(),
                                                Text(
                                                  "Rp ${NumberFormat("###,###", "id_ID").format(50000)}",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium!
                                                      .copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onSurface,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Checkbox(
                                              value: false,
                                              onChanged: (_) {},
                                              side: WidgetStateBorderSide
                                                  .resolveWith(
                                                (state) => BorderSide(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary),
                                              ),
                                              checkColor: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              shape: const CircleBorder(),
                                              fillColor:
                                                  WidgetStateColor.transparent,
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  right: 5, bottom: 10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              padding: EdgeInsets.zero,
                                              child: Row(
                                                children: [
                                                  Container(
                                                    color: Colors.transparent,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5),
                                                    child: Icon(
                                                      Icons.remove,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSurface,
                                                      size: 15,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    "1",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelMedium!
                                                        .copyWith(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .onSurface,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                    color: Colors.transparent,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5),
                                                    child: Icon(
                                                      Icons.add,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSurface,
                                                      size: 15,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                          );
                        },
                      ),
                    ));
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
                      label: "noItemInCart",
                      onRefresh: () {
                        bloc.getCart();
                      },
                    );
                  }

                  Cart cart = state.data!;
                  return MultiProvider(
                    providers: [
                      Provider<CartBloc>.value(value: bloc),
                      StreamProvider<List<String>>.value(
                        value: _isCheckedId,
                        initialData: const [],
                        updateShouldNotify: (_, __) => true,
                      )
                    ],
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await bloc.getCart();
                      },
                      child: CartList(
                        cart: cart,
                        onCheckmarkTap: (String value) {
                          List<String> currentArray =
                              _isCheckedId.valueOrNull ?? [];
                          if (currentArray.remove(value)) {
                            _isCheckedId.add(currentArray);
                            return;
                          }
                          _isCheckedId.add([...currentArray, value]);
                        },
                      ),
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
                    color: Theme.of(context).colorScheme.surfaceBright,
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
                            formatToIndonesiaCurrency(totals),
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
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          minimumSize: WidgetStateProperty.all<Size>(const Size(171, 48))),
      onPressed: () {
        List<CartItems> cartItems =
            bloc.controller.valueOrNull?.data?.items.where((item) {
                  return _isCheckedId.value.contains(item.place.id);
                }).toList() ??
                [];

        Navigator.push(
            context,
            slideInFromBottom(CartCheckoutPage(
              cartItems: cartItems,
            )));
      },
      child: Text('checkout'.getString(context),
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
    );
  }
}
