import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../models/item_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = Provider.of<ItemProvider>(context).items;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        leading: IconButton(
          icon: const Icon(Icons.settings),  // Ganti icon menu menjadi icon settings
          onPressed: () {
            // Menampilkan menu daftar ketika tombol settings ditekan
            _showMenu(context);
          },
        ),
        actions: [
          // Tombol keranjang
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // Navigasi ke halaman keranjang
              Navigator.pushNamed(context, '/cart');
            },
          ),
        ],
      ),
      body: items.isEmpty
          ? const Center(child: CircularProgressIndicator())  // Loading indicator
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.75,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return GestureDetector(
                  onTap: () {
                    // Navigasi ke halaman detail dan kirim data item
                    Navigator.pushNamed(
                      context,
                      '/details',
                      arguments: item,  // Mengirim data item
                    );
                  },
                  child: Card(
                    child: Column(
                      children: [
                        Expanded(child: Image.asset(item['image'], fit: BoxFit.cover)),
                        Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text("Rp ${item['price'].toStringAsFixed(2)}"),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

 void _showMenu(BuildContext context) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: const Text("Menu"),
        children: [
          SimpleDialogOption(
            onPressed: () {
              Navigator.of(context).pop();  // Menutup dialog terlebih dahulu
              // Menambahkan navigasi ke halaman profile
              Navigator.pushNamed(context, '/profile');  // Pastikan '/profile' sudah terdaftar di rute
            },
            child: const Text("Profile"),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.of(context).pop();  // Menutup dialog terlebih dahulu
              _logout(context);  // Logout dan arahkan ke halaman login
            },
            child: const Text("Logout"),
          ),
        ],
      );
    },
  );
}

// Fungsi logout
void _logout(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/');  // Arahkan ke halaman login setelah logout
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Error during logout')),
    );
  }
}

}