import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/keranjang.dart'; // Make sure the file location matches your project structure
import 'pages/barang_details.dart'; // Import the Details page
import 'pages/homepage.dart';
import 'authentication/login.dart';
import 'authentication/register.dart';
import 'pages/keranjang_page.dart'; // Add this line
import 'pages/order.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartModel()), // Using CartModel
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.brown, // Brown color theme
      ),
      initialRoute: '/', // Start at LoginPage
      routes: {
        '/': (context) => LoginPage(), // Login page
        '/menu': (context) => Menu(), // Menu page
        '/register': (context) => RegisterPage(), // Register page
        '/details': (context) => Details(), // Add the Details page route here
        '/cart': (context) => CartPage(), // Add this line
        '/order': (context) => OrderConfirmationPage(),
      },
    );
  }
}
