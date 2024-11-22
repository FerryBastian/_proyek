import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final String danaNumber = '081396261413'; // Dana number for payment
  bool _isProcessingPayment = false;
  final double totalPayment = 150000; // Example total payment amount

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pembayaran",
          style: TextStyle(color: Colors.brown, fontSize: 30),
        ),
        backgroundColor: Colors.brown[50],
        toolbarHeight: 100,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Your order details UI goes here...
            const SizedBox(height: 20),
            if (!_isProcessingPayment)
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _showPaymentConfirmationDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    backgroundColor: Colors.brown,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text(
                    "Bayar Sekarang",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            if (_isProcessingPayment)
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }

  // Show confirmation dialog with only the QR code image and payment total
  void _showPaymentConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text("Konfirmasi Pembayaran"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Show total payment amount
            Text(
              "Total Pembayaran: Rp ${totalPayment.toStringAsFixed(0)}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            // QR code image
            Image.asset(
              'assets/qr_code_image.jpg', // Path to your QR code image
              width: 200.0, // Set the size of the image
              height: 200.0,
              fit: BoxFit.cover, // Adjust the image to fit within the space
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Close the dialog
            },
            child: const Text("Tutup"),
          ),
        ],
      ),
    );
  }
}
