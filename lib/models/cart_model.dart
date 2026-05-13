class Phone {
  final int id;
  final String name;
  final String description;
  final String category;
  final double price;
  int quantity; // mutable so cart can change it
  final int stockQuantity;
  final String imagePath;

  Phone({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    this.quantity = 1,
    required this.stockQuantity,
    required this.imagePath,
  });

  // Convert from Product to Phone (for cart use)
  factory Phone.fromProduct(dynamic product) {
    return Phone(
      id: product.id,
      name: product.name,
      description: product.description,
      category: product.category,
      price: product.price,
      stockQuantity: product.stockQuantity,
      imagePath: product.imageUrl,
    );
  }

  double get totalPrice => price * quantity;
}