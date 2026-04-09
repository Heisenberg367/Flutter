import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  var cartItems = <Map<String, dynamic>>[].obs;

  void addToCart(Map<String, dynamic> product) {
    final String productId = product["id"]?.toString() ?? "";
    if (productId.isEmpty) return;

    int index = cartItems.indexWhere((item) => item["id"] == productId);

    if (index != -1) {
      final updated = Map<String, dynamic>.from(cartItems[index]);
      updated["quantity"] = (updated["quantity"] as int) + 1;
      cartItems[index] = updated;
      cartItems.refresh();
    } else {
      cartItems.add({
        "id": productId,
        "name": product["name"]?.toString() ?? "",
        "price": product["price"]?.toString() ?? "0",
        "image_url": product["image_url"]?.toString() ?? "",
        "quantity": 1,
      });
    }

    Get.snackbar(
      "Added to Cart",
      "${product["name"]} added to cart",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF0AD5CF),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(12),
    );
  }

  void removeFromCart(String productId) {
    cartItems.removeWhere((item) => item["id"] == productId);
  }

  void incrementQuantity(String productId) {
    int index = cartItems.indexWhere((item) => item["id"] == productId);
    if (index == -1) return;
    final updated = Map<String, dynamic>.from(cartItems[index]);
    updated["quantity"] = (updated["quantity"] as int) + 1;
    cartItems[index] = updated;
    cartItems.refresh();
  }

  void decrementQuantity(String productId) {
    int index = cartItems.indexWhere((item) => item["id"] == productId);
    if (index == -1) return;
    final int currentQty = cartItems[index]["quantity"] as int;
    if (currentQty > 1) {
      final updated = Map<String, dynamic>.from(cartItems[index]);
      updated["quantity"] = currentQty - 1;
      cartItems[index] = updated;
      cartItems.refresh();
    } else {
      removeFromCart(productId);
    }
  }

  double get totalPrice {
    return cartItems.fold(0.0, (double sum, item) {
      final double price = double.tryParse(item["price"].toString()) ?? 0.0;
      final int qty = item["quantity"] as int? ?? 1;
      return sum + (price * qty);
    });
  }

  int get totalItems {
    return cartItems.fold(0, (int sum, item) {
      return sum + (item["quantity"] as int? ?? 1);
    });
  }

  void clearCart() => cartItems.clear();
}