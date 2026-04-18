import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CrazyDealsScreen extends StatelessWidget {
  const CrazyDealsScreen({super.key});

  // Yahan aap randomly jitni chahe dummy images aur deals add kar sakte hain
  final List<Map<String, dynamic>> crazyDealsData = const [
    {
      'id': 'cd1',
      'name': 'ULTRA SHREDDED DENIM',
      'image': 'https://picsum.photos/seed/denim1/400/600', // Dummy AI Image
      'price': 1500.0,
      'originalPrice': 4000.0,
      'discount': '62% OFF'
    },
    {
      'id': 'cd2',
      'name': 'VINTAGE TRUCKER JACKET',
      'image': 'https://picsum.photos/seed/denim2/400/600', // Dummy AI Image
      'price': 2200.0,
      'originalPrice': 5500.0,
      'discount': '60% OFF'
    },
    {
      'id': 'cd3',
      'name': 'STREETWEAR CARGO JEANS',
      'image': 'https://picsum.photos/seed/denim3/400/600', // Dummy AI Image
      'price': 1800.0,
      'originalPrice': 3800.0,
      'discount': '50% OFF'
    },
    {
      'id': 'cd4',
      'name': 'PATCHWORK SLIM FIT',
      'image': 'https://picsum.photos/seed/denim4/400/600', // Dummy AI Image
      'price': 1999.0,
      'originalPrice': 4500.0,
      'discount': '55% OFF'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A192F), // Dark Theme
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "CRAZY DEALS",
          style: GoogleFonts.montserrat(
            color: Colors.red,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Timer Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              color: Colors.red,
              child: const Center(
                child: Text(
                  "HURRY! FLASH SALE ENDS IN 02:45:10",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(15.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: crazyDealsData.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.6,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                ),
                itemBuilder: (context, index) {
                  final deal = crazyDealsData[index];
                  return _buildDealCard(deal);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDealCard(Map<String, dynamic> deal) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                  child: Image.network(
                    deal['image'],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator(color: Colors.red));
                    },
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    color: Colors.red,
                    child: Text(
                      deal['discount'],
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deal['name'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      "Rs. ${deal['price']}",
                      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w900, fontSize: 14),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Rs. ${deal['originalPrice']}",
                      style: const TextStyle(
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}