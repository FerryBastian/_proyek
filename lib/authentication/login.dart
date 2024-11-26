import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Email input field
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            // Password input field
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            // Login button
            ElevatedButton(
              onPressed: () async {
                await _login(context);
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),
            // Registration buttons
            Text(
              "Register as:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/registerUser');
                  },
                  child: const Text('User'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/registerAdmin');
                  },
                  child: const Text('Admin'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _login(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields!')),
      );
      return;
    }

    try {
      // Authenticate with Firebase
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Check the user role in Firestore
        var userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        if (userDoc.exists) {
          String role = userDoc['role'];
          // Navigate based on the role
          if (role == 'admin') {
            debugPrint('Navigating to Admin Page');
            Navigator.pushReplacementNamed(context, '/adminPage');
          } else if (role == 'user') {
            debugPrint('Navigating to User Page');
            Navigator.pushReplacementNamed(context, '/menu');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Invalid role.')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User data not found in the database.')),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = '';
      if (e.code == 'user-not-found') {
        errorMessage = 'User not found.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Incorrect password.';
      } else {
        errorMessage = 'An error occurred. Please try again.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }
}
