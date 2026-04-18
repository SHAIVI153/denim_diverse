import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  // Dummy Data: Real app mein ye Firebase ya Local DB se aayega
  final List<Map<String, dynamic>> orders = const [
    {
      'orderId': 'ORD-99281',
      'date': '12 March 2026',
      'status': 'DELIVERED',
      'amount': 5299.0,
      'items': 'Vintage Boot Cut, Classic Straight'
    },
    {
      'orderId': 'ORD-98120',
      'date': '05 April 2026',
      'status': 'IN TRANSIT',
      'amount': 2799.0,
      'items': 'High Waist Mom Fit'
    },
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool isWeb = width > 950;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("MY ORDERS",
            style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 2)),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: isWeb ? width * 0.2 : 20, vertical: 20),
        child: ListView.builder(
          itemCount: orders.length,
          itemBuilder: (ctx, i) {
            final order = orders[i];
            return Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(order['orderId'], style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
                      _buildStatusBadge(order['status']),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(order['items'], style: const TextStyle(color: Colors.grey, fontSize: 11)),
                  const Divider(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(order['date'], style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      Text("Rs. ${order['amount']}", style: const TextStyle(fontWeight: FontWeight.w900)),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: status == "DELIVERED" ? Colors.green.shade50 : Colors.orange.shade50,
      child: Text(
        status,
        style: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.bold,
          color: status == "DELIVERED" ? Colors.green : Colors.orange,
        ),
      ),
    );
  }
}