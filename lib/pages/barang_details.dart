import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/keranjang.dart';

class Details extends StatefulWidget {
  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  int _quantity = 1;
  String _selectedSize = '';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
    final productName = args['name'] as String? ?? 'Unknown Product';
    final productImage = args['image'] as String? ?? 'assets/default_image.png';
    final productPrice = args['price'] as double? ?? 100000;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detail Produk",
          style: TextStyle(color: Colors.brown, fontSize: 30),
        ),
        backgroundColor: Colors.brown[50],
        toolbarHeight: 100,
        elevation: 0,
      ),
      body: _content(context, productName, productImage, productPrice),
    );
  }

  Widget _content(BuildContext context, String productName, String productImage, double productPrice) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 200,
              color: Colors.brown[50],
              child: Image.asset(productImage),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.brown),
                  ),
                  Text(
                    "Rp ${productPrice.toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 20, color: Colors.brown),
                  ),
                  const SizedBox(height: 20),
                  _buildQuantityAndSizeSection(),
                ],
              ),
            ),
            const SizedBox(height: 80),
            GestureDetector(
              onTap: () {
                if (_quantity <= 0 || _selectedSize.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Pilih ukuran dan jumlah produk terlebih dahulu!")),
                  );
                  return;
                }

                final cart = Provider.of<CartModel>(context, listen: false);
                cart.addItem(CartItem(
                  name: productName,
                  quantity: _quantity,
                  price: productPrice * _quantity,
                  size: _selectedSize,
                  image: productImage,
                ));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Berhasil ditambahkan ke keranjang!")),
                );
              },
              child: _submitButton("Add to Cart"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityAndSizeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text("Jumlah", style: TextStyle(fontSize: 20, color: Colors.brown)),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.remove, color: Colors.brown),
              onPressed: () {
                setState(() {
                  if (_quantity > 1) _quantity--;
                });
              },
            ),
            Text("$_quantity", style: const TextStyle(fontSize: 20, color: Colors.brown)),
            IconButton(
              icon: const Icon(Icons.add, color: Colors.brown),
              onPressed: () {
                setState(() {
                  _quantity++;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text("Ukuran", style: TextStyle(fontSize: 20, color: Colors.brown)),
        Row(
          children: [
            _buildSizeOption("Small"),
            _buildSizeOption("Medium"),
            _buildSizeOption("Large"),
          ],
        ),
      ],
    );
  }

  Widget _buildSizeOption(String size) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSize = size;
        });
      },
      child: Container(
        height: 50,
        width: 80,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          color: _selectedSize == size ? Colors.brown[200] : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.brown),
        ),
        child: Center(
          child: Text(
            size,
            style: TextStyle(
              color: _selectedSize == size ? Colors.white : Colors.brown,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }

  Widget _submitButton(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.brown,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }
}
