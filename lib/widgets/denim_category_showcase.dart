// lib/screens/home/components/denim_category_showcase.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DenimCategoryShowcase extends StatelessWidget {
  const DenimCategoryShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool isWeb = width > 950;

    // Dummy data specific to Denim products (inspired by your image structure)
    final List<Map<String, String>> categoriesData = [
      {
        'tagline': 'MODERN INDIGO ELITE',
        'title': 'Men',
        'subtitle': 'Sophisticated Denim Polos',
        'image': 'assets/images/denim_category_men.jpg', // Ensure this asset exists
      },
      {
        'tagline': 'DAILY DENIM EASE',
        'title': 'Women',
        'subtitle': 'Effortless Denim Shirts & Tops',
        'image': 'assets/images/denim_category_women.jpg', // Ensure this asset exists
      },
      {
        'tagline': 'DENIM FREEDOM RUN',
        'title': 'Kids',
        'subtitle': 'Playful Denim T-Shirts',
        'image': 'assets/images/denim_category_kids.jpg', // Ensure this asset exists
      },
    ];

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: isWeb ? width * 0.1 : 20, vertical: 80),
      child: Column(
        children: [
          // Section Headers
          Text(
            "FIND THE PERFECT BLUE YOU NEED IN ONE PLACE",
            style: GoogleFonts.montserrat(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
              letterSpacing: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          Text(
            "SHOP THE FINEST DENIM CATEGORIES",
            style: GoogleFonts.montserrat(
              fontSize: isWeb ? 32 : 24,
              fontWeight: FontWeight.w900,
              color: Colors.black,
              letterSpacing: -1,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 60),

          // Category Cards Grid/Row
          isWeb
              ? Row(
            children: categoriesData.map((data) => Expanded(child: _buildCategoryCard(data, isWeb))).toList(),
          )
              : Column(
            children: categoriesData.map((data) => _buildCategoryCard(data, isWeb)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, String> data, bool isWeb) {
    double cardWidth = isWeb ? double.infinity : double.infinity;
    double cardHeight = isWeb ? 550 : 380; // Heights optimized for layout

    return Container(
      width: cardWidth,
      height: cardHeight,
      margin: EdgeInsets.all(isWeb ? 15 : 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        // Important: Image will be placed on top of this background
      ),
      child: Stack(
        fit: StackFit.expand, // Ensures the background image fills the card
        children: [
          // Background Image
          Image.asset(
            data['image']!,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: const Color(0xFF1A263F), // Fallback to denim color
              child: const Center(child: Icon(Icons.dry_cleaning_outlined, color: Colors.white24, size: 40)),
            ),
          ),

          // Slight Dark Gradient for Text Contrast (as seen in your design image)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black12,
                    Colors.black.withOpacity(0.5),
                  ],
                ),
              ),
            ),
          ),

          // Category Texts
          Positioned(
            left: 25,
            bottom: 30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['tagline']!.toUpperCase(),
                  style: GoogleFonts.montserrat(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  data['title']!,
                  style: GoogleFonts.montserrat(
                    fontSize: isWeb ? 36 : 28,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  data['subtitle']!,
                  style: GoogleFonts.montserrat(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}