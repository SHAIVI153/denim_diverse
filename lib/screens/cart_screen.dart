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
              itemBuilder: (ctx, i) {
                return _buildCartItem(cartKeys[i], cartItems[i], cart);
              },
            ),
          ),
          _buildSummarySection(cart, context),
        ],
      ),
    );
  }

  Widget _buildCartItem(String productId, CartItem item, CartProvider cart) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Container(
            width: 100,
            height: 135,
            decoration: BoxDecoration(
              color: const Color(0xFFF9F9F9),
              image: DecorationImage(
                image: AssetImage(item.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 20),
          // Details Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item.name.toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1.2)),
                    GestureDetector(
                      onTap: () => cart.removeItem(productId),
                      child: const Icon(Icons.close, size: 14, color: Colors.black),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text("SIZE: ${item.size}",
                    style: const TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold)),

                const SizedBox(height: 30), // Spacing adjusted after removing discount tag

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Quantity Switcher
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 0.8),
                      ),
                      child: Row(
                        children: [
                          _qtyBtn(Icons.remove, () => cart.removeSingleItem(productId)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text("${item.quantity}",
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                          _qtyBtn(Icons.add, () => cart.addItem(productId, item.price, item.name, item.image, item.size)),
                        ],
                      ),
                    ),
                    // Price (Only current price)
                    Text("Rs. ${(item.price * item.quantity).toStringAsFixed(0)}",
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        color: Colors.white,
        child: Icon(icon, size: 12, color: Colors.black),
      ),
    );
  }

  Widget _buildSummarySection(CartProvider cart, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: Column(
        children: [
          _summaryRow("SUBTOTAL", "Rs. ${cart.totalAmount.toStringAsFixed(0)}"),
          const SizedBox(height: 10),
          _summaryRow("SHIPPING", "FREE", isGreen: true),
          const SizedBox(height: 25),
          const Divider(),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("TOTAL", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 1)),
              Text("Rs. ${cart.totalAmountAfterDiscount.toStringAsFixed(0)}",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
            ],
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                elevation: 0,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              ),
              onPressed: () => Navigator.pushNamed(context, '/checkout'),
              child: const Text("PROCEED TO CHECKOUT",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 11)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isGreen = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1)),
        Text(value, style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            color: isGreen ? Colors.green : Colors.black
        )),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("YOUR BAG IS EMPTY",
              style: TextStyle(letterSpacing: 3, fontWeight: FontWeight.w900, fontSize: 13)),
          const SizedBox(height: 20),
          _blackOutlineButton("SHOP COLLECTION", () => Navigator.pop(context)),
        ],
      ),
    );
  }

  Widget _blackOutlineButton(String text, VoidCallback onTap) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.black),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      ),
      child: Text(text, style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2)),
    );
  }
}