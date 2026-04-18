import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  String selectedCategory = "ALL JEANS";

  // Aapka data yahan se manage hoga
  final List<Map<String, dynamic>> fitsData = [
    {'id': '1', 'name': 'BOOT CUT', 'image': 'assets/images/bootcut.jpg', 'price': 4500.0, 'category': 'MEN'},
    {'id': '2', 'name': 'MOM FIT', 'image': 'assets/images/momfit.jpg', 'price': 4200.0, 'category': 'WOMEN'},
    {'id': '3', 'name': 'BOYFRIEND', 'image': 'assets/images/boyfriend.jpg', 'price': 4800.0, 'category': 'WOMEN'},
    {'id': '4', 'name': 'BAGGY', 'image': 'assets/images/baggy.jpg', 'price': 5100.0, 'category': 'MEN'},
    {'id': '5', 'name': 'STRAIGHT', 'image': 'assets/images/straight_wear.jpg', 'price': 3900.0, 'category': 'MEN'},
    {'id': '6', 'name': 'SKINNY', 'image': 'assets/images/skinny.jpg', 'price': 3500.0, 'category': 'WOMEN'},
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool isWeb = width > 950;

    final filteredProducts = fitsData.where((p) {
      return selectedCategory == "ALL JEANS" || p['category'] == selectedCategory;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("COLLECTION", style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black, letterSpacing: 2)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Sidebar (Web Only)
          if (isWeb)
            Container(
              width: 250,
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.grey.shade100))),
              child: _buildFilterSidebar(),
            ),

          // Main Product Grid
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildResultHeader(filteredProducts.length),
                  const SizedBox(height: 30),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredProducts.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isWeb ? 3 : 2,
                      childAspectRatio: 0.65,
                      mainAxisSpacing: 30,
                      crossAxisSpacing: 20,
                    ),
                    itemBuilder: (ctx, i) => _buildProductCard(filteredProducts[i]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSidebar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("FILTER BY", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 2)),
        const Divider(height: 40),
        _filterItem("ALL JEANS"),
        _filterItem("MEN"),
        _filterItem("WOMEN"),
      ],
    );
  }

  Widget _filterItem(String title) {
    bool isActive = selectedCategory == title;
    return InkWell(
      onTap: () => setState(() => selectedCategory = title),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(title, style: TextStyle(
            fontSize: 11,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? Colors.black : Colors.grey,
            letterSpacing: 1
        )),
      ),
    );
  }

  Widget _buildResultHeader(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("$count ITEMS FOUND", style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
        const Row(
          children: [
            Text("SORT BY: NEWEST", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
            Icon(Icons.keyboard_arrow_down, size: 14),
          ],
        )
      ],
    );
  }

  Widget _buildProductCard(Map<String, dynamic> data) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/product-detail', arguments: data),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              color: const Color(0xFFF9F9F9),
              child: Image.asset(data['image']!, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 12),
          Text(data['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1)),
          Text("Rs. ${data['price']}", style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }
}