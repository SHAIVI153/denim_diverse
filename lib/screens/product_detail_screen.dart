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
  String selectedSize = "32"; // Default size

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
        title: Text(widget.product['name'].toString().toUpperCase(),
            style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: isWeb ? width * 0.1 : 20, vertical: 30),
        child: isWeb
            ? Row( // Web Layout
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 1, child: _buildImage()),
            const SizedBox(width: 50),
            Expanded(flex: 1, child: _buildDetails()),
          ],
        )
            : Column( // Mobile Layout
          children: [
            _buildImage(),
            const SizedBox(height: 30),
            _buildDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      height: 500,
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Image.asset(widget.product['image'], fit: BoxFit.cover),
    );
  }

  Widget _buildDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("DENIM DYNASTY", style: TextStyle(color: Colors.grey, fontSize: 10, letterSpacing: 2)),
        const SizedBox(height: 10),
        Text(widget.product['name'], style: GoogleFonts.montserrat(fontSize: 26, fontWeight: FontWeight.w900)),
        const SizedBox(height: 10),
        Text("Rs. ${widget.product['price']}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const Divider(height: 40),

        const Text("SELECT SIZE", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        Row(
          children: ["28", "30", "32", "34", "36"].map((s) => _sizeButton(s)).toList(),
        ),

        const SizedBox(height: 40),
        const Text("DESCRIPTION", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        const Text(
          "Premium denim fabric with reinforced stitching. Designed for durability and a modern aesthetic.",
          style: TextStyle(color: Colors.grey, height: 1.5),
        ),

        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            ),
            onPressed: () {
              // FIXED: Passing size to CartProvider
              Provider.of<CartProvider>(context, listen: false).addItem(
                widget.product['id'].toString(),
                (widget.product['price'] as num).toDouble(),
                widget.product['name'],
                widget.product['image'],
                selectedSize, // Size pass ho raha hai
              );

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("ADDED TO BAG"), backgroundColor: Colors.black),
              );
            },
            child: const Text("ADD TO BAG", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          border: Border.all(color: isSelected ? Colors.black : Colors.grey.shade300),
        ),
        child: Text(size, style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        )),
      ),
    );
  }
}