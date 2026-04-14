import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final dynamic order; // Aapka Order model

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Order ID: ${order.id}", style: const TextStyle(fontWeight: FontWeight.bold)),
            Text("Address: ${order.address}"),
            const Divider(),
            // ERROR FIX: Map logic for products
            ...order.products.map((p) {
              // Agar p ek Map hai (jo screenshots mein lag raha hai)
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // p.product.name ki jagah null-safe check
                    Expanded(
                      child: Text(
                        "${p['name'] ?? 'Item'} (${p['size'] ?? 'N/A'})",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    Text(
                      "Rs. ${p['price']} x ${p['quantity']}",
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              );
            }).toList(),
            const Divider(),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Total: Rs. ${order.totalAmount}",
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
              ),
            ),
          ],
        ),
      ),
    );
  }
}