import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'cart.dart';
import 'profile.dart'; // 👈 add this import (adjust filename if different)

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(251, 10, 213, 207),
        title: const Text("Old Trafford"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner
            Container(
              margin: const EdgeInsets.all(12),
              height: 150,
              decoration: BoxDecoration(
                color: const Color.fromARGB(251, 10, 213, 207),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: const Text(
                "Karibu Customer!",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            // Categories
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text("Categories",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
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
                    .map((category) => Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(251, 10, 213, 207),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(category,
                              style:
                                  const TextStyle(color: Colors.white)),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
            // Products
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text("Featured Products",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.75,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12)),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(Icons.image,
                            size: 50, color: Colors.grey),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          "Product ${index + 1}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          "KSh ${(index + 1) * 1000}",
                          style: const TextStyle(color: Colors.green),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(251, 10, 213, 207),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text("Add to Cart",
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: const Color.fromARGB(251, 10, 213, 207),
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
          // 👇 navigation added here only
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CartScreen()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          }
        },
      ),
    );
  }
}