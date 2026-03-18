import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'homescreen.dart';

class OrderConfirmationScreen extends StatefulWidget {
  const OrderConfirmationScreen({super.key});

  @override
  State<OrderConfirmationScreen> createState() => _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(251, 10, 213, 207),
        title: const Text("Order Confirmation"),
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
                decoration: BoxDecoration(
                  color: Color.fromARGB(251, 10, 213, 207),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, size: 60, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            // Success Message
            const Center(
              child: Text(
                "Order Placed Successfully!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
            // Order Details Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                "Order Details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  orderDetailRow("Phone", "2", 250),
                  orderDetailRow("LED Light", "1", 50),
                  orderDetailRow("Cable", "3", 15),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Total
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
                  children: const [
                    Text("Total",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("KSh 595.00",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Delivery Info Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                "Delivery Info",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  deliveryInfoRow(Icons.local_shipping, "Estimated Delivery: 2-3 days"),
                  const SizedBox(height: 10),
                  deliveryInfoRow(Icons.location_on, "Delivery Address: Nairobi, Kenya"),
                  const SizedBox(height: 10),
                  deliveryInfoRow(Icons.payment, "Payment: M-Pesa"),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Back to Home Button
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(251, 10, 213, 207),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const Homescreen()),
                    (route) => false,
                  );
                },
                child: const Text("Back to Home",
                    style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Color.fromARGB(251, 10, 213, 207),
        index: _currentIndex,
        items: const <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.shopping_cart, size: 30),
          Icon(Icons.person, size: 30),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  // Order detail row widget
  Widget orderDetailRow(String name, String quantity, double price) {
    double total = double.parse(quantity) * price;
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
          Text(name, style: const TextStyle(fontSize: 16)),
          Text("Qty: $quantity", style: const TextStyle(fontSize: 16)),
          Text("KSh ${total.toStringAsFixed(2)}",
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // Delivery info row widget
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
          Icon(icon, color: Color.fromARGB(251, 10, 213, 207)),
          const SizedBox(width: 12),
          Text(info, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

 
 
