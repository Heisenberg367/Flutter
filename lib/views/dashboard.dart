import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_application_b/views/homescreen.dart';
import 'package:flutter_application_b/controllers/cart_controller.dart';
import 'package:get/get.dart';

class OrderConfirmationScreen extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final double total;

  const OrderConfirmationScreen({
    super.key,
    required this.items,
    required this.total,
  });

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    // ✅ Clear cart after order is confirmed
    final CartController cartController = Get.find<CartController>();
    cartController.clearCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(251, 10, 213, 207),
        title: const Text(
          "Order Confirmation",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            // Success Icon
            Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(251, 10, 213, 207),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, size: 60, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                "Order Placed Successfully!",
                style:
                    TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                "Thank you for your purchase.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 30),

            // Order Details
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                "Order Details",
                style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: widget.items.map((item) {
                  final double price =
                      double.tryParse(item["price"].toString()) ?? 0;
                  final int qty = item["quantity"] ?? 1;
                  final double itemTotal = price * qty;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 4,
                            offset: const Offset(0, 2)),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(item["name"] ?? "",
                              style: const TextStyle(fontSize: 15),
                              overflow: TextOverflow.ellipsis),
                        ),
                        Text("Qty: $qty",
                            style: const TextStyle(fontSize: 14)),
                        const SizedBox(width: 8),
                        Text("KSh ${itemTotal.toStringAsFixed(2)}",
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 12),

            // Real Total
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 4,
                        offset: const Offset(0, 2)),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(
                      "KSh ${widget.total.toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Delivery Info
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                "Delivery Info",
                style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  deliveryInfoRow(Icons.local_shipping,
                      "Estimated Delivery: 2-3 days"),
                  const SizedBox(height: 10),
                  deliveryInfoRow(Icons.location_on,
                      "Delivery Address: Nairobi, Kenya"),
                  const SizedBox(height: 10),
                  deliveryInfoRow(Icons.payment, "Payment: M-Pesa"),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Back to Home
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(251, 10, 213, 207),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Homescreen()),
                    (route) => false,
                  );
                },
                child: const Text("Back to Home",
                    style:
                        TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: const Color.fromARGB(251, 10, 213, 207),
        color: Colors.white,
        buttonBackgroundColor: const Color.fromARGB(251, 10, 213, 207),
        index: _currentIndex,
        items: const <Widget>[
          Icon(Icons.home, size: 30, color: Colors.black),
          Icon(Icons.shopping_cart, size: 30, color: Colors.black),
          Icon(Icons.person, size: 30, color: Colors.black),
        ],
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
      ),
    );
  }

  Widget deliveryInfoRow(IconData icon, String info) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 4,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color.fromARGB(251, 10, 213, 207)),
          const SizedBox(width: 12),
          Text(info, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}