import 'package:delshop_flutter_app/admin/transaksi.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:delshop_flutter_app/pages/homepage.dart';  // Mengimpor HomePage dari file yang benar
import 'package:delshop_flutter_app/authentication/register.dart';  // Mengimpor RegisterPage dari file yang benar
import 'firebase_options.dart';
import 'models/item_provider.dart';
import 'models/keranjang.dart';
import 'admin/admin_page.dart';
import 'authentication/login.dart';
import 'authentication/register_admin.dart';
import 'pages/barang_details.dart';
import 'pages/keranjang_page.dart';
import 'pages/payment.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ItemProvider()),
        ChangeNotifierProvider(create: (_) => CartModel()),
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
      title: 'DEL Shop App',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/menu': (context) => HomePage(),
        '/registerUser': (context) => RegisterPage(),
        '/details': (context) => Details(),
        '/cart': (context) => CartPage(),
        '/payment': (context) => PaymentPage(),
        '/registerAdmin': (context) => AdminRegisterPage(),
        '/adminPage': (context) => AdminPage(), // Halaman Admin
        '/transaction': (context) => TransaksiPage(
          paymentImage: '',  // Pass an empty string for now
          initialStatus: 'Pending',  // Use initialStatus instead of status
        ),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: const Center(child: Text('Halaman tidak ditemukan')),
          ),
        );
      },
    );
  }
}
