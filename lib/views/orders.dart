import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(251, 10, 213, 207),
        title: const Text("My Orders"),
      ),
      body: ListView(
        children: [
          orderItem("Order #001", "2 Items", 3500),
          orderItem("Order #002", "1 Item", 12000),
          orderItem("Order #003", "3 Items", 5000),
        ],
      ),
    );
  }

  // Simple order item widget
  Widget orderItem(String orderId, String items, double totalPrice) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Order details
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(orderId,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 4),
              Text(items, style: const TextStyle(color: Colors.black54)),
            ],
          ),

          // Price
          Text(
            "KSh ${totalPrice.toStringAsFixed(0)}",
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.green),
          ),
        ],
      ),
    );
  }
}