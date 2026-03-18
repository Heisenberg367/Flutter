import 'package:flutter/material.dart';

// Simple Product class
class Product {
  final String name;
  final String category;
  final double price; // price in KSh
  final String imageUrl; // optional for later use

  Product({
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
  });
}

// Sample product list
List<Product> products = [
  Product(
    name: "iPhone 14",
    category: "Phones",
    price: 120000,
    imageUrl: "assets/images/iphone14.png",
  ),
  Product(
    name: "Phillips LED Light",
    category: "Lighting",
    price: 2500,
    imageUrl: "assets/images/led_light.png",
  ),
  Product(
    name: "Charging Cable",
    category: "Cables",
    price: 500,
    imageUrl: "assets/images/cable.png",
  ),
  Product(
    name: "Bluetooth Headphones",
    category: "Electronics Accessories",
    price: 4500,
    imageUrl: "assets/images/headphones.png",
  ),
  Product(
    name: "Samsung Smart TV",
    category: "Electronics Accessories",
    price: 10000,
    imageUrl: "assets/images/smarttv.png",
  ),
];