import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_b/controllers/cart_controller.dart';

class ProductDetails extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetails({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // Get the shared CartController 
    final CartController cartController = Get.find<CartController>();

    double cardWidth = (MediaQuery.of(context).size.width - 36) / 2;

    return SizedBox(
      width: cardWidth,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: SizedBox(
                height: 120,
                width: double.infinity,
                child: Image.network(
                  product["image_url"] ?? "",
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[100],
                    height: 120,
                    child: const Icon(
                      Icons.image,
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),

            const Divider(height: 1),

            // Name
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 2),
              child: Text(
                product["name"] ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.black87,
                ),
              ),
            ),

            // Price
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                "KSh ${product["price"]}",
                style: const TextStyle(
                  color: Color.fromARGB(251, 10, 213, 207),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),

            //  Add to Cart button 
            Padding(
              padding: const EdgeInsets.all(8),
              child: Obx(() {
                // Check if item is already in cart
                bool inCart = cartController.cartItems
                    .any((item) => item["id"] == product["id"]?.toString());

                return GestureDetector(
                  onTap: () {
                    if (inCart) {
                      //  Go directly to cart if already added
                      Get.snackbar(
                        "Already in Cart",
                        "${product["name"]} is already in your cart",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.orange,
                        colorText: Colors.white,
                        duration: const Duration(seconds: 2),
                      );
                    } else {
                      //  Add to cart
                      cartController.addToCart({
                        "id": product["id"]?.toString() ?? "",
                        "name": product["name"] ?? "",
                        "price": product["price"] ?? "0",
                        "image_url": product["image_url"] ?? "",
                      });
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      //  Button changes colour when item is in cart
                      color: inCart
                          ? Colors.green
                          : const Color.fromARGB(251, 10, 213, 207),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          inCart
                              ? Icons.check
                              : Icons.add_shopping_cart,
                          color: Colors.white,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          inCart ? "Added!" : "Add to Cart",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}