import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../order_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _promoController = TextEditingController();

  // --- PAKISTANI PHONE VALIDATION ---
  // Accepts: 03001234567, 923001234567, or +923001234567
  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) return "Phone number is required";
    final bool phoneValid = RegExp(r"^((\+92)|(92)|(0))3\d{9}$").hasMatch(value);
    return phoneValid ? null : "Enter valid Pakistani number (e.g. 03001234567)";
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return "Email is required";
    final bool emailValid = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
    return emailValid ? null : "Enter a valid email address";
  }

  String? _validatePostal(String? value) {
    if (value == null || value.isEmpty) return "Required";
    return value.length == 5 ? null : "Must be 5 digits";
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    double width = MediaQuery.of(context).size.width;
    bool isWeb = width > 950;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("CHECKOUT", style: GoogleFonts.montserrat(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 3)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: isWeb ? width * 0.08 : 20, vertical: 40),
          child: isWeb
              ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: _buildShippingBox()),
              const SizedBox(width: 40),
              Expanded(flex: 1, child: _buildOrderSummary(cart)),
            ],
          )
              : Column(
            children: [
              _buildShippingBox(),
              const SizedBox(height: 30),
              _buildOrderSummary(cart),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShippingBox() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("SHIPPING INFORMATION", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 1.5)),
          const Divider(height: 40, color: Colors.black12),
          _buildTextField("FULL NAME", Icons.person_outline, validator: (v) => v!.isEmpty ? "Required" : null),
          _buildTextField("PHONE NUMBER", Icons.phone_android_outlined, hint: "e.g. 03001234567", isPhone: true, validator: _validatePhone),
          _buildTextField("EMAIL ADDRESS", Icons.email_outlined, validator: _validateEmail),
          _buildTextField("COMPLETE ADDRESS", Icons.home_outlined, maxLines: 2, validator: (v) => v!.isEmpty ? "Required" : null),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildTextField("CITY", Icons.location_city, validator: (v) => v!.isEmpty ? "Required" : null)),
              const SizedBox(width: 20),
              Expanded(child: _buildTextField("POSTAL CODE", Icons.mark_as_unread_outlined, validator: _validatePostal)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(CartProvider cart) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("ORDER SUMMARY", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 1.5)),
          const Divider(height: 40, color: Colors.black12),
          _summaryRow("SUBTOTAL", "Rs. ${cart.totalAmount}"),
          _summaryRow("SHIPPING FEE", "FREE"),
          const Divider(height: 40, color: Colors.black12),
          _summaryRow("TOTAL PAYABLE", "Rs. ${cart.totalAmountAfterDiscount}", isTotal: true),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black, shape: const RoundedRectangleBorder()),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  cart.clearCart();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OrderSuccessScreen()));
                }
              },
              child: const Text("PLACE ORDER", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 2)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, {int maxLines = 1, bool isPhone = false, String? hint, String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        maxLines: maxLines,
        validator: validator,
        keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, size: 18, color: Colors.black87),
          labelText: label,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black12, fontSize: 10),
          labelStyle: const TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold),
          enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black12)),
          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 1.5)),
          errorStyle: const TextStyle(fontSize: 9),
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 10, fontWeight: isTotal ? FontWeight.w900 : FontWeight.bold, color: isTotal ? Colors.black : Colors.grey.shade600)),
          Text(value, style: TextStyle(fontSize: isTotal ? 18 : 12, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}