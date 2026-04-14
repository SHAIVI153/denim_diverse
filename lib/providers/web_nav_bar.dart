import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class WebNavBar extends StatelessWidget {
  const WebNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. TOP BLUE BAR (Contact & Settings)
        Container(
          height: 40,
          color: const Color(0xFF0066D4), // Exactly like your image
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Row(
            children: [
              _topBarItem(Icons.email_outlined, "support@denimdiverse.com"),
              const SizedBox(width: 20),
              _topBarItem(Icons.phone_outlined, "+92 300 1234567"),
              const Spacer(),
              const Text("Welcome to Our Store!",
                  style: TextStyle(color: Colors.white, fontSize: 10, letterSpacing: 0.5)),
              const SizedBox(width: 20),
              _topBarDropdown("English"),
              const SizedBox(width: 20),
              _topBarDropdown("PKR"),
            ],
          ),
        ),

        // 2. MAIN WHITE NAVBAR (Logo & Links)
        Container(
          height: 80,
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Row(
            children: [
              // BRAND LOGO
              Text("PressMart.",
                  style: GoogleFonts.montserrat(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.black)),

              const Spacer(),

              // NAV LINKS
              _navLink("Home"),
              _navLink("Shop"),
              _navLink("Pages"),
              _navLink("Blog"),
              _navLink("Elements"),
              _navLink("Buy"),

              const SizedBox(width: 40),

              // ACTION ICONS
              IconButton(onPressed: () {}, icon: const Icon(Icons.person_outline, size: 22)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.search, size: 22)),
              _iconWithBadge(Icons.favorite_border, "0"),

              // CART ICON WITH LOGIC
              Consumer<CartProvider>(
                builder: (context, cart, child) =>
                    _iconWithBadge(Icons.shopping_cart_outlined, "${cart.itemCount}", onTap: () {
                      Navigator.pushNamed(context, '/cart');
                    }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- Helper Widgets ---

  Widget _topBarItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 14),
        const SizedBox(width: 5),
        Text(text, style: const TextStyle(color: Colors.white, fontSize: 10)),
      ],
    );
  }

  Widget _topBarDropdown(String text) {
    return Row(
      children: [
        Text(text, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
        const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 14),
      ],
    );
  }

  Widget _navLink(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const Icon(Icons.keyboard_arrow_down, size: 16),
        ],
      ),
    );
  }

  Widget _iconWithBadge(IconData icon, String count, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Badge(
          label: Text(count, style: const TextStyle(fontSize: 8)),
          backgroundColor: const Color(0xFF0066D4),
          child: Icon(icon, size: 22),
        ),
      ),
    );
  }
}