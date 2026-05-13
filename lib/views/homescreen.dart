import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'cart.dart';
import 'profile.dart';
import 'orders.dart';
import 'product_details.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int _currentIndex = 0;
  List<Map<String, dynamic>> products = [];
  bool isLoading = true;
  String _selectedCategory = "All";

  static const String _baseUrl =
      "http://localhost/oldtraffold/get_products.php";

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      var response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          products = List<Map<String, dynamic>>.from(data);
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint("Error fetching products: $e");
    }
  }

  // Category filter getter
  List<Map<String, dynamic>> get filteredProducts {
    if (_selectedCategory == "All") return products;
    return products
        .where((p) => p["category"] == _selectedCategory)
        .toList();
  }

  void _onBottomNavTap(int index) {
    if (index == _currentIndex) return;
    setState(() => _currentIndex = index);

    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CartScreen()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OrdersScreen()),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(251, 10, 213, 207),
        elevation: 0,
        title: const Text(
          "Old Trafford",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner
              Container(
                margin: const EdgeInsets.all(12),
                height: 160,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(251, 10, 213, 207),
                      Color.fromARGB(255, 0, 150, 145),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 4)),
                  ],
                ),
                alignment: Alignment.center,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Karibu Customer! 🛍️",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Best electronics deals in Nairobi",
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                  ],
                ),
              ),

              // Categories
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text("Categories",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87)),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    "All",
                    "Lighting",
                    "Phones",
                    "Electronics Accessories",
                    "Cables"
                  ]
                      .map(
                        (category) => GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCategory = category;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: _selectedCategory == category
                                  ? const Color.fromARGB(251, 10, 213, 207)
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2))
                              ],
                            ),
                            child: Text(category,
                                style: TextStyle(
                                    color: _selectedCategory == category
                                        ? Colors.white
                                        : Colors.black54,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 16),

              // Products
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text("Featured Products",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87)),
              ),
              const SizedBox(height: 8),

              isLoading
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: CircularProgressIndicator(
                            color: Color.fromARGB(251, 10, 213, 207)),
                      ),
                    )
                  : filteredProducts.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(40),
                            child: Text(
                              "No products available.",
                              style: TextStyle(color: Colors.black54),
                            ),
                          ),
                        )
                      : Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 12),
                          child: Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: filteredProducts
                                .map(
                                  (product) => ProductDetails(
                                    product: product,
                                  ),
                                )
                                .toList(),
                          ),
                        ),
              const SizedBox(height: 16),
            ],
          ),
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
          Icon(Icons.receipt_long, size: 30, color: Colors.black),
          Icon(Icons.person, size: 30, color: Colors.black),
        ],
        onTap: _onBottomNavTap,
      ),
    );
  }
}