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
                return _buildCartItem(cartKeys[i], cartItems[i], cart, context);
              },
            ),
          ),
          _buildSummary(cart, context),
        ],
      ),
    );
  }

  Widget _buildCartItem(String productId, CartItem item, CartProvider cart, BuildContext context) {
    return Dismissible(
      key: ValueKey(productId),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.redAccent,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) => cart.removeItem(productId),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFF6F6F6))),
        ),
        child: Row(
          children: [
            // Product Image
            Container(
              width: 90,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFF6F6F6),
                borderRadius: BorderRadius.circular(4),
                image: DecorationImage(
                  image: AssetImage(item.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 15),
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1)),
                  const SizedBox(height: 4),
                  Text("SIZE: ${item.size}",
                      style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text("Rs. ${item.price.toStringAsFixed(0)}",
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
                  const SizedBox(height: 15),
                  // Quantity Selector
                  Row(
                    children: [
                      _qtyBtn(Icons.remove, () => cart.removeSingleItem(productId)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text("${item.quantity}",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      ),
                      _qtyBtn(Icons.add, () {
                        cart.addItem(productId, item.price, item.name, item.image, item.size);
                      }),
                    ],
                  )
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 18, color: Colors.grey),
              onPressed: () => cart.removeItem(productId),
            )
          ],
        ),
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 14, color: Colors.black),
      ),
    );
  }

  Widget _buildSummary(CartProvider cart, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: SafeArea(
        child: Column(
          children: [
            _summaryRow("SUBTOTAL", "Rs. ${cart.totalAmount.toStringAsFixed(0)}"),
            const SizedBox(height: 10),
            _summaryRow("SHIPPING", "FREE", isGreen: true),
            const Divider(height: 30),
            _summaryRow("ESTIMATED TOTAL", "Rs. ${cart.totalAmount.toStringAsFixed(0)}", isBold: true),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  // Checkout logic yahan aye gi
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  elevation: 0,
                ),
                child: const Text("PROCEED TO CHECKOUT",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 2, fontSize: 12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isGreen = false, bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1)),
        Text(value, style: TextStyle(
            fontSize: isBold ? 15 : 12,
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
          Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey.shade200),
          const SizedBox(height: 20),
          const Text("YOUR BAG IS EMPTY",
              style: TextStyle(letterSpacing: 3, fontWeight: FontWeight.w900, fontSize: 13)),
          const SizedBox(height: 10),
          const Text("Looks like you haven't added anything yet.",
              style: TextStyle(color: Colors.grey, fontSize: 11)),
          const SizedBox(height: 30),
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.black),
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            ),
            child: const Text("SHOP COLLECTION",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 11)),
          ),
        ],
      ),
    );
  }
}