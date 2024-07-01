import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:travellingo/bloc/transaction/transaction_bloc.dart';
import 'package:travellingo/bloc/transaction/transaction_state.dart';
import 'package:travellingo/component/refresh_component.dart';
import 'package:travellingo/models/transaction.dart';
import 'package:travellingo/pages/transaction/transaction_card.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final bloc = TransactionBloc();
  @override
  void initState() {
    bloc.getTransaction();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("transactionPage".getString(context)),
      ),
      body: StreamBuilder<TransactionState>(
          stream: bloc.state,
          builder: (context, snapshot) {
            bool isLoading = snapshot.data?.isLoading ?? false;
            if (!snapshot.hasData || isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.data!.hasError) {
              return RefreshComponent(onRefresh: () async {
                bloc.getTransaction();
              });
            }

            List<Transaction> transactions = snapshot.data!.transactions ?? [];
            return RefreshIndicator(
              onRefresh: () async {
                await bloc.getTransaction();
              },
              child: ListView.builder(
                // physics: const NeverScrollableScrollPhysics(),
                itemCount: transactions.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  Transaction transaction = transactions[index];
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: transaction.items.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return TransactionCard(
                          transactionData: transactions[index],
                          item: transaction.items[index]);
                    },
                  );
                },
              ),
            );
          }),
    );
  }
}
