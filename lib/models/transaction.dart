import 'package:travellingo/models/book_flight.dart';
import 'package:travellingo/models/place.dart';
import 'package:travellingo/utils/transaction_status_util.dart';

class TransactionItems {
  final String id;
  final Place? place;
  final int? quantity;
  final BookFlight? bookFlight;

  TransactionItems({
    required this.id,
    this.place,
    this.quantity,
    this.bookFlight,
  });

  factory TransactionItems.fromJson(Map<String, dynamic> json) {
    return TransactionItems(
      id: json['_id'],
      place: json['place'] == null ? null : Place.fromJson(json['place']),
      quantity: json['quantity'],
      bookFlight: json['bookFlight'] == null
          ? null
          : BookFlight.fromJson(json['bookFlight']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'place': place?.toJson(),
      'quantity': quantity,
      'bookFlight': bookFlight?.toJson(),
    };
  }
}

class Transaction {
  final String id;
  final List<TransactionItems> items;
  final int total;
  final DateTime transactionDate;
  final DateTime? expiredAt;
  final TransactionStatus status;
  final int additionalPayment;

  Transaction({
    required this.id,
    this.items = const [],
    required this.total,
    required this.transactionDate,
    required this.expiredAt,
    required this.status,
    this.additionalPayment = 0,
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
      transactionDate: DateTime.parse(json['createdAt']).toLocal(),
      expiredAt: json['expiredAt'] == null
          ? null
          : DateTime.parse(json['expiredAt']).toLocal(),
      status: TransactionStatusUtil.fromString(json['status']),
      additionalPayment: json['additionalPayment'] ?? 0,
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
      'additionalPayment': additionalPayment,
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
    int? additionalPayment,
  }) {
    return Transaction(
      id: id ?? this.id,
      items: items ?? this.items,
      total: total ?? this.total,
      transactionDate: transactionDate ?? this.transactionDate,
      expiredAt: expiredAt ?? this.expiredAt,
      status: status ?? this.status,
      additionalPayment: additionalPayment ?? this.additionalPayment,
    );
  }

  // TO STRING
  @override
  String toString() {
    return 'Transaction(id: $id, items: $items, total: $total, transactionDate: $transactionDate, expiredAt: $expiredAt, status: $status, additionalPayment: $additionalPayment)';
  }
}
