import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final cartItems = cart.items.values.toList();
    final cartKeys = cart.items.keys.toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("SHOPPING BAG",
            style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 3)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black, size: 20),
      ),
      body: cart.items.isEmpty
          ? _buildEmptyState(context)
          : Column(
        children: [
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemBuilder: (ctx, i) => _buildCartItem(cartKeys[i], cartItems[i], cart, context),
            ),
          ),
          _buildSummary(cart, context),
        ],
      ),
    );
  }

  Widget _buildCartItem(String productId, CartItem item, CartProvider cart, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFF6F6F6)))),
      child: Row(
        children: [
          Container(
            width: 80, height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              image: DecorationImage(image: AssetImage(item.image), fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11)),
                Text("SIZE: ${item.size}", style: const TextStyle(color: Colors.grey, fontSize: 10)),
                const SizedBox(height: 8),
                Text("Rs. ${item.price.toStringAsFixed(0)}", style: const TextStyle(fontWeight: FontWeight.w900)),
              ],
            ),
          ),
          IconButton(icon: const Icon(Icons.close, size: 18), onPressed: () => cart.removeItem(productId))
        ],
      ),
    );
  }

  Widget _buildSummary(CartProvider cart, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("TOTAL"), Text("Rs. ${cart.totalAmount.toStringAsFixed(0)}", style: const TextStyle(fontWeight: FontWeight.bold))]),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity, height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              onPressed: () => Navigator.of(context).pushNamed('/checkout'),
              child: const Text("PROCEED TO CHECKOUT", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return const Center(child: Text("YOUR BAG IS EMPTY"));
  }
}