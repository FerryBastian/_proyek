import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/keranjang.dart'; // Adjust the path to your CartModel file

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Keranjang Belanja",
          style: TextStyle(color: Color.fromARGB(255, 52, 65, 144), fontSize: 25),
        ),
        backgroundColor: const Color.fromARGB(255, 230, 230, 250),
        toolbarHeight: 100,
        elevation: 0,
      ),
      body: cart.items.isEmpty
          ? Center(
              child: Text(
                "Keranjang Anda Kosong!",
                style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 52, 65, 144)),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: ListTile(
                          leading: Image.asset(item.image, width: 50),
                          title: Text(item.name),
                          subtitle: Text(
                            "Ukuran: ${item.size}\nJumlah: ${item.quantity}\nHarga: Rp ${item.price.toStringAsFixed(2)}",
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              cart.removeItem(index);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total: Rp ${cart.totalPrice.toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 52, 65, 144)),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to the PaymentPage and pass the totalPrice as an argument
                          Navigator.of(context).pushNamed(
                            '/payment',
                            arguments: cart.totalPrice, // Passing the total price here
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 230, 230, 250),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        ),
                        child: Text("Checkout", style: TextStyle(fontSize: 20)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
