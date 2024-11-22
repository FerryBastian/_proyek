import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Menambahkan fungsi login untuk memverifikasi data pengguna
  Future<void> _login() async {
    final email = emailController.text;
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email dan Kata Sandi tidak boleh kosong!')),
      );
      return;
    }

    // Memverifikasi apakah email dan password cocok dengan yang ada di database
    final isValid = await DatabaseHelper().validateUser(email, password);

    if (isValid) {
      // Jika valid, pindah ke halaman menu
      Navigator.of(context).pushNamed("/menu");
    } else {
      // Jika tidak valid, tampilkan pesan error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email atau Kata Sandi salah!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 230, 250), // Optional light background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Image.asset(
                  'assets/logo.png',
                  height: 100, // Adjust the height
                  width: 100,  // Adjust the width
                  fit: BoxFit.contain, // Ensures the aspect ratio is maintained
                ),
              ),
), 
            SizedBox(height: 30),
            Text(
              "DEL SHOP",
              style: TextStyle(
                color: const Color.fromARGB(255, 52, 65, 144),
                fontSize: 45,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Kata Sandi",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            GestureDetector(
              onTap: _login, // Panggil fungsi login saat tombol Masuk ditekan
              child: Container(
                height: 50,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(255, 52, 65, 144),
                ),
                child: Center(
                  child: Text(
                    "Masuk",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () => Navigator.of(context).pushNamed("/register"),
              child: Text(
                "Belum punya akun? Daftar",
                style: TextStyle(
                  color: const Color.fromARGB(255, 52, 65, 144),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
