import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:travellingo/utils/transaction_status_util.dart';

class TransactionPageLoading extends StatelessWidget {
  final bool isLoading;
  const TransactionPageLoading({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isLoading,
      child: ListView.builder(
        // physics: const NeverScrollableScrollPhysics(),
        itemCount: 7,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
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
                        "${"orderDate".getString(context).toUpperCase()} : ${DateFormat("d MMM yy hh:mm").format(DateTime.now())}",
                      ),
                      const Icon(Icons.more_vert),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ListView.separated(
                      itemCount: Random().nextInt(1) + 1,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => const Divider(
                            height: 40,
                          ),
                      itemBuilder: (context, index) {
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
                                    image: const DecorationImage(
                                      image: AssetImage(
                                              "assets/images/placeholder.png")
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
                                  Text("Seaside Restaurant",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface)),

                                  // Quantity & Review
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(Icons.local_activity,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          size: 16),
                                      Text("2 ${'ticket'.getString(context)}"),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Icon(Icons.favorite,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          size: 16),
                                      const Text("4.5"),
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
                        TransactionStatusUtil.textOf(TransactionStatus.paid)
                            .getString(context),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: TransactionStatusUtil.colorOf(
                              TransactionStatus.paid),
                        ),
                      ),
                      Text(
                        NumberFormat.currency(locale: "id_ID", symbol: "Rp")
                            .format(500000),
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
                      onPressed: null,
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary),
                      child: Text(
                        "viewDetail".getString(context).toUpperCase(),
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(
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
        },
      ),
    );
  }
}
