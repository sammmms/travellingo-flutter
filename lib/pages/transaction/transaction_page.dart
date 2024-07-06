import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:svg_flutter/svg.dart';
import 'package:travellingo/bloc/auth/auth_bloc.dart';
import 'package:travellingo/bloc/transaction/transaction_bloc.dart';
import 'package:travellingo/bloc/transaction/transaction_state.dart';
import 'package:travellingo/component/error_component.dart';
import 'package:travellingo/models/transaction.dart';
import 'package:travellingo/pages/transaction/widget/transaction_card_flight.dart';
import 'package:travellingo/pages/transaction/widget/transaction_card_place.dart';
import 'package:travellingo/pages/transaction/widget/transaction_page_loading.dart';
import 'package:travellingo/utils/transaction_type_util.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  late TransactionBloc bloc;
  final _filterController =
      BehaviorSubject<TransactionType>.seeded(TransactionType.all);

  @override
  void initState() {
    bloc = TransactionBloc(context.read<AuthBloc>());
    bloc.getTransaction(_filterController.valueOrNull);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("transaction".getString(context)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: SvgPicture.asset(
                "assets/svg/filter_icon.svg",
                color: Theme.of(context).colorScheme.tertiary,
              ),
              onPressed: () async {
                TransactionType? filterType = await showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return _filterTransactionBottomSheet();
                    });

                if (filterType != null) {
                  _filterController.add(filterType);
                  await bloc.getTransaction(filterType);
                }
              },
            ),
          ),
        ],
      ),
      body: StreamBuilder<TransactionState>(
          stream: bloc.state,
          builder: (context, snapshot) {
            bool isLoading = snapshot.data?.isLoading ?? false;
            if (!snapshot.hasData || isLoading) {
              return TransactionPageLoading(isLoading: isLoading);
            }

            if (snapshot.data!.hasError) {
              return MyErrorComponent(onRefresh: () async {
                bloc.getTransaction();
              });
            }

            List<Transaction> transactions = snapshot.data!.transactions ?? [];

            List<Transaction> placeTransaction =
                transactions.where((e) => e.items.first.place != null).toList();
            List<Transaction> flightTransaction =
                transactions.where((e) => e.items.first.place == null).toList();

            List<Transaction> combinedTransaction = [
              ...placeTransaction,
              ...flightTransaction
            ];

            int lastPlaceIndex = placeTransaction.length - 1;
            return RefreshIndicator(
              onRefresh: () async {
                await bloc.getTransaction(_filterController.valueOrNull);
              },
              child: ListView.separated(
                // physics: const NeverScrollableScrollPhysics(),
                itemCount: combinedTransaction.length,
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: 20),
                separatorBuilder: (BuildContext context, int index) {
                  if (index == lastPlaceIndex) {
                    return Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "flight".getString(context),
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    );
                  }
                  return const SizedBox();
                },
                itemBuilder: (BuildContext context, int index) {
                  // Only build the card if the place is not null
                  Transaction transaction = combinedTransaction[index];

                  print(transaction);

                  // If it's null, then it's a flight
                  if (transaction.items.first.place != null) {
                    return TransactionPlaceCard(
                        transactionData: transaction, items: transaction.items);
                  }

                  return TransactionFlightCard(
                    transaction: transaction,
                    transactionItems: transaction.items.first,
                  );
                },
              ),
            );
          }),
    );
  }

  Widget _filterTransactionBottomSheet() {
    return Column(
      children: TransactionType.values
          .map((e) => ListTile(
                title: Text(TransactionTypeUtil.textOf(e).getString(context)),
                onTap: () {
                  Navigator.of(context).pop(e);
                },
              ))
          .toList(),
    );
  }
}
