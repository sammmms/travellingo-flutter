import 'package:travellingo/models/place.dart';
import 'package:travellingo/utils/transaction_status_util.dart';

class TransactionItems {
  final String id;
  final Place place;
  final int quantity;

  TransactionItems({
    required this.id,
    required this.place,
    required this.quantity,
  });

  factory TransactionItems.fromJson(Map<String, dynamic> json) {
    return TransactionItems(
      id: json['_id'],
      place: Place.fromJson(json['place']),
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'place': place.toJson(), 'quantity': quantity};
  }
}

class Transaction {
  final String id;
  final List<TransactionItems> items;
  final int total;
  final DateTime transactionDate;
  final DateTime? expiredAt;
  final TransactionStatus status;

  Transaction({
    required this.id,
    this.items = const [],
    required this.total,
    required this.transactionDate,
    required this.expiredAt,
    required this.status,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    List? jsonItems = json['items'];
    late List<TransactionItems> items;
    if (jsonItems != null) {
      items = jsonItems.map((e) => TransactionItems.fromJson(e)).toList();
    } else {
      items = [];
    }

    return Transaction(
      items: items,
      id: json['_id'],
      total: json['total'],
      transactionDate: DateTime.parse(json['transactionDate']),
      expiredAt:
          json['expiredAt'] == null ? null : DateTime.parse(json['expiredAt']),
      status: TransactionStatusUtil.fromString(json['status']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'items': items.map((e) => e.toJson()).toList(),
      'total': total,
      'transactionDate': transactionDate.toIso8601String(),
      'expiredAt': expiredAt?.toIso8601String(),
      'status': TransactionStatusUtil.textOf(status),
    };
  }

  // COPY WITH
  Transaction copyWith({
    String? id,
    List<TransactionItems>? items,
    int? total,
    DateTime? transactionDate,
    DateTime? expiredAt,
    TransactionStatus? status,
  }) {
    return Transaction(
      id: id ?? this.id,
      items: items ?? this.items,
      total: total ?? this.total,
      transactionDate: transactionDate ?? this.transactionDate,
      expiredAt: expiredAt ?? this.expiredAt,
      status: status ?? this.status,
    );
  }
}
