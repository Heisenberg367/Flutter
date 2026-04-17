import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_b/views/homescreen.dart';

class Logincontoller extends GetxController {
  var isLoggedIn = false.obs;

  // Stores logged-in user details
  var userId = 0.obs;
  var userName = ''.obs;
  var userEmail = ''.obs;
  var userPhone = ''.obs;
  var userFullName = ''.obs;

  Future<void> Login(String user, String pass) async {
    if (user.isEmpty || pass.isEmpty) {
      Get.snackbar("Error", "All fields are required");
      return;
    }

    try {
      var response = await http.post(
        Uri.parse("http://localhost/oldtraffold/login.php"),
        body: {
          "email": user,
          "password": pass,
        },
      );

      var data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["code"] == 1) {
        // Save user details from the response
        var user_data = data["userdetails"][0];
        userId.value = int.parse(user_data["Id"].toString());
        userName.value = user_data["Username"] ?? '';
        userEmail.value = user_data["Email"] ?? '';
        userPhone.value = user_data["Phone"] ?? '';
        userFullName.value = user_data["full_name"] ?? '';

        isLoggedIn.value = true;
        Get.snackbar("Success", "Login successful");
        Get.offAll(() => const Homescreen());
      } else {
        Get.snackbar("Error", data["message"] ?? "Invalid credentials");
      }
    } catch (e) {
      Get.snackbar("Error", "Server error. Make sure your server is running.");
      debugPrint("Server error: $e");
    }
  }
}