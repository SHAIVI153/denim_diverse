import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CollectionScreen extends StatefulWidget {
  final String? initialCategory;

  const CollectionScreen({super.key, this.initialCategory});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  late String selectedCategory;

  // Updated Data: Added BUNDLE and CLEARANCE items
  final List<Map<String, dynamic>> fitsData = [
    {'id': '1', 'name': 'BOOT CUT JEANS', 'image': 'assets/images/bootcut.jpg', 'price': 4500.0, 'category': 'MEN', 'isNew': true},
    {'id': '2', 'name': 'MOM FIT DENIM', 'image': 'assets/images/momfit.jpg', 'price': 4200.0, 'category': 'WOMEN', 'isNew': false},
    {'id': '3', 'name': 'BOYFRIEND JEANS', 'image': 'assets/images/boyfriend.jpg', 'price': 4800.0, 'category': 'WOMEN', 'isNew': true},
    {'id': '4', 'name': 'BAGGY FIT', 'image': 'assets/images/baggy.jpg', 'price': 5100.0, 'category': 'MEN', 'isNew': false},
    {'id': '5', 'name': 'KIDS STRAIGHT FIT', 'image': 'assets/images/kids_jeans.jpg', 'price': 2900.0, 'category': 'KIDS', 'isNew': true},
    {'id': '6', 'name': 'COMBO PACK (3 JEANS)', 'image': 'assets/images/bundle_1.jpg', 'price': 8500.0, 'category': 'BUNDLE', 'isNew': true},
    {'id': '7', 'name': 'LAST CHANCE SKINNY', 'image': 'assets/images/clearance_1.jpg', 'price': 1500.0, 'category': 'CLEARANCE', 'isNew': false},
    {'id': '8', 'name': 'STRAIGHT LEG WARE', 'image': 'assets/images/straight_wear.jpg', 'price': 3900.0, 'category': 'MEN', 'isNew': false},
  ];

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.initialCategory ?? "ALL JEANS";
  }

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
        title: Text("COLLECTION",
            style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.black, letterSpacing: 2)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(icon: const Icon(Icons.search, size: 20), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined, size: 20),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isWeb)
            Container(
              width: 260,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
              decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.grey.shade100))),
              child: _buildFilterSidebar(),
            ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isWeb ? 40 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isWeb) _buildMobileFilterChips(),
                  if (!isWeb) const SizedBox(height: 20),
                  _buildResultHeader(filteredProducts.length),
                  const SizedBox(height: 30),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredProducts.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isWeb ? 3 : 2,
                      childAspectRatio: 0.62,
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
        const Text("CATEGORIES", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 1.5)),
        const SizedBox(height: 20),
        _filterItem("ALL JEANS"),
        _filterItem("MEN"),
        _filterItem("WOMEN"),
        _filterItem("KIDS"),
        _filterItem("BUNDLE"),
        _filterItem("CLEARANCE"),
      ],
    );
  }

  Widget _buildMobileFilterChips() {
    List<String> categories = ["ALL JEANS", "MEN", "WOMEN", "KIDS", "BUNDLE", "CLEARANCE"];
    return SizedBox(
      height: 35,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: categories.map((cat) {
          bool isActive = selectedCategory == cat;
          return GestureDetector(
            onTap: () => setState(() => selectedCategory = cat),
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isActive ? Colors.black : Colors.transparent,
                border: Border.all(color: isActive ? Colors.black : Colors.grey.shade300),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                cat,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isActive ? Colors.white : Colors.black),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _filterItem(String title) {
    bool isActive = selectedCategory == title;
    return InkWell(
      onTap: () => setState(() => selectedCategory = title),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(title, style: TextStyle(
          fontSize: 11,
          fontWeight: isActive ? FontWeight.w800 : FontWeight.w400,
          color: isActive ? Colors.black : Colors.grey[600],
        )),
      ),
    );
  }

  Widget _buildResultHeader(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("$count PRODUCTS FOUND", style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
        const Icon(Icons.tune, size: 16),
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
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: const Color(0xFFF6F6F6), borderRadius: BorderRadius.circular(4)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.asset(data['image']!, fit: BoxFit.cover),
                  ),
                ),
                if (data['isNew'] == true)
                  Positioned(
                    top: 10, left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      color: Colors.black,
                      child: const Text("NEW", style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(data['name']!.toString().toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 0.5)),
          const SizedBox(height: 4),
          Text("Rs. ${data['price']}", style: GoogleFonts.lato(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black54)),
        ],
      ),
    );
  }
}