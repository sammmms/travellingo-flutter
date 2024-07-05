import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:travellingo/utils/dummy_data.dart';
import 'widget/transaction_history_card.dart'; // Make sure this import points to where your PurchaseCard class is defined.

class PurchasePage extends StatelessWidget {
  const PurchasePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Convert the list of purchases to a list of PurchaseCard widgets
    List<Widget> purchaseCards = purchases.map((purchase) {
      return PurchaseCard(
        status: purchase['status'] as String,
        type: purchase['type'] as String,
        date: purchase['date'] as String,
        price: purchase['price'] as double,
        invoice: purchase['invoice'] as String,
        imageUrl: purchase['image'] as String,
        brand: purchase['brand'] as String,
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFF5D161)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "purchaseHistory".getString(context),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: purchaseCards,
        ),
      ),
    );
  }
}
