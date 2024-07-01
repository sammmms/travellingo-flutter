import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';
import 'package:travellingo/models/transaction.dart';
import 'package:travellingo/utils/picture_type_util.dart';
import 'package:travellingo/utils/transaction_status_util.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transactionData;
  final TransactionItems item;

  const TransactionCard(
      {super.key, required this.item, required this.transactionData});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "ORDER DATE : ${transactionData.transactionDate}",
                  style:
                      const TextStyle(color: Color(0xFFBFBFBF), fontSize: 12),
                ),
                const Icon(Icons.more_vert, color: Color(0xFFBFBFBF)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: item.place.pictureType == PictureType.link
                          ? NetworkImage(item.place.pictureLink)
                          : MemoryImage(base64Decode(item.place.pictureLink))
                              as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.place.name,
                          style: textStyle.headlineSmall!.copyWith(
                              color: Theme.of(context).colorScheme.onSurface)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.local_activity,
                              color: Theme.of(context).colorScheme.secondary,
                              size: 16),
                          Text(
                              " ${item.quantity} ${'ticket'.getString(context)}"),
                          const SizedBox(
                            width: 10,
                          ),
                          Icon(Icons.favorite,
                              color: Theme.of(context).colorScheme.secondary,
                              size: 16),
                          Text(" ${item.place.reviewAverage} "),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  TransactionStatusUtil.readableTextOf(transactionData.status),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color:
                        TransactionStatusUtil.colorOf(transactionData.status),
                  ),
                ),
                Text(
                  NumberFormat.compactCurrency(locale: "id_ID", symbol: "Rp")
                      .format(transactionData.total),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1B1446),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // TODO : BUTTON (IF NOT PAID THEN ROUTE TO PAYMENT PAGE, IF PAID ROUTE TO TRANSACTION DETAIL PAGE)
          ],
        ),
      ),
    );
  }
}
