import 'package:travellingo/models/place.dart';

class Cart {
  final String id;
  final List<CartItems> items;

  Cart({this.items = const [], required this.id});

  factory Cart.fromJson(Map<String, dynamic> json) {
    List? jsonItems = json['items'];
    late List<CartItems> items;
    if (jsonItems != null) {
      items = jsonItems.map((e) => CartItems.fromJson(e)).toList();
    } else {
      items = [];
    }

    return Cart(
      items: items,
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'items': items.map((e) => e.toJson()).toList()};
  }
}

class CartItems {
  final String id;
  final Place place;
  final int quantity;

  CartItems({
    required this.id,
    required this.place,
    required this.quantity,
  });

  factory CartItems.fromJson(Map<String, dynamic> json) {
    return CartItems(
      id: json['_id'],
      place: Place.fromJson(json['place']),
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'place': place.toJson(), 'quantity': quantity};
  }
}
