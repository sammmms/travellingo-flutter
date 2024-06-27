import 'package:flutter/material.dart';

enum TransactionStatus {
  pending,
  paid,
}

class TransactionStatusUtil {
  static const Map<TransactionStatus, String> statusMap = {
    TransactionStatus.pending: "pending",
    TransactionStatus.paid: "paid",
  };

  static TransactionStatus fromString(String status) {
    return TransactionStatus.values.firstWhere((e) => statusMap[e] == status);
  }

  static String textOf(TransactionStatus status) {
    return statusMap[status]!;
  }

  static Color colorOf(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.pending:
        return Colors.orangeAccent.shade100;
      case TransactionStatus.paid:
        return Colors.green.shade100;
    }
  }

  static String readableTextOf(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.pending:
        return "Pending";
      case TransactionStatus.paid:
        return "Paid";
    }
  }
}
