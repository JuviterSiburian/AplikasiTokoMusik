// lib/models/product.dart
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageAsset;
  final String category;
  final Map<String, String> specifications;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageAsset,
    required this.category,
    required this.specifications,
  });
}