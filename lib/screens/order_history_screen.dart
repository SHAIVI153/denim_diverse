import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ACTUAL DATA FROM PROVIDER
    final orderData = Provider.of<OrderProvider>(context);
    final orders = orderData.orders;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("MY ORDERS",
            style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 2)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: orders.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_bag_outlined, size: 50, color: Colors.grey),
            const SizedBox(height: 10),
            const Text("NO ORDERS PLACED YET", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: orders.length,
        itemBuilder: (ctx, i) {
          final order = orders[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("ORDER: #${order.id.substring(0, 5)}",
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
                    _buildStatusBadge("PENDING"),
                  ],
                ),
                const SizedBox(height: 10),
                // Isme products ke naam show honge
                Text(order.products.map((p) => p.name).join(", "),
                    style: const TextStyle(color: Colors.grey, fontSize: 11)),
                const Divider(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Rs. ${order.amount.toStringAsFixed(0)}",
                        style: const TextStyle(fontWeight: FontWeight.w900)),
                    Text(order.dateTime.toString().split('.')[0], // Date dikhane ke liye
                        style: const TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: Colors.orange.shade50,
      child: Text(status, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.orange)),
    );
  }
}