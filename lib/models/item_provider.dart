import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ItemProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _items = [];

  List<Map<String, dynamic>> get items => _items;

  ItemProvider() {
    fetchItems();
  }

  // Fetch items from Firestore
  Future<void> fetchItems() async {
    try {
      QuerySnapshot snapshot = await _db.collection('items').get();
      _items = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;  // Menambahkan ID dari Firestore
        return data;
      }).toList();
      print("Fetched items: $_items");  // Debugging untuk melihat apakah ID sudah benar
      notifyListeners();
    } catch (e) {
      print("Error fetching items: $e");
    }
  }

  // Add new item to Firestore
  Future<void> addItem(Map<String, dynamic> item) async {
    try {
      await _db.collection('items').add(item);
      fetchItems();  // Refresh the list
    } catch (e) {
      print("Error adding item: $e");
    }
  }

  // Update item in Firestore
  Future<void> updateItem(String id, Map<String, dynamic> updatedItem) async {
    try {
      print("Updating item with ID: $id");  // Debugging ID yang digunakan
      await _db.collection('items').doc(id).update(updatedItem);
      fetchItems();  // Refresh the list
    } catch (e) {
      print("Error updating item: $e");
    }
  }

  // Delete item from Firestore
  Future<void> deleteItem(String id) async {
    try {
      print("Deleting item with ID: $id");  // Debugging ID yang digunakan
      await _db.collection('items').doc(id).delete();
      fetchItems();  // Refresh the list
    } catch (e) {
      print("Error deleting item: $e");
    }
  }
}
