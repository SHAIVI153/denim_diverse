import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';
import 'package:intl/intl.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<OrderProvider>(context);
    final orders = orderData.orders;
    double width = MediaQuery.of(context).size.width;
    bool isWeb = width > 950;

    // Revenue calculation fix
    double totalRevenue = orders.fold(0.0, (sum, item) => sum + item.amount);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("ADMIN PANEL - ORDERS",
            style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 2)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: orders.isEmpty
          ? const Center(child: Text("NO ORDERS RECEIVED YET", style: TextStyle(color: Colors.grey, letterSpacing: 1)))
          : SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: isWeb ? width * 0.1 : 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatCard("TOTAL REVENUE", "Rs. ${totalRevenue.toStringAsFixed(0)}"),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("RECENT ORDERS", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 1)),
                Text("${orders.length} TOTAL", style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(height: 30),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: orders.length,
              itemBuilder: (ctx, i) {
                final order = orders[i];
                return Card(
                  elevation: 0,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey.shade100),
                  ),
                  child: ExpansionTile(
                    shape: const RoundedRectangleBorder(),
                    leading: const CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 18,
                      child: Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 16),
                    ),
                    title: Text(order.userName.toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 0.5)),
                    subtitle: Text(DateFormat('dd MMM, hh:mm a').format(order.dateTime),
                        style: const TextStyle(fontSize: 10, color: Colors.grey)),
                    trailing: Text("Rs. ${order.amount.toStringAsFixed(0)}",
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20.0),
                        color: const Color(0xFFFAFAFA),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _infoRow("CUSTOMER", order.userName),
                            // FIX: order.address ko order.userAddress se replace kiya
                            _infoRow("ADDRESS", order.userAddress),
                            _infoRow("PHONE", order.userPhone),
                            const Divider(height: 30),
                            const Text("ITEMS SUMMARY", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                            const SizedBox(height: 15),

                            ...order.products.map((p) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            p.name,
                                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            "Size: ${p.size ?? 'N/A'} | Qty: ${p.quantity}",
                                            style: const TextStyle(fontSize: 10, color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      "Rs. ${(p.price * p.quantity).toStringAsFixed(0)}",
                                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),

                            const Divider(height: 30),
                            _infoRow("TOTAL PAID", "Rs. ${order.amount.toStringAsFixed(0)}", isBold: true),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white70, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 2)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900, letterSpacing: 1)),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 80,
              child: Text("$label:", style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold))
          ),
          Expanded(
              child: Text(value,
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                      color: Colors.black
                  )
              )
          ),
        ],
      ),
    );
  }
}