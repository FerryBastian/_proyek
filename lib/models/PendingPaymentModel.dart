class PendingPaymentModel {
  final String paymentImage;
  final double totalPayment;
  final String paymentMethod;
  final String status;

  PendingPaymentModel({
    required this.paymentImage,
    required this.totalPayment,
    required this.paymentMethod,
    required this.status,
  });
}
