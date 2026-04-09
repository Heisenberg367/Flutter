import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_b/views/homescreen.dart';

class Logincontoller extends GetxController {
  var username;
  var password;
  var isLoggedIn = false.obs;

  Future<void> Login(String user, String pass) async {
    username = user;
    password = pass;

    if (username.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "All fields are required");
      return;
    }

    try {
      var response = await http.post(
        Uri.parse(("http://localhost/oldtraffold/login.php"),), 
        body: {
          "email": username,    
          "password": password,
        },
      );

      var data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["code"] == 1) { 
        isLoggedIn.value = true;
        Get.snackbar("Success", "Login successful");
        Get.offAll(() => const Homescreen());
      } else {
        Get.snackbar("Error", data["message"] ?? "Invalid credentials");
      }
    } catch (e) {
      Get.snackbar("Error", "Server error. Make sure your server is running and reachable.");
      print("Server error: $e");
    }
  }

  togglePassword() {
    isLoggedIn.value = !isLoggedIn.value;
  }
}