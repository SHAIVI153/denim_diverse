import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  // --- CONTROLLERS ---
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _postalController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _postalController.dispose();
    super.dispose();
  }

  // --- VALIDATIONS ---
  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) return "Phone number is required";
    final bool phoneValid = RegExp(r"^((\+92)|(92)|(0))3\d{9}$").hasMatch(value);
    return phoneValid ? null : "Enter valid Pakistani number";
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return "Email is required";
    final bool emailValid = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
    return emailValid ? null : "Enter a valid email address";
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    double width = MediaQuery.of(context).size.width;
    bool isWeb = width > 950;

    return Scaffold(
      backgroundColor: Colors.white,
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
          _buildTextField("FULL NAME", Icons.person_outline, controller: _nameController, validator: (v) => v!.isEmpty ? "Required" : null),
          _buildTextField("PHONE NUMBER", Icons.phone_android_outlined, controller: _phoneController, hint: "e.g. 03001234567", isPhone: true, validator: _validatePhone),
          _buildTextField("EMAIL ADDRESS", Icons.email_outlined, controller: _emailController, validator: _validateEmail),
          _buildTextField("COMPLETE ADDRESS", Icons.home_outlined, controller: _addressController, maxLines: 2, validator: (v) => v!.isEmpty ? "Required" : null),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildTextField("CITY", Icons.location_city, controller: _cityController, validator: (v) => v!.isEmpty ? "Required" : null)),
              const SizedBox(width: 20),
              Expanded(child: _buildTextField("POSTAL CODE", Icons.mark_as_unread_outlined, controller: _postalController, validator: (v) => v!.isEmpty ? "Required" : null)),
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
          _summaryRow("SUBTOTAL", "Rs. ${cart.totalAmount.toStringAsFixed(0)}"),
          _summaryRow("SHIPPING FEE", "FREE"),
          const Divider(height: 40, color: Colors.black12),
          // REMOVED discount logic here:
          _summaryRow("TOTAL PAYABLE", "Rs. ${cart.totalAmount.toStringAsFixed(0)}", isTotal: true),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: const RoundedRectangleBorder(),
                  elevation: 0
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // REMOVED totalAmountAfterDiscount here:
                  Provider.of<OrderProvider>(context, listen: false).addOrder(
                    cart.items.values.toList(),
                    cart.totalAmount,
                    _nameController.text,
                    _emailController.text,
                    _addressController.text,
                    _phoneController.text,
                  );

                  cart.clearCart();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("ORDER PLACED SUCCESSFULLY!"), backgroundColor: Colors.black),
                  );

                  Navigator.pushNamedAndRemoveUntil(context, '/order-history', (route) => route.isFirst);
                }
              },
              child: const Text("PLACE ORDER", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 2)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, {required TextEditingController controller, int maxLines = 1, bool isPhone = false, String? hint, String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
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