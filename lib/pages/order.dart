import 'package:flutter/material.dart';

class OrderConfirmationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Confirmation'),
        backgroundColor: Colors.brown,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, color: Colors.green, size: 100),
            SizedBox(height: 20),
            Text(
              'Your order has been successfully placed!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.brown),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Optionally, navigate back to home or shopping page
                Navigator.of(context).pushReplacementNamed('/menu');
              },
              child: Text('Back to Home'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown, // Button color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
