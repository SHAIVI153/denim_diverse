import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<OrderProvider>(context);
    double width = MediaQuery.of(context).size.width;
    bool isWeb = width > 950;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("MY ACCOUNT",
            style: GoogleFonts.montserrat(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.w900, // Thicker font for branding
                letterSpacing: 3
            )),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            horizontal: isWeb ? width * 0.1 : 20,
            vertical: 40
        ),
        child: isWeb
            ? Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 1, child: _buildUserInfo(context)),
            const SizedBox(width: 80),
            Expanded(flex: 2, child: _buildOrderHistory(context, orderData)),
          ],
        )
            : Column(
          children: [
            _buildUserInfo(context),
            const SizedBox(height: 50),
            _buildOrderHistory(context, orderData),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    return Column(
      children: [
        const CircleAvatar(
            radius: 55,
            backgroundColor: Color(0xFFF0F0F0),
            child: Icon(Icons.person_outline, size: 50, color: Colors.black)
        ),
        const SizedBox(height: 20),
        Text("SHAWAIZ NIAMAT",
            style: GoogleFonts.montserrat(fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 1.5)),
        const Text("shawaiz@shaiwicode.com",
            style: TextStyle(color: Colors.grey, fontSize: 12, letterSpacing: 0.5)),
        const SizedBox(height: 35),

        _profileTile("EDIT PROFILE", Icons.edit_outlined, () {}),
        _profileTile("MY ADDRESSES", Icons.location_on_outlined, () {}),
        _profileTile("TRACK SHIPMENT", Icons.local_shipping_outlined, () {
          Navigator.pushNamed(context, '/order-tracking');
        }),
        const SizedBox(height: 20),
        _profileTile("LOGOUT", Icons.logout_outlined, () {}, isRed: true),

        const SizedBox(height: 30),
        const Text("v 1.0.0 | © 2026 SHAWICODE",
            style: TextStyle(fontSize: 8, color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 1)),
      ],
    );
  }

  Widget _buildOrderHistory(BuildContext context, OrderProvider orderData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("ORDER HISTORY",
                style: GoogleFonts.montserrat(fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 2)),
            if(orderData.orders.isNotEmpty)
              Text("${orderData.orders.length} TOTAL", style: const TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold)),
          ],
        ),
        const Divider(height: 30, thickness: 1),

        orderData.orders.isEmpty
            ? _buildEmptyOrders()
            : ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: orderData.orders.length,
          itemBuilder: (ctx, i) {
            final order = orderData.orders[i];
            return Container(
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                iconColor: Colors.black,
                collapsedIconColor: Colors.black,
                shape: const RoundedRectangleBorder(),
                title: Text("ORDER #${order.id.substring(0, 8).toUpperCase()}",
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1)),
                subtitle: Text(DateFormat('dd MMM yyyy').format(order.dateTime),
                    style: const TextStyle(fontSize: 10, color: Colors.grey)),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("Rs. ${order.amount.toStringAsFixed(0)}",
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
                    const Text("DETAILS", style: TextStyle(fontSize: 8, color: Colors.blue, fontWeight: FontWeight.bold)),
                  ],
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _infoLine("Current Status", "DISPATCHED FROM LAHORE HUB", isStatus: true),
                        _infoLine("Shipping To", order.userAddress),
                        _infoLine("Customer", order.userName),
                        const Divider(height: 30),
                        const Text("ITEMS SUMMARY:", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1)),
                        const SizedBox(height: 15),
                        ...order.products.map((p) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              children: [
                                Container(width: 5, height: 5, decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle)),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                      "${p.name} (${p.size ?? 'N/A'}) x${p.quantity}",
                                      style: const TextStyle(fontSize: 11, letterSpacing: 0.5)
                                  ),
                                ),
                                Text(
                                    "Rs. ${(p.price * p.quantity).toStringAsFixed(0)}",
                                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11)
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        const SizedBox(height: 25),
                        // TRACK BUTTON
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                shape: const RoundedRectangleBorder()
                            ),
                            onPressed: () => Navigator.pushNamed(context, '/order-tracking'),
                            child: const Text("TRACK LIVE SHIPMENT",
                                style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // --- Helpers ---

  Widget _profileTile(String title, IconData icon, VoidCallback onTap, {bool isRed = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        dense: true,
        leading: Icon(icon, size: 18, color: isRed ? Colors.red : Colors.black),
        title: Text(title, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: isRed ? Colors.red : Colors.black, letterSpacing: 1)),
        trailing: const Icon(Icons.chevron_right, size: 14),
        tileColor: const Color(0xFFF9F9F9),
        onTap: onTap,
      ),
    );
  }

  Widget _infoLine(String label, String value, {bool isStatus = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text("$label ", style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Text(value.toUpperCase(), style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: isStatus ? Colors.green.shade700 : Colors.black,
                letterSpacing: 0.5
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyOrders() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80),
      decoration: BoxDecoration(
          color: const Color(0xFFFBFBFB),
          border: Border.all(color: Colors.grey.shade100)
      ),
      child: const Column(
        children: [
          Icon(Icons.inventory_2_outlined, color: Colors.grey, size: 45),
          SizedBox(height: 15),
          Text("NO RECENT ORDERS FOUND", style: TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 2)),
        ],
      ),
    );
  }
}