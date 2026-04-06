import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_application_b/views/Checkoutscreen.dart';
import 'package:flutter_application_b/views/homescreen.dart';
import 'package:flutter_application_b/views/profile.dart';
import 'package:flutter_application_b/views/orders.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';

var myPhone = [];
bool loaded = false;

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    myPhone.clear(); 
    loaded = false;
    fetchPhones();
  }

  fetchPhones() async {
    var response = await http.get(
        Uri.parse("http://192.168.0.108/oldtraffold/get_products.php"));
    if (response.statusCode == 200) {
      var severData = jsonDecode(response.body);
      var phoneData = severData["products"];
      for (var item in phoneData) {
        myPhone.add({
          "name": item["name"],
          "price": item["price"],
          "quantity": "1",
          "imagePath": item["image_url"]
        });
      }
      setState(() {
        loaded = true;
      });
    } else {
      Get.snackbar("Error", "Server error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(251, 10, 213, 207),
        title: const Text("My Cart"),
      ),
      body: loaded
          ? SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: myPhone.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Image.network(
                              myPhone[index]["imagePath"] ?? "",
                              width: 100,
                              height: 100,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.image, size: 50),
                            ),
                            Column(children: [
                              Text(myPhone[index]["name"]),
                              Text("KSh ${myPhone[index]["price"]}"),
                            ]),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(251, 10, 213, 207),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CheckoutScreen()),
                      );
                    },
                    child: const Text("Proceed to Checkout",
                        style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Color.fromARGB(251, 10, 213, 207),
        index: _currentIndex,
        items: const <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.shopping_cart, size: 30),
          Icon(Icons.receipt_long, size: 30),
          Icon(Icons.person, size: 30),
        ],
        onTap: (index) {
          setState(() => _currentIndex = index);
          if (index == 0) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const Homescreen()));
          } else if (index == 2) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const OrdersScreen()));
          } else if (index == 3) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()));
          }
        },
      ),
      // widget
    );
  }

  Widget cartItem(String name, String quantity, double price) {
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
}