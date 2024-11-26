import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminRegisterPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset('assets/logo.png'),
              ),
              const SizedBox(height: 30),
              const Text(
                "DAFTAR ADMIN",
                style: TextStyle(
                  color: Colors.brown,
                  fontSize: 45,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 50),
              _buildTextField(emailController, "Email Admin"),
              const SizedBox(height: 20),
              _buildTextField(passwordController, "Kata Sandi Admin", obscureText: true),
              const SizedBox(height: 20),
              _buildTextField(confirmPasswordController, "Konfirmasi Kata Sandi", obscureText: true),
              const SizedBox(height: 40),
              _buildSubmitButton(
                context,
                "Daftar Admin",
                role: 'admin',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context, String label, {required String role}) {
    return GestureDetector(
      onTap: () async {
        await _registerUser(context, role);
      },
      child: Container(
        height: 50,
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.brown,
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Future<void> _registerUser(BuildContext context, String role) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Isi semua kolom!')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kata sandi tidak cocok!')),
      );
      return;
    }

    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': email,
          'role': role,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Admin berhasil didaftarkan!')),
        );

        Navigator.of(context).pop();
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'email-already-in-use') {
        errorMessage = 'Email sudah terdaftar.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'Kata sandi terlalu lemah.';
      } else {
        errorMessage = 'Terjadi kesalahan.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }
}
