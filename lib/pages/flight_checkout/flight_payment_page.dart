import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';
import 'package:travellingo/bloc/auth/auth_bloc.dart';
import 'package:travellingo/bloc/flight/flight_bloc.dart';
import 'package:travellingo/bloc/flight/flight_state.dart';
import 'package:travellingo/component/mopay_payment_card.dart';
import 'package:travellingo/component/snackbar_component.dart';
import 'package:travellingo/component/transition_animation.dart';
import 'package:travellingo/models/flight.dart';
import 'package:travellingo/models/passenger.dart';
import 'package:travellingo/pages/flight_checkout/widget/flight_checkout_card.dart';
import 'package:travellingo/pages/transaction/transaction_detail/flight_transaction_detail_page.dart';
import 'package:travellingo/utils/app_error.dart';
import 'package:travellingo/utils/format_currency.dart';

class FlightPaymentPage extends StatefulWidget {
  final Flight flight;
  final List<Passenger> passengers;
  final int additionalPayment;
  const FlightPaymentPage({
    super.key,
    required this.flight,
    required this.passengers,
    this.additionalPayment = 0,
  });

  @override
  State<FlightPaymentPage> createState() => _FlightPaymentPageState();
}

class _FlightPaymentPageState extends State<FlightPaymentPage> {
  final _phoneNumberTEC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late FlightBloc _bloc;

  @override
  void initState() {
    _bloc = FlightBloc(context.read<AuthBloc>());
    super.initState();
  }

  @override
  void dispose() {
    _phoneNumberTEC.dispose();
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 500,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFFF5D161)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              'payment'.getString(context),
            ),
            scrolledUnderElevation: 0,
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                      FlightCheckoutCard(
                        flight: widget.flight,
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Form(
                        key: _formKey,
                        child: MopayPaymentCard(
                          controller: _phoneNumberTEC,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              _buildBottomAppBar()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomAppBar() {
    return Container(
      margin: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('subtotal'.getString(context),
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(width: 8), // Spacing between text
                  const Icon(
                    Icons.keyboard_arrow_down,
                    size: 16,
                  ), // Info icon
                ],
              ),
              Text(
                formatToIndonesiaCurrency(
                    widget.flight.price * widget.passengers.length +
                        widget.additionalPayment),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight
                      .w600, // Inter doesn't have a 'semi-bold', w600 is 'semi-bold' equivalent
                ),
              ),
            ],
          ),
          StreamBuilder<FlightState>(
              stream: _bloc.controller,
              builder: (context, snapshot) {
                bool isLoading = snapshot.data?.isLoading ?? false;
                return ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                        const Color(0xFFF5D161)), // Button background color
                    foregroundColor: WidgetStateProperty.all<Color>(
                        const Color(0xFFFFFFFF)), // Text color
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
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
                          style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.onPrimary),
                        ),
                );
              }),
        ],
      ),
    );
  }

  void _tryPayment() async {
    if (_formKey.currentState?.validate() ?? false) {
      var response = await _bloc.bookFlight(
        flight: widget.flight,
        passengers: widget.passengers,
        phoneNumber: _phoneNumberTEC.text,
        additionalPayment: widget.additionalPayment,
      );

      if (!mounted) return;

      if (response is AppError) {
        showMySnackBar(context, response.message, SnackbarStatus.failed);
      } else {
        showMySnackBar(context, 'pleaseProceedToMopayToPay'.getString(context),
            SnackbarStatus.success, true);
        Navigator.pushAndRemoveUntil(
            context,
            slideInFromBottom(
                FlightTransactionDetailPage(transactionId: response)),
            (route) => route.isFirst);
      }
    }
  }
}
