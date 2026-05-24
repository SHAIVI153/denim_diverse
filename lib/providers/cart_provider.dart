import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String name;
  final int quantity;
  final double price;
  final double originalPrice;
  final String image;
  final String size;

  const CartItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    required this.originalPrice,
    required this.image,
    required this.size,
  });

  CartItem copyWith({int? quantity}) => CartItem(
    id: id,
    name: name,
    quantity: quantity ?? this.quantity,
    price: price,
    originalPrice: originalPrice,
    image: image,
    size: size,
  );
}

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};
  int get itemCount => _items.values.fold(0, (sum, item) => sum + item.quantity);
  int get uniqueCount => _items.length;

  double get totalAmount =>
      _items.values.fold(0.0, (sum, item) => sum + item.price * item.quantity);

  double get totalSavings => _items.values
      .fold(0.0, (sum, item) => sum + (item.originalPrice - item.price) * item.quantity);

  bool contains(String productId) => _items.containsKey(productId);

  void addItem(String productId, double price, String title, String imageUrl, String size) {
    final double originalPrice = price / 0.6;
    if (_items.containsKey(productId)) {
      _items.update(productId, (e) => e.copyWith(quantity: e.quantity + 1));
    } else {
      _items[productId] = CartItem(
        id: productId,
        name: title,
        price: price,
        originalPrice: originalPrice,
        image: imageUrl,
        quantity: 1,
        size: size,
      );
    }
    notifyListeners();
  }

  void increaseQuantity(String productId) {
    if (_items.containsKey(productId)) {
      _items.update(productId, (e) => e.copyWith(quantity: e.quantity + 1));
      notifyListeners();
    }
  }

  void decreaseQuantity(String productId) {
    if (!_items.containsKey(productId)) return;
    if (_items[productId]!.quantity > 1) {
      _items.update(productId, (e) => e.copyWith(quantity: e.quantity - 1));
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
    _items.clear();
    notifyListeners();
  }
}