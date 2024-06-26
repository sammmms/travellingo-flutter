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
                  "${"orderDate".getString(context).toUpperCase()} : ${DateFormat("d MMM yy hh:mm").format(transactionData.transactionDate)}",
                ),
                const Icon(Icons.more_vert),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.place.name,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface)),
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
                  NumberFormat.currency(locale: "id_ID", symbol: "Rp")
                      .format(transactionData.total),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    backgroundColor: Theme.of(context).colorScheme.primary),
                child: Text(
                  transactionData.status == TransactionStatus.paid
                      ? "viewDetail".getString(context).toUpperCase()
                      : "payNow".getString(context).toUpperCase(),
                  style: Theme.of(context).textTheme.labelMedium,
                  textScaler: const TextScaler.linear(1.1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
