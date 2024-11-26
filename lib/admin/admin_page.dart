import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:provider/provider.dart';
import '../models/item_provider.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Page"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showForm(context),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: itemProvider.items.isEmpty
          ? const Center(child: Text('Belum ada item. Tambahkan item baru.'))
          : ListView.builder(
              itemCount: itemProvider.items.length,
              itemBuilder: (context, index) {
                final item = itemProvider.items[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: Image.asset(item['image'], width: 50, fit: BoxFit.cover),
                    title: Text(item['name']),
                    subtitle: Text("Rp ${item['price'].toStringAsFixed(2)}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showForm(context, item: item),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            // Pastikan ID ada dan valid
                            final itemId = item['id'];
                            if (itemId != null) {
                              print("Deleting item with ID: $itemId");  // Debugging ID sebelum delete
                              itemProvider.deleteItem(itemId);
                            } else {
                              print("No ID found for item.");  // Jika ID kosong atau null
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  // Fungsi logout
  void _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, '/');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error during logout')),
      );
    }
  }

  // Fungsi untuk menampilkan form untuk menambah/edit item
  void _showForm(BuildContext context, {Map<String, dynamic>? item}) {
    final itemProvider = Provider.of<ItemProvider>(context, listen: false);

    final nameController = TextEditingController(text: item?['name']);
    final imageController = TextEditingController(text: item?['image']);
    final descriptionController = TextEditingController(text: item?['description']);
    final priceController = TextEditingController(text: item?['price']?.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item == null ? "Tambah Item" : "Edit Item"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: "Nama")),
              TextField(controller: imageController, decoration: const InputDecoration(labelText: "Path Gambar")),
              TextField(controller: descriptionController, decoration: const InputDecoration(labelText: "Deskripsi")),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Harga"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              final image = imageController.text.trim();
              final description = descriptionController.text.trim();
              final priceText = priceController.text.trim();

              // Validasi apakah ada field yang kosong atau null
              if (name.isEmpty || image.isEmpty || description.isEmpty || priceText.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Semua field harus diisi')),
                );
                return;
              }

              // Cek apakah harga valid
              double? price = double.tryParse(priceText);
              if (price == null || price < 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Harga tidak valid')),
                );
                return;
              }

              final newItem = {
                'name': name,
                'image': image,
                'description': description,
                'price': price,
              };

              // Perbarui atau tambahkan item berdasarkan apakah item sudah ada
              if (item == null) {
                itemProvider.addItem(newItem);
              } else {
                itemProvider.updateItem(item['id'], newItem);
              }

              Navigator.of(context).pop();
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }
}
