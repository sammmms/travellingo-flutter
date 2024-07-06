import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:svg_flutter/svg.dart';
import 'package:travellingo/bloc/auth/auth_bloc.dart';
import 'package:travellingo/bloc/transaction/transaction_bloc.dart';
import 'package:travellingo/bloc/transaction/transaction_state.dart';
import 'package:travellingo/component/error_component.dart';
import 'package:travellingo/models/transaction.dart';
import 'package:travellingo/utils/transaction_status_util.dart';

class FlightTransactionDetailPage extends StatefulWidget {
  final String transactionId;
  const FlightTransactionDetailPage({super.key, required this.transactionId});

  @override
  State<FlightTransactionDetailPage> createState() =>
      _FlightTransactionDetailPageState();
}

class _FlightTransactionDetailPageState
    extends State<FlightTransactionDetailPage> {
  late TransactionBloc _transactionBloc;
  Timer? timer;
  Duration? remaining;

  @override
  void initState() {
    _transactionBloc = TransactionBloc(context.read<AuthBloc>());

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      await _transactionBloc.getTransactionById(widget.transactionId);
      Transaction? transaction =
          _transactionBloc.controller.valueOrNull?.transactions?.first;

      if (transaction == null) {
        return;
      }

      if (transaction.status == TransactionStatus.paid) {
        return;
      }

      DateTime now = DateTime.now();
      DateTime expiredAt = transaction.expiredAt!;
      remaining = expiredAt.difference(now);

      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (remaining!.inSeconds <= 0) {
          timer.cancel();
          Navigator.pop(context);
        }
        setState(() {
          remaining = Duration(seconds: remaining!.inSeconds - 1);
        });
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _transactionBloc.dispose();
    if (timer != null) timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 500,
        child: Scaffold(
          appBar: AppBar(
            title: Text("transactionDetail".getString(context)),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await _transactionBloc.getTransactionById(widget.transactionId);
            },
            child: StreamBuilder<TransactionState>(
                stream: _transactionBloc.controller,
                builder: (context, snapshot) {
                  bool isLoading =
                      snapshot.data?.isLoading ?? false || !snapshot.hasData;
                  if (isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  TransactionState state = snapshot.data!;

                  if (state.hasError) {
                    return MyErrorComponent(
                      onRefresh: () async {
                        await _transactionBloc
                            .getTransactionById(widget.transactionId);
                      },
                    );
                  }

                  List<Transaction> transactions = state.transactions ?? [];

                  if (transactions.isEmpty) {
                    return const Center(
                      child: Text("No transaction found"),
                    );
                  }

                  Transaction transaction = transactions.first;

                  bool isPaid = transaction.status == TransactionStatus.paid;

                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Card(
                      color: Theme.of(context).colorScheme.surfaceBright,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isPaid) ...[
                              Lottie.asset(
                                  'assets/lottie/success_animation.json',
                                  frameRate: FrameRate.max,
                                  repeat: false,
                                  width: 100),
                              const SizedBox(
                                height: 20,
                              ),
                              _buildTitle("transactionSuccess")
                            ] else ...[
                              Lottie.asset(
                                  'assets/lottie/pending_animation.json',
                                  frameRate: FrameRate.max,
                                  repeat: false,
                                  width: 100),
                              const SizedBox(
                                height: 20,
                              ),
                              _buildTitle("transactionPending")
                            ],

                            const Divider(
                              height: 60,
                            ),

                            // TOP SECTION
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildLabel("transactionId"),
                                _buildLabel("paymentMethod"),
                              ],
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildContent(
                                    "INV${transaction.id.hashCode.toString()}"),
                                _buildContent("MoPay E-Wallet"),
                              ],
                            ),

                            const SizedBox(
                              height: 20,
                            ),

                            // MIDDLE SECTION
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildLabel("date"),
                                _buildLabel("time"),
                              ],
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildContent(DateFormat("dd MMMM yyyy")
                                    .format(transaction.transactionDate)),
                                _buildContent(DateFormat("H:mm a")
                                    .format(transaction.transactionDate)),
                              ],
                            ),

                            const SizedBox(
                              height: 20,
                            ),

                            // BOTTOM SECTION
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildLabel("amountPaid"),
                                _buildLabel("insurance"),
                              ],
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildContent(NumberFormat.currency(
                                        locale: "id_ID",
                                        symbol: "Rp ",
                                        decimalDigits: 0)
                                    .format(transaction.total)),
                                _buildContent(transaction.additionalPayment > 0
                                    ? "yes".getString(context)
                                    : "no".getString(context)),
                              ],
                            ),

                            // BUTTON SECTION
                            const Divider(
                              height: 60,
                            ),

                            if (isPaid)
                              SizedBox(
                                height: 52,
                                child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).colorScheme.surface,
                                      side: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                          width: 2),
                                    ),
                                    onPressed: () {},
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/svg/download_icon.svg",
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                            "downloadInvoice"
                                                .getString(context),
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .tertiary)),
                                      ],
                                    )),
                              )
                            else ...[
                              _buildLabel("timeRemaining".getString(context)),
                              _buildContent(
                                  "${remaining!.inHours} hours ${remaining!.inMinutes.remainder(60)} minutes ${remaining!.inSeconds.remainder(60)} seconds"),
                            ]
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Text(
      title.getString(context),
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label.getString(context),
      style: const TextStyle(fontSize: 15),
    );
  }

  Widget _buildContent(String content) {
    return Text(
      content,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
    );
  }
}
