import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // For better Date formatting
import '../providers/order_provider.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<OrderProvider>(context);
    final orders = orderData.orders;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9), // Light grey background
      appBar: AppBar(
        title: Text(
          "ORDER HISTORY",
          style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
              color: Colors.black
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: orders.isEmpty
          ? _buildEmptyState(context)
          : ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        itemCount: orders.length,
        itemBuilder: (ctx, i) {
          final order = orders[i];
          return _buildOrderCard(context, order);
        },
      ),
    );
  }

  // --- EMPTY STATE ---
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 60, color: Colors.grey.shade300),
          const SizedBox(height: 15),
          Text(
            "NO ORDERS FOUND",
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w800,
                fontSize: 14,
                color: Colors.grey[400]
            ),
          ),
          const SizedBox(height: 10),
          const Text("Your purchase history will appear here.", style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  // --- INDIVIDUAL ORDER CARD ---
  Widget _buildOrderCard(BuildContext context, dynamic order) {
    // Format: "12 Oct, 2023 04:30 PM"
    String formattedDate = DateFormat('dd MMM, yyyy  hh:mm a').format(order.dateTime);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header: Order ID & Status
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ORDER #DD${order.id.substring(order.id.length - 5).toUpperCase()}",
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 0.5),
                    ),
                    const SizedBox(height: 4),
                    Text(formattedDate, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                  ],
                ),
                _buildStatusBadge("PROCESSING"),
              ],
            ),
          ),
          const Divider(height: 1),

          // 2. Product Thumbnails & Names
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                // Thumbnail images preview (shows up to 3)
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: order.products.length > 3 ? 3 : order.products.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.asset(
                            order.products[index].image,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => Container(color: Colors.grey[200], width: 50),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.products.map((p) => p.name).join(", "),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87),
                      ),
                      Text(
                        "${order.products.length} Items",
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // 3. Footer: Total Amount & Action
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("TOTAL AMOUNT", style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                    Text(
                      "Rs. ${order.amount.toStringAsFixed(0)}",
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: Colors.black),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    // Logic to view detail or reorder
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: const Text("VIEW DETAILS", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- STATUS BADGE ---
  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w900,
            color: Colors.blue.shade700,
            letterSpacing: 0.5
        ),
      ),
    );
  }
}