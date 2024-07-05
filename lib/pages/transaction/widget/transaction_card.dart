import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';
import 'package:travellingo/component/transition_animation.dart';
import 'package:travellingo/models/transaction.dart';
import 'package:travellingo/pages/transaction/transaction_detail_page.dart';
import 'package:travellingo/utils/picture_type_util.dart';
import 'package:travellingo/utils/transaction_status_util.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transactionData;
  final List<TransactionItems> items;

  const TransactionCard(
      {super.key, required this.items, required this.transactionData});

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
            ListView.separated(
                itemCount: items.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) => const Divider(
                      height: 40,
                    ),
                itemBuilder: (context, index) {
                  TransactionItems item = items[index];
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Place Picture
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image:
                                    item.place.pictureType == PictureType.link
                                        ? NetworkImage(item.place.pictureLink)
                                        : MemoryImage(base64Decode(
                                                item.place.pictureLink))
                                            as ImageProvider,
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Place Name
                            Text(item.place.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface)),

                            // Quantity & Review
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.local_activity,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    size: 16),
                                Text(
                                    " ${item.quantity} ${'ticket'.getString(context)}"),
                                const SizedBox(
                                  width: 10,
                                ),
                                Icon(Icons.favorite,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    size: 16),
                                Text(" ${item.place.reviewAverage} "),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                }),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Transaction Status
                Text(
                  TransactionStatusUtil.readableTextOf(transactionData.status),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
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
                onPressed: () {
                  Navigator.push(
                      context,
                      slideInFromBottom(
                        TransactionDetailPage(
                          transactionId: transactionData.id,
                        ),
                      ));
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary),
                child: Text(
                  transactionData.status == TransactionStatus.paid
                      ? "viewDetail".getString(context).toUpperCase()
                      : "payNow".getString(context).toUpperCase(),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
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
