import 'package:denim_diverse/product.dart';
import 'package:flutter/material.dart';


class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Left aligned jaisa guide mein hai
      children: [
        // Product Image Container
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFF5F5F5),
            ),
            child: Image.asset(
              product.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
              const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Product Title (BOLD & SHARP)
        Text(
          product.name.toUpperCase(),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900, // Extra bold for the 'Fit' name
            letterSpacing: 1.2,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        // Product Description or Price (Subtle)
        Text(
          "PREMIUM STRETCH DENIM - Rs. ${product.price.toInt()}",
          maxLines: 2,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
            height: 1.4,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}