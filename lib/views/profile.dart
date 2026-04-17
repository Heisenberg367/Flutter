import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_application_b/views/homescreen.dart';
import 'package:flutter_application_b/views/cart.dart';
import 'package:flutter_application_b/views/orders.dart';
import 'package:flutter_application_b/views/Login%20screen.dart';
import 'package:get/get.dart';
import 'package:flutter_application_b/controllers/Login%20controller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentIndex = 3;
  Map<String, dynamic> userData = {};
  bool isLoading = true;

  final Logincontoller loginController = Get.find<Logincontoller>();

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      final userId = loginController.userId.value;
      var response = await http.get(
        Uri.parse("http://localhost/oldtraffold/get_user.php?user_id=$userId"),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data["code"] == 1) {
          setState(() {
            userData = data["user"];
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
      debugPrint("Error fetching profile: $e");
    }
  }

  void _handleLogout() {
    Get.dialog(
      AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              loginController.isLoggedIn.value = false;
              loginController.userId.value = 0;
              loginController.userFullName.value = '';
              loginController.userEmail.value = '';
              loginController.userPhone.value = '';
              Get.offAll(() => const LoginScreen());
            },
            child: const Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(251, 10, 213, 207),
        title: const Text(
          "My Profile",
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
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  // Avatar
                  CircleAvatar(
                    radius: 50,
                    backgroundColor:
                        const Color.fromARGB(251, 10, 213, 207),
                    child: Text(
                      (userData["full_name"] ?? "U")
                          .substring(0, 1)
                          .toUpperCase(),
                      style: const TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Full name
                  Text(
                    userData["full_name"] ?? "Unknown",
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  // Email
                  Text(
                    userData["Email"] ?? "",
                    style: const TextStyle(
                        fontSize: 15, color: Colors.black54),
                  ),
                  const SizedBox(height: 4),
                  // Phone
                  Text(
                    userData["Phone"] ?? "",
                    style: const TextStyle(
                        fontSize: 15, color: Colors.black54),
                  ),
                  const SizedBox(height: 30),
                  // Profile options
                  profileOption(Icons.person, "Username",
                      userData["Username"] ?? ""),
                  profileOption(Icons.location_on, "Address",
                      userData["address"] ?? "Not set"),
                  profileOption(Icons.history, "Order History", "",
                      onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const OrdersScreen()));
                  }),
                  profileOption(Icons.logout, "Logout", "",
                      onTap: _handleLogout,
                      iconColor: Colors.red),
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
          } else if (index == 2) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(
                    builder: (context) => const OrdersScreen()));
          }
        },
      ),
    );
  }

  Widget profileOption(IconData icon, String title, String subtitle,
      {VoidCallback? onTap, Color iconColor = const Color.fromARGB(251, 10, 213, 207)}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: GestureDetector(
        onTap: onTap ?? () {},
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 6,
                  offset: const Offset(0, 2)),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: iconColor),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600)),
                  if (subtitle.isNotEmpty)
                    Text(subtitle,
                        style: const TextStyle(
                            fontSize: 13, color: Colors.black54)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}