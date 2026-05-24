import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../screens/collection_screen.dart';
import '../screens/crazy_deals_screen.dart';
import 'app_theme.dart';

class WebNavBar extends StatefulWidget implements PreferredSizeWidget {
  const WebNavBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  State<WebNavBar> createState() => _WebNavBarState();
}

class _WebNavBarState extends State<WebNavBar> {
  String? _hoveredItem;

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Row(
        children: [
          // Logo
          GestureDetector(
            onTap: () =>
                Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false),
            child: const Text(
              'DenimDiverse.',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 22,
                color: AppColors.black,
                letterSpacing: -0.5,
              ),
            ),
          ),

          const SizedBox(width: 60),

          // Nav Links
          _navLink('MEN', () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                  const CollectionScreen(initialCategory: 'MEN')))),
          _navLink('WOMEN', () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                  const CollectionScreen(initialCategory: 'WOMEN')))),
          _navLink('KIDS', () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                  const CollectionScreen(initialCategory: 'KIDS')))),
          _navLink('NEW ARRIVALS', () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CollectionScreen()))),
          _navLink(
            '🔥 CRAZY DEALS',
                () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const CrazyDealsScreen())),
            highlight: true,
          ),

          const Spacer(),

          // Actions
          IconButton(
            icon: const Icon(Icons.search_outlined, color: AppColors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: AppColors.black),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/cart'),
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.black,
                borderRadius: BorderRadius.circular(2),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.shopping_bag_outlined,
                      color: AppColors.white, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'BAG (${cart.itemCount})',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navLink(String label, VoidCallback onTap,
      {bool highlight = false}) {
    final hovered = _hoveredItem == label;
    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredItem = label),
      onExit: (_) => setState(() => _hoveredItem = null),
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                  color: highlight
                      ? AppColors.crimson
                      : (hovered ? AppColors.black : AppColors.darkGrey),
                ),
              ),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                height: 2,
                width: hovered ? 24 : 0,
                color: AppColors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}