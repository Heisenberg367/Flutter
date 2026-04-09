import 'package:flutter/material.dart';
import 'package:flutter_application_b/configs/Routes.dart';
import 'package:flutter_application_b/views/Login%20screen.dart';
import 'package:get/get.dart'; // ✅ Use full get import, not just get_navigation
import 'package:flutter_application_b/controllers/cart_controller.dart';

void main() {
  Get.put(CartController()); 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: "/",
      getPages: routes,
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}