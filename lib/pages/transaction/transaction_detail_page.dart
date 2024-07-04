import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';
import 'package:travellingo/bloc/auth/auth_bloc.dart';
import 'package:travellingo/bloc/transaction/transaction_bloc.dart';
import 'package:travellingo/bloc/transaction/transaction_state.dart';
import 'package:travellingo/component/error_component.dart';
import 'package:travellingo/models/transaction.dart';

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

            return Center(
              child: Column(
                children: [
                  Text("Transaction ID: ${transaction.id}"),
                  Text("Total: ${transaction.total}"),
                  Text("Status: ${transaction.status}"),
                  const Text("Items:"),
                  ListView.builder(
                    itemCount: transaction.items.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(transaction.items[index].place.name),
                        subtitle: Text(
                            "Price: ${transaction.items[index].place.price} x ${transaction.items[index].quantity}"),
                      );
                    },
                  ),
                ],
              ),
            );
          }),
    );
  }
}
