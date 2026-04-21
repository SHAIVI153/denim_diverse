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

  // Selection States
  String _selectedPaymentMethod = "ONLINE";
  String _selectedOnlineProvider = "CARD";

  // Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _postalController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _fNameController.dispose();
    _lNameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _phoneController.dispose();
    _postalController.dispose();
    super.dispose();
  }

  // --- THANK YOU DIALOG ---
  void _showThankYouDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          child: Container(
            padding: const EdgeInsets.all(30),
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle_outline, size: 80, color: Colors.green),
                const SizedBox(height: 20),
                Text(
                  "THANK YOU!",
                  style: GoogleFonts.montserrat(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Your order has been placed successfully.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                const SizedBox(height: 10),
                Text(
                  "Order ID: #DD${1000 + (DateTime.now().millisecond)}",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                const SizedBox(height: 30),
                const Divider(),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                    ),
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                    },
                    child: const Text(
                      "CONTINUE SHOPPING",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    double width = MediaQuery.of(context).size.width;
    bool isWeb = width > 950;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: isWeb ? null : AppBar(
        title: const Text("CHECKOUT", style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: isWeb
              ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: _buildLeftSection()),
              Container(width: 1, height: MediaQuery.of(context).size.height, color: Colors.grey[300]),
              Expanded(flex: 2, child: _buildRightSection(cart)),
            ],
          )
              : Column(
            children: [
              _buildRightSection(cart),
              _buildLeftSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeftSection() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.07, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("DENIM DIVERSE", style: GoogleFonts.montserrat(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -1)),
          const SizedBox(height: 30),

          _headerText("Contact"),
          _buildTextField("Email", _emailController,
              hint: "example@gmail.com",
              validator: (v) {
                if (v == null || v.isEmpty) return "Email is required";
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) return "Invalid email format";
                return null;
              }
          ),

          const SizedBox(height: 30),
          _headerText("Delivery"),
          Row(
            children: [
              Expanded(child: _buildTextField("First name", _fNameController, validator: (v) => v!.isEmpty ? "Required" : null)),
              const SizedBox(width: 12),
              Expanded(child: _buildTextField("Last name", _lNameController, validator: (v) => v!.isEmpty ? "Required" : null)),
            ],
          ),
          _buildTextField("Address", _addressController, validator: (v) => v!.isEmpty ? "Address is required" : null),
          Row(
            children: [
              Expanded(child: _buildTextField("City", _cityController, validator: (v) => v!.isEmpty ? "City is required" : null)),
              const SizedBox(width: 12),
              Expanded(child: _buildTextField("Postal code", _postalController,
                  validator: (v) => (v == null || v.isEmpty) ? "Postal code required" : null)),
            ],
          ),
          _buildTextField("Phone", _phoneController,
              hint: "03XXXXXXXXX",
              isNumber: true,
              validator: (v) {
                if (v == null || v.isEmpty) return "Phone number is required";
                if (!RegExp(r'^03[0-9]{9}$').hasMatch(v)) return "Enter valid 11-digit number (03XXXXXXXXX)";
                return null;
              }
          ),

          const SizedBox(height: 30),
          _headerText("Payment Method"),
          _buildPaymentBox(),

          const SizedBox(height: 40),
          _buildPayNowButton(),
        ],
      ),
    );
  }

  Widget _buildPaymentBox() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          _mainPaymentTile("ONLINE", "Online Payment", logos: ["visa.png", "mastercard.png", "jazzcash.png", "easypaisa.png"]),

          if (_selectedPaymentMethod == "ONLINE")
            Container(
              color: const Color(0xFFFAFAFA),
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  _subPaymentTile("CARD", "Debit / Credit Card", "visa.png"),
                  const Divider(indent: 50, endIndent: 20),
                  _subPaymentTile("JAZZCASH", "JazzCash", "jazzcash.png"),
                  const Divider(indent: 50, endIndent: 20),
                  _subPaymentTile("EASYPAISA", "EasyPaisa", "easypaisa.png"),
                  const Divider(indent: 50, endIndent: 20),
                  _subPaymentTile("NAYAPAY", "NayaPay", "nayapay.png"),
                ],
              ),
            ),

          const Divider(height: 0),
          _mainPaymentTile("COD", "Cash on Delivery (COD)"),
        ],
      ),
    );
  }

  Widget _mainPaymentTile(String value, String title, {List<String>? logos}) {
    return RadioListTile(
      value: value,
      groupValue: _selectedPaymentMethod,
      activeColor: Colors.black,
      title: Row(
        children: [
          Expanded(child: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold))),
          if (logos != null)
            Wrap(
              spacing: 4,
              children: logos.map((img) => Image.asset("assets/logos/$img", height: 14, errorBuilder: (c,e,s)=>const SizedBox())).toList(),
            ),
        ],
      ),
      onChanged: (v) => setState(() => _selectedPaymentMethod = v.toString()),
    );
  }

  Widget _subPaymentTile(String value, String title, String logo) {
    return RadioListTile(
      value: value,
      groupValue: _selectedOnlineProvider,
      activeColor: Colors.blue,
      controlAffinity: ListTileControlAffinity.trailing,
      title: Row(
        children: [
          Image.asset("assets/logos/$logo", height: 20, errorBuilder: (c,e,s)=>const Icon(Icons.payment, size: 18)),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
      onChanged: (v) => setState(() => _selectedOnlineProvider = v.toString()),
    );
  }

  Widget _buildRightSection(CartProvider cart) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          ...cart.items.values.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Row(
              children: [
                _productImage(item.image, item.quantity),
                const SizedBox(width: 15),
                Expanded(child: Text(item.name.toUpperCase(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                Text("Rs. ${(item.price * item.quantity).toStringAsFixed(0)}", style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          )).toList(),
          const Divider(height: 40),
          _summaryRow("Subtotal", "Rs. ${cart.totalAmount.toStringAsFixed(0)}"),
          _summaryRow("Shipping", "FREE", isGreen: true),
          const Divider(height: 40),
          _summaryRow("Total", "Rs. ${cart.totalAmount.toStringAsFixed(0)}", isTotal: true),
        ],
      ),
    );
  }

  Widget _productImage(String path, int qty) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(width: 60, height: 60, decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)), child: ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.asset(path, fit: BoxFit.cover))),
        Positioned(right: -5, top: -5, child: CircleAvatar(radius: 10, backgroundColor: Colors.black, child: Text("$qty", style: const TextStyle(color: Colors.white, fontSize: 10)))),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {String? hint, bool isNumber = false, String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.shade300)),
        ),
      ),
    );
  }

  Widget _buildPayNowButton() {
    return SizedBox(
      width: double.infinity, height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.black, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            final cart = Provider.of<CartProvider>(context, listen: false);

            Provider.of<OrderProvider>(context, listen: false).addOrder(
              cart.items.values.toList(),
              cart.totalAmount,
              "${_fNameController.text} ${_lNameController.text}",
              _emailController.text,
              _addressController.text,
              _phoneController.text,
            );

            cart.clearCart();
            _showThankYouDialog();
          }
        },
        child: const Text("PAY NOW", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1)),
      ),
    );
  }

  Widget _headerText(String t) => Padding(padding: const EdgeInsets.only(bottom: 15), child: Text(t, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)));

  Widget _summaryRow(String l, String v, {bool isGreen = false, bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(l, style: TextStyle(fontSize: isTotal ? 16 : 13, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          Text(v, style: TextStyle(fontSize: isTotal ? 16 : 13, color: isGreen ? Colors.green : Colors.black, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}