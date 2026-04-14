import 'package:flutter/material.dart';
import 'cart_provider.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products; // Yeh CartItem use karega jisme 'size' pehle se hai
  final DateTime dateTime;
  final String userName;
  final String userEmail;
  final String userAddress;
  final String userPhone;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
    required this.userName,
    required this.userEmail,
    required this.userAddress,
    required this.userPhone,
  });
}

class OrderProvider with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders => [..._orders];

  void addOrder(List<CartItem> cartProducts, double total, String name, String email, String address, String phone) {
    _orders.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        amount: total,
        dateTime: DateTime.now(),
        products: cartProducts, // Cart items copy ho rahe hain
        userName: name,
        userEmail: email,
        userAddress: address,
        userPhone: phone,
      ),
    );
    notifyListeners();
  }
}