import 'package:flutter/material.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

// TODO : GET DATA FROM TRANSACTION

class _TransactionPageState extends State<TransactionPage> {
  @override
  void initState() {
    // TODO: IMPLEMENT BLOC, AND STATE
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
          // body: ListView.builder(
          //   itemCount: transactions.length,
          //   itemBuilder: (BuildContext context, int index) {
          //     return TransactionCard(data: transactions[index]);
          //   },
          // ),
          ),
    );
  }
}
