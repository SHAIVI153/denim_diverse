import 'package:flutter/foundation.dart';
import 'cart_provider.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  final String name;
  final String email;
  final String address;
  final String city;
  final String phone;
  final String paymentMethod;
  String status;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
    required this.name,
    required this.email,
    required this.address,
    required this.city,
    required this.phone,
    required this.paymentMethod,
    this.status = 'Confirmed',
  });
}

class OrderProvider with ChangeNotifier {
  final List<OrderItem> _orders = [];

  List<OrderItem> get orders => [..._orders];
  bool get hasOrders => _orders.isNotEmpty;

  void placeOrder({
    required List<CartItem> cartProducts,
    required double total,
    required String name,
    required String email,
    required String address,
    required String city,
    required String phone,
    required String paymentMethod,
  }) {
    _orders.insert(
      0,
      OrderItem(
        id: 'DD-${DateTime.now().millisecondsSinceEpoch}',
        amount: total,
        dateTime: DateTime.now(),
        products: cartProducts,
        name: name,
        email: email,
        address: address,
        city: city,
        phone: phone,
        paymentMethod: paymentMethod,
      ),
    );
    notifyListeners();
  }
}