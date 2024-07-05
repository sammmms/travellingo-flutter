import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:svg_flutter/svg.dart';
import 'package:travellingo/bloc/auth/auth_bloc.dart';
import 'package:travellingo/bloc/transaction/transaction_bloc.dart';
import 'package:travellingo/bloc/transaction/transaction_state.dart';
import 'package:travellingo/component/error_component.dart';
import 'package:travellingo/models/place.dart';
import 'package:travellingo/models/transaction.dart';
import 'package:travellingo/pages/transaction/widget/stacking_place_quantity.dart';
import 'package:travellingo/utils/format_currency.dart';
import 'package:travellingo/utils/transaction_status_util.dart';

class TransactionDetailPage extends StatefulWidget {
  final String transactionId;
  const TransactionDetailPage({super.key, required this.transactionId});

  @override
  State<TransactionDetailPage> createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends State<TransactionDetailPage> {
  late TransactionBloc bloc;

  @override
  void initState() {
    bloc = TransactionBloc(context.read<AuthBloc>());
    bloc.getTransaction();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("transactionDetail".getString(context)),
      ),
      body: StreamBuilder<TransactionState>(
          stream: bloc.controller,
          builder: (context, snapshot) {
            bool isLoading =
                snapshot.data?.isLoading ?? false || !snapshot.hasData;

            if (isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.data!.hasError) {
              return MyErrorComponent(onRefresh: () async {
                bloc.getTransaction();
              });
            }

            TransactionState state = snapshot.data!;

            if (state.transactions == null || state.transactions!.isEmpty) {
              return const Center(
                child: Text("No data"),
              );
            }

            Transaction transaction = state.transactions!
                .firstWhere((element) => element.id == widget.transactionId);

            bool isPaid = transaction.status == TransactionStatus.paid;

            return RefreshIndicator(
              onRefresh: () async {
                await bloc.getTransaction();
              },
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: isPaid
                              ? Colors.green.shade200
                              : Colors.orange.shade200,
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      isPaid
                                          ? "transactionComplete"
                                              .getString(context)
                                          : "transactionPending"
                                              .getString(context),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary)),
                                  if (!isPaid) ...[
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    RichText(
                                      text: TextSpan(
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium!
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary),
                                          text:
                                              "pleaseCompleteYourPaymentBefore"
                                                  .getString(context),
                                          children: [
                                            const TextSpan(text: '\n'),
                                            TextSpan(
                                              text: DateFormat(
                                                      'dd MMM yyyy hh:mm:ss')
                                                  .format(
                                                      transaction.expiredAt!),
                                            )
                                          ]),
                                      maxLines: 2,
                                    )
                                  ]
                                ],
                              ),
                            ),
                            SvgPicture.asset(
                              isPaid
                                  ? "assets/svg/complete_icon.svg"
                                  : "assets/svg/pending_icon.svg",
                              color: Theme.of(context).colorScheme.onPrimary,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Transaction ID: ${transaction.id}",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                  "Transaction Date: ${DateFormat("dd MMMM yyyy hh:mm").format(transaction.transactionDate)}",
                                  style: Theme.of(context).textTheme.bodyLarge),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ListView.separated(
                        itemCount: transaction.items.length,
                        padding: const EdgeInsets.all(10),
                        shrinkWrap: true,
                        separatorBuilder: (context, index) => const Divider(
                          height: 40,
                        ),
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          int quantity = transaction.items[index].quantity;
                          Place place = transaction.items[index].place;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              StackingPlaceQuantity(
                                  place: place, quantity: quantity),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                  "Total : ${formatToIndonesiaCurrency(transaction.items[index].place.price * quantity)}",
                                  style: Theme.of(context).textTheme.bodyLarge),
                            ],
                          );
                        },
                      ),
                      const Divider(
                        height: 40,
                        endIndent: 10,
                        indent: 10,
                        thickness: 0.5,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Align(
                          alignment: AlignmentDirectional.bottomEnd,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (transaction.additionalPayment > 0) ...[
                                Text(
                                    "Additional Payment: ${formatToIndonesiaCurrency(transaction.additionalPayment)}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall),
                                const SizedBox(
                                  height: 10,
                                )
                              ],
                              Text(
                                  "Total: ${formatToIndonesiaCurrency(transaction.total)}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
