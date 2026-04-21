import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String selectedSize = "32";

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool isWeb = width > 950;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          (widget.product['name'] ?? "PRODUCT DETAILS").toString().toUpperCase(),
          style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: isWeb ? width * 0.1 : 20, vertical: 30),
        child: isWeb
            ? Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 1, child: _buildImageGallery()),
            const SizedBox(width: 50),
            Expanded(flex: 1, child: _buildDetails()),
          ],
        )
            : Column(
          children: [
            _buildImageGallery(),
            const SizedBox(height: 30),
            _buildDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGallery() {
    final String imagePath = widget.product['image'] ?? widget.product['img'] ?? "";

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: imagePath.isNotEmpty
            ? Image.asset(imagePath, fit: BoxFit.cover)
            : const SizedBox(height: 300, child: Center(child: Icon(Icons.image_not_supported))),
      ),
    );
  }

  Widget _buildDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("DENIM DIVERSE PREMIUM", style: TextStyle(color: Colors.grey, fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Text(widget.product['name'] ?? "Denim Article", style: GoogleFonts.montserrat(fontSize: 28, fontWeight: FontWeight.w900, height: 1.1)),
        const SizedBox(height: 15),
        Row(
          children: [
            Text("Rs. ${(widget.product['price'] ?? 0).toStringAsFixed(0)}", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.black)),
            const SizedBox(width: 15),
            const Text("VAT INCLUDED", style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
          ],
        ),
        const Divider(height: 40, color: Color(0xFFEEEEEE)),
        const Text("SELECT WAIST SIZE", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
        const SizedBox(height: 15),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: ["28", "30", "32", "34", "36"].map((s) => _sizeButton(s)).toList(),
        ),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
            onPressed: () {
              final cart = Provider.of<CartProvider>(context, listen: false);
              final String pId = widget.product['id']?.toString() ?? widget.product['name'].toString();
              final double pPrice = (widget.product['price'] is num) ? (widget.product['price'] as num).toDouble() : 0.0;
              final String pName = widget.product['name'] ?? "Denim Item";

              // FIX: Correctly extract the image path for CartItem
              final String pImg = widget.product['image'] ?? widget.product['img'] ?? "";

              cart.addItem(pId, pPrice, pName, pImg, selectedSize);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("$pName ADDED TO BAG"),
                  backgroundColor: Colors.black,
                  action: SnackBarAction(label: "VIEW BAG", textColor: Colors.orange, onPressed: () => Navigator.pushNamed(context, '/cart')),
                ),
              );
            },
            child: const Text("ADD TO BAG", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2)),
          ),
        ),
      ],
    );
  }

  Widget _sizeButton(String size) {
    bool isSelected = selectedSize == size;
    return InkWell(
      onTap: () => setState(() => selectedSize = size),
      child: Container(
        width: 60, height: 45,
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          border: Border.all(color: isSelected ? Colors.black : Colors.grey.shade300),
        ),
        child: Center(
          child: Text(size, style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontSize: 13, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
        ),
      ),
    );
  }
}