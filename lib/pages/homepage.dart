import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> coffeeTitle = [
      "Pin DEL",
      "Baju Putih Del",
      "Tumbler",
      "Payung",
      "Topi DEL"
    ];
    List<String> imagePaths = [
      'assets/pin_del.jpg',
      'assets/baju_putih.jpeg',
      'assets/tumbler.jpeg',
      'assets/payung.jpeg',
      'assets/topi.jpeg'
    ];
    List<String> descriptions = [
      "Pin resmi Universitas DEL. Cocok untuk acara formal.",
      "Baju putih dengan logo DEL. Nyaman untuk kegiatan sehari-hari.",
      "Tumbler berkualitas untuk menjaga minuman tetap hangat atau dingin.",
      "Payung DEL, cocok untuk segala cuaca.",
      "Topi bergaya dengan logo DEL. Pilihan keren untuk outdoor."
    ];
    List<double> prices = [15000, 75000, 50000, 40000, 30000]; // Harga tiap item

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "DEL SHOP",
          style: TextStyle(
            color: Color.fromARGB(255, 52, 65, 144),
            fontSize: 40,
            fontStyle: FontStyle.italic,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 230, 230, 250),
        toolbarHeight: 100,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              icon: const Icon(
                Icons.shopping_cart,
                color: Color.fromARGB(255, 52, 65, 144),
                size: 40,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed('/cart');
              },
            ),
          ),
        ],
      ),
      body: content(context, coffeeTitle, imagePaths, descriptions, prices),
    );
  }

  Widget content(
    BuildContext context,
    List<String> coffeeTitle,
    List<String> imagePaths,
    List<String> descriptions,
    List<double> prices,
  ) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text.rich(
            TextSpan(
              text: "Beli semua perlengkapan kuliahmu di ",
              style: TextStyle(
                fontSize: 24,
                color: Color.fromARGB(255, 52, 65, 144),
              ),
              children: [
                TextSpan(
                  text: "DEL SHOP.",
                  style: TextStyle(
                    color: Color.fromARGB(255, 52, 65, 144),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(20.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 3 / 4,
            ),
            itemCount: coffeeTitle.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    '/details',
                    arguments: {
                      'name': coffeeTitle[index],
                      'image': imagePaths[index],
                      'description': descriptions[index],
                      'price': prices[index], // Kirim harga
                    },
                  );
                },
                child: Card(
                  elevation: 5,
                  shadowColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(15)),
                          child: Image.asset(
                            imagePaths[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              coffeeTitle[index],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color.fromARGB(255, 52, 65, 144),
                              ),
                            ),
                            Text(
                              "Rp ${prices[index].toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
