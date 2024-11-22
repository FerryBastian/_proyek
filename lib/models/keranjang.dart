import 'package:flutter/material.dart';

class CartItem {
  final String name;
  final int quantity;
  final double price;
  final String size;
  final String image;

  CartItem({
    required this.name,
    required this.quantity,
    required this.price,
    required this.size,
    required this.image,
  });
}

class CartModel extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addItem(CartItem item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  double get totalPrice =>
      _items.fold(0.0, (total, current) => total + current.price);
}
