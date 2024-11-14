// file: lib/providers/cart_provider.dart

import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
  });
}

class CatalogItem {
  final String id;
  final String name;
  final double price;
  final String imageUrl;

  CatalogItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
  });
}

class CartProvider with ChangeNotifier {
  // Map untuk menyimpan items dalam keranjang
  final Map<String, CartItem> _items = {};

  // Getter untuk mengakses items
  Map<String, CartItem> get items => {..._items};

  // Getter untuk jumlah total item di keranjang
  int get itemCount => _items.length;

  // Getter untuk total harga
  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  // Menambah item ke keranjang
  void addItem(CatalogItem product) {
    if (_items.containsKey(product.id)) {
      // Jika item sudah ada, tambah quantity
      _items.update(
        product.id,
            (existingCartItem) => CartItem(
          id: existingCartItem.id,
          name: existingCartItem.name,
          price: existingCartItem.price,
          imageUrl: existingCartItem.imageUrl,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      // Jika item belum ada, tambahkan item baru
      _items.putIfAbsent(
        product.id,
            () => CartItem(
          id: product.id,
          name: product.name,
          price: product.price,
          imageUrl: product.imageUrl,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  // Menghapus item dari keranjang
  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  // Mengurangi quantity item
  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
            (existingCartItem) => CartItem(
          id: existingCartItem.id,
          name: existingCartItem.name,
          price: existingCartItem.price,
          imageUrl: existingCartItem.imageUrl,
          quantity: existingCartItem.quantity - 1,
        ),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  // Update quantity item
  void updateQuantity(String productId, int newQuantity) {
    if (_items.containsKey(productId) && newQuantity > 0) {
      _items.update(
        productId,
            (existingCartItem) => CartItem(
          id: existingCartItem.id,
          name: existingCartItem.name,
          price: existingCartItem.price,
          imageUrl: existingCartItem.imageUrl,
          quantity: newQuantity,
        ),
      );
      notifyListeners();
    } else if (newQuantity <= 0) {
      removeItem(productId);
    }
  }

  // Mengosongkan keranjang
  void clear() {
    _items.clear();
    notifyListeners();
  }

  // Cek apakah item ada di keranjang
  bool isInCart(String productId) {
    return _items.containsKey(productId);
  }

  // Mendapatkan quantity item tertentu
  int getItemQuantity(String productId) {
    if (_items.containsKey(productId)) {
      return _items[productId]!.quantity;
    }
    return 0;
  }
}