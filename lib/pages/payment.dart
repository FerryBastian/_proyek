import 'package:delshop_flutter_app/admin/transaksi.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Import this to use File
import 'package:delshop_flutter_app/models/PendingPaymentModel.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool _isProcessingPayment = false;
  bool _isPaymentPending = false;
  XFile? _paymentImage; // Variable to store the payment image
  late double totalPayment;
  final ImagePicker _picker = ImagePicker();

  // List to store pending payments
  List<PendingPaymentModel> pendingPayments = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    totalPayment = ModalRoute.of(context)?.settings.arguments as double;
  }

  // Function to pick an image
  Future<void> _pickPaymentImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _paymentImage = image;
      });
    }
  }

  // Function to save payment data to pending list
  void _savePaymentForApproval() {
    final pendingPayment = PendingPaymentModel(
      paymentImage: _paymentImage!.path,
      totalPayment: totalPayment,
      paymentMethod: "Dana (Transfer Bank)",
      status: "Pending", // Set status as Pending
    );

    setState(() {
      pendingPayments.add(pendingPayment); // Add to the list
    });

    // Optionally, save it to a database (e.g., Firebase)

    // Show confirmation to user
    _showPaymentSuccessDialog();
  }

  // Show a dialog after saving the payment
  void _showPaymentSuccessDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Pembayaran Tertunda"),
        content: const Text(
          "Pembayaran Anda telah berhasil diajukan dan menunggu persetujuan admin.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop(); // Go back to previous screen (or home page)
            },
            child: const Text("Tutup"),
          ),
        ],
      ),
    );
  }

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
            const Text(
              "Ringkasan Pembayaran",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 20),
            Card(
              color: Colors.brown[50],
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Pembayaran: Rp ${totalPayment.toStringAsFixed(0)}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Divider(color: Colors.brown[300]),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Metode Pembayaran: ",
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        Text(
                          "Dana (Transfer Bank)",
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Payment button
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

            // Display payment image upload section
            if (_isPaymentPending)
              Column(
                children: [
                  const SizedBox(height: 20),
                  Text("Status: Pembayaran dalam proses"),
                  const SizedBox(height: 10),
                  if (_paymentImage == null)
                    ElevatedButton(
                      onPressed: _pickPaymentImage,
                      child: const Text("Upload Bukti Pembayaran"),
                    ),
                  if (_paymentImage != null)
                    Column(
                      children: [
                        Image.file(
                          File(_paymentImage!.path),
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            // Save payment for approval (not navigate)
                            _savePaymentForApproval();
                          },
                          child: const Text("Kirim Bukti Pembayaran"),
                        ),
                      ],
                    ),
                ],
              ),
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
            Text(
              "Total Pembayaran: Rp ${totalPayment.toStringAsFixed(0)}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            Image.asset(
              'assets/qr_code_image.jpg', // Path to your QR code image
              width: 200.0,
              height: 200.0,
              fit: BoxFit.cover,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              setState(() {
                _isPaymentPending = true; // Set payment status to pending after confirmation
              });
            },
            child: const Text("Tutup"),
          ),
        ],
      ),
    );
  }
}
