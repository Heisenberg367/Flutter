import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_application_b/views/homescreen.dart';
import 'package:flutter_application_b/views/cart.dart';
import 'package:flutter_application_b/views/profile.dart';
import 'package:get/get.dart';
import 'package:flutter_application_b/controllers/Login%20controller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int _currentIndex = 2;
  List orders = [];
  bool isLoading = true;

  final Logincontoller loginController = Get.find<Logincontoller>();

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      final userId = loginController.userId.value;
      var response = await http.get(
        Uri.parse("http://localhost/oldtraffold/get_orders.php?user_id=$userId"),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data["code"] == 1) {
          setState(() {
            orders = data["orders"];
            isLoading = false;
          });
        } else {
          setState(() => isLoading = false);
        }
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint("Error fetching orders: $e");
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'delivered':
        return Colors.green;
      case 'shipped':
        return Colors.blue;
      case 'processing':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(251, 10, 213, 207),
        title: const Text(
          "My Orders",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(251, 10, 213, 207),
              ),
            )
          : orders.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.receipt_long,
                          size: 80, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      const Text(
                        "No orders yet",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Your orders will appear here",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return orderItem(order);
                  },
                ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: const Color.fromARGB(251, 10, 213, 207),
        color: Colors.white,
        buttonBackgroundColor: const Color.fromARGB(251, 10, 213, 207),
        index: _currentIndex,
        items: const <Widget>[
          Icon(Icons.home, size: 30, color: Colors.black),
          Icon(Icons.shopping_cart, size: 30, color: Colors.black),
          Icon(Icons.receipt_long, size: 30, color: Colors.black),
          Icon(Icons.person, size: 30, color: Colors.black),
        ],
        onTap: (index) {
          if (index == _currentIndex) return;
          setState(() => _currentIndex = index);
          if (index == 0) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const Homescreen()));
          } else if (index == 1) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const CartScreen()));
          } else if (index == 3) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()));
          }
        },
      ),
    );
  }

  Widget orderItem(Map<String, dynamic> order) {
    final status = order["status"] ?? "pending";
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Order #${order["id"]}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor(status).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    color: _statusColor(status),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Date: ${order["created_at"].toString().substring(0, 10)}",
            style: const TextStyle(color: Colors.black54, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            "Total: KSh ${double.parse(order["total_amount"].toString()).toStringAsFixed(2)}",
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
                fontSize: 15),
          ),
        ],
      ),
    );
  }
}