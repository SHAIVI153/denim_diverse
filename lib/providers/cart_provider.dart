import 'package:flutter/material.dart';

// 1. Cart Item Model
class CartItem {
  final String id;
  final String name;
  final int quantity;
  final double price;         // Nayi price (After 40% Off)
  final double originalPrice; // Purani price (Jo cut hogi)
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

// 2. Cart Provider Class
class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};
  double _discount = 0.0;
  String _appliedPromo = "";

  Map<String, CartItem> get items => {..._items};
  int get itemCount => _items.length;
  double get discount => _discount;
  String get appliedPromo => _appliedPromo;

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  double get totalAmountAfterDiscount => totalAmount - _discount;

  // Item add karne ke liye
  void addItem(String productId, double price, String title, String imageUrl, String selectedSize) {
    // 40% Off logic: Agar product ki price discounted hai,
    // toh original price calculate karne ke liye hum use 0.6 se divide karte hain.
    double oldPrice = price / 0.6;

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
      _items.update(
        productId,
            (existing) => CartItem(
          id: existing.id,
          name: existing.name,
          price: existing.price,
          originalPrice: existing.originalPrice,
          image: existing.image,
          quantity: existing.quantity - 1,
          size: existing.size,
        ),
      );
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
    _discount = 0.0;
    _appliedPromo = "";
    notifyListeners();
  }

  void applyPromoCode(String code) {
    if (_appliedPromo.isNotEmpty) return;

    if (code.toUpperCase() == "DENIM10") {
      _discount = totalAmount * 0.10;
      _appliedPromo = code;
    } else if (code.toUpperCase() == "FIRST500") {
      _discount = 500.0;
      _appliedPromo = code;
    }
    notifyListeners();
  }
}