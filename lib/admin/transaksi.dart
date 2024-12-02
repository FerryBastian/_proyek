import 'package:flutter/material.dart';
import 'dart:io'; // Import this to use File

class TransaksiPage extends StatefulWidget {
  final String paymentImage; // To receive the image path
  final String initialStatus; // To receive the payment status

  const TransaksiPage({super.key, required this.paymentImage, required this.initialStatus});

  @override
  State<TransaksiPage> createState() => _TransaksiPageState();
}

class _TransaksiPageState extends State<TransaksiPage> {
  bool isAdmin = true; // Simulate checking if the user is admin
  late String status;

  @override
  void initState() {
    super.initState();
    status = widget.initialStatus; // Initialize status from widget's initialStatus
  }

  // Function to handle admin approval of the payment
  void _approvePayment() {
    if (isAdmin) {
      // Show a confirmation dialog before proceeding with approval
      showDialog(
        context: context,
        barrierDismissible: false, // User cannot dismiss dialog by tapping outside
        builder: (ctx) => AlertDialog(
          title: const Text("Konfirmasi Pembayaran"),
          content: const Text("Apakah Anda yakin ingin menyetujui pembayaran ini?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(); // Close the dialog without making changes
              },
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(); // Close the dialog
                setState(() {
                  status = 'Completed'; // Update the payment status to 'Completed'
                });
                // Optionally, save the status update to a backend (Firebase/SQLite)
                // e.g., updatePaymentStatus(paymentId, 'Completed');
              },
              child: const Text("Setujui"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaksi - Review Pembayaran"),
      ),
      body: ListView(
        children: [
          Card(
            child: ListTile(
              title: Text("Payment Status: $status"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (status == 'Pending')
                    Image.file(
                      File(widget.paymentImage), // Display the uploaded image
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                ],
              ),
              trailing: status == 'Pending' && isAdmin
                  ? IconButton(
                      icon: const Icon(Icons.check),
                      onPressed: _approvePayment, // Admin approves payment action
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
