import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String name;
  final int quantity;
  final double price;
  final double originalPrice;
  final String image;
  final String size;

  CartItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    required this.originalPrice,
    required this.image,
    required this.size,
  });
}

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};
  int get itemCount => _items.length;

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) => total += cartItem.price * cartItem.quantity);
    return total;
  }

  void addItem(String productId, double price, String title, String imageUrl, String selectedSize) {
    double oldPrice = price / 0.6; // 40% discount calculation

    if (_items.containsKey(productId)) {
      _items.update(
        productId,
            (existing) => CartItem(
          id: existing.id,
          name: existing.name,
          price: existing.price,
          originalPrice: existing.originalPrice,
          image: existing.image,
          quantity: existing.quantity + 1,
          size: existing.size,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
            () => CartItem(
          id: productId,
          name: title,
          price: price,
          originalPrice: oldPrice,
          image: imageUrl,
          quantity: 1,
          size: selectedSize,
        ),
      );
    }
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) return;
    if (_items[productId]!.quantity > 1) {
      _items.update(productId, (existing) => CartItem(id: existing.id, name: existing.name, price: existing.price, originalPrice: existing.originalPrice, image: existing.image, quantity: existing.quantity - 1, size: existing.size));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}