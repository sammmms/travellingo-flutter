import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:travellingo/bloc/auth/auth_bloc.dart';
import 'package:travellingo/bloc/transaction/transaction_bloc.dart';
import 'package:travellingo/bloc/transaction/transaction_state.dart';
import 'package:travellingo/component/snackbar_component.dart';
import 'package:travellingo/component/transition_animation.dart';
import 'package:travellingo/models/cart.dart';
import 'package:travellingo/pages/cart_checkout/widget/cart_checkout_card.dart';
import 'package:travellingo/pages/transaction/transaction_detail_page.dart';
import 'package:travellingo/utils/app_error.dart';
import 'package:travellingo/utils/format_currency.dart';

class CartPaymentPage extends StatefulWidget {
  final List<CartItems> cartItems;
  final int additionalPayment;
  final int totalPayment;
  const CartPaymentPage(
      {super.key,
      required this.cartItems,
      this.additionalPayment = 0,
      required this.totalPayment});

  @override
  State<CartPaymentPage> createState() => _CartPaymentPageState();
}

class _CartPaymentPageState extends State<CartPaymentPage> {
  late TransactionBloc transactionBloc;
  final _formKey = GlobalKey<FormState>();

  final _phoneNumberTEC = TextEditingController();

  @override
  void initState() {
    transactionBloc = TransactionBloc(context.read<AuthBloc>());
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
          'payment'.getString(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'yourTrip'.getString(context),
                    style: Theme.of(context).textTheme.titleLarge,
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
                    height: 40,
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "paymentWith".getString(context),
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Image.asset(
                                "assets/images/mopay_logo.png",
                                width: 100,
                                fit: BoxFit.cover,
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "collabMopayDetail".getString(context),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Form(
                            key: _formKey,
                            child: TextFormField(
                              controller: _phoneNumberTEC,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              validator: (value) {
                                String string = value ?? "";

                                if (string.isEmpty) {
                                  return "pleaseEnterYourPhoneNumber"
                                      .getString(context);
                                }

                                if (string.length < 10) {
                                  return "phoneNumberFormatIsWrong"
                                      .getString(context);
                                }

                                return null;
                              },
                              keyboardType: TextInputType.phone,
                              style: Theme.of(context).textTheme.displayLarge,
                              decoration: InputDecoration(
                                  hintText: "pleaseEnterYourPhoneNumber"
                                      .getString(context),
                                  prefixText: "+62 "),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(24),
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
                      formatToIndonesiaCurrency(widget.totalPayment),
                    ),
                  ],
                ),
                StreamBuilder<TransactionState>(
                    stream: transactionBloc.controller,
                    builder: (context, snapshot) {
                      bool isLoading = snapshot.data?.isLoading ??
                          false || !snapshot.hasData;
                      return ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                              const Color(
                                  0xFFF5D161)), // Button background color
                          foregroundColor: WidgetStateProperty.all<Color>(
                              const Color(0xFFFFFFFF)), // Text color
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          minimumSize: WidgetStateProperty.all<Size>(
                              const Size(95, 48)), // Set the button's size
                        ),
                        onPressed: isLoading ? null : _tryPayment,
                        child: isLoading
                            ? const SizedBox(
                                width: 100, child: LinearProgressIndicator())
                            : Text(
                                'payNow'.getString(context),
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                ),
                              ),
                      );
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _tryPayment() async {
    if (_formKey.currentState?.validate() ?? false) {
      var response =
          await transactionBloc.getMopayId("0${_phoneNumberTEC.text}");

      if (!mounted) return;
      if (response is AppError) {
        showMySnackBar(context, response.message, SnackbarStatus.failed);
        return;
      }

      if (response is String) {
        List<String> itemsId = widget.cartItems.map((e) => e.place.id).toList();
        var checkoutResponse = await transactionBloc.checkoutCart(
            itemsId: itemsId,
            mopayId: response,
            additionalPayment: widget.additionalPayment);

        if (!mounted) return;
        if (checkoutResponse is AppError) {
          showMySnackBar(
              context, checkoutResponse.message, SnackbarStatus.failed);
          return;
        }

        if (checkoutResponse is String) {
          showMySnackBar(
              context, "pleaseProceedToMopayToPay", SnackbarStatus.success);

          Navigator.pushReplacement(
              context,
              slideInFromRight(
                  TransactionDetailPage(transactionId: checkoutResponse)));
        }
      }
    }
  }
}
