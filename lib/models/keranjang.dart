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

  // Mengembalikan daftar semua item di keranjang
  List<CartItem> get items => _items;

  // Menambahkan item ke keranjang
  void addItem(CartItem item) {
    final existingIndex = _items.indexWhere(
      (cartItem) => cartItem.name == item.name && cartItem.size == item.size,
    );

    if (existingIndex >= 0) {
      // Jika item sudah ada, perbarui jumlahnya
      _items[existingIndex] = CartItem(
        name: _items[existingIndex].name,
        quantity: _items[existingIndex].quantity + item.quantity,
        price: _items[existingIndex].price + item.price,
        size: _items[existingIndex].size,
        image: _items[existingIndex].image,
      );
    } else {
      // Jika tidak ada, tambahkan sebagai item baru
      _items.add(item);
    }

    notifyListeners(); // Memperbarui UI
  }

  // Menghapus item dari keranjang berdasarkan index
  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  // Memperbarui jumlah item tertentu
  void updateQuantity(int index, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(index); // Hapus item jika jumlahnya nol atau negatif
    } else {
      final item = _items[index];
      _items[index] = CartItem(
        name: item.name,
        quantity: newQuantity,
        price: (item.price / item.quantity) * newQuantity, // Hitung ulang harga
        size: item.size,
        image: item.image,
      );
      notifyListeners();
    }
  }

  // Menghapus semua item dari keranjang
  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  // Mendapatkan total harga dari semua item di keranjang
  double get totalPrice => _items.fold(0.0, (total, current) => total + current.price);

  // Mendapatkan total jumlah item di keranjang
  int get totalItems => _items.fold(0, (sum, item) => sum + item.quantity);

  // Mendapatkan daftar item dalam format map untuk kemudahan debugging atau pengiriman data
  List<Map<String, dynamic>> get formattedItems => _items.map((item) {
        return {
          'name': item.name,
          'quantity': item.quantity,
          'price': item.price,
          'size': item.size,
          'image': item.image,
        };
      }).toList();
}
