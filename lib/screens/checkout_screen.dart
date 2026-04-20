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

  // Main Selection
  String _selectedPaymentMethod = "ONLINE";
  // Sub Selection for Online
  String _selectedOnlineProvider = "CARD";

  // Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController(text: "92");
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

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    double width = MediaQuery.of(context).size.width;
    bool isWeb = width > 950;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
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
              hint: "example@domain.com",
              validator: (v) {
                if (v == null || v.isEmpty) return "Email zaroori hai";
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) return "Sahi email dalein";
                return null;
              }
          ),

          const SizedBox(height: 30),
          _headerText("Delivery"),
          Row(
            children: [
              Expanded(child: _buildTextField("First name", _fNameController, validator: (v) => v!.isEmpty ? "Zaroori hai" : null)),
              const SizedBox(width: 12),
              Expanded(child: _buildTextField("Last name", _lNameController, validator: (v) => v!.isEmpty ? "Zaroori hai" : null)),
            ],
          ),
          _buildTextField("Address", _addressController, validator: (v) => v!.isEmpty ? "Address likhein" : null),
          Row(
            children: [
              Expanded(child: _buildTextField("City", _cityController, validator: (v) => v!.isEmpty ? "City likhein" : null)),
              const SizedBox(width: 12),
              Expanded(child: _buildTextField("Postal code", _postalController, validator: (v) => v!.isEmpty ? "Postal code likhein" : null)),
            ],
          ),
          _buildTextField("Phone", _phoneController,
              hint: "923001234567",
              isNumber: true,
              validator: (v) {
                if (v == null || v.isEmpty) return "Phone zaroori hai";
                if (!RegExp(r"^92[0-9]{10}$").hasMatch(v)) return "92 ke sath 12 digits likhein";
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

  // --- IMPROVED PAYMENT BOX WITH SUB-OPTIONS ---
  Widget _buildPaymentBox() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          // MAIN ONLINE OPTION
          _mainPaymentTile("ONLINE", "Online Payment", logos: ["visa.png", "mastercard.png", "jazzcash.png", "easypaisa.png"]),

          // SUB-OPTIONS (Only show if ONLINE is selected)
          if (_selectedPaymentMethod == "ONLINE")
            Container(
              color: const Color(0xFFFAFAFA),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                children: [
                  _subPaymentTile("CARD", "Debit / Credit Card", "visa.png"),
                  _subPaymentTile("JAZZCASH", "JazzCash", "jazzcash.png"),
                  _subPaymentTile("EASYPAISA", "EasyPaisa", "easypaisa.png"),
                ],
              ),
            ),

          const Divider(height: 0),

          // COD OPTION
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
              children: logos.take(3).map((img) => Image.asset("assets/logos/$img", height: 15, errorBuilder: (c,e,s)=>const SizedBox())).toList(),
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
      controlAffinity: ListTileControlAffinity.trailing, // Radio right side par
      title: Row(
        children: [
          Image.asset("assets/logos/$logo", height: 20, errorBuilder: (c,e,s)=>const Icon(Icons.payment, size: 18)),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(fontSize: 12)),
        ],
      ),
      onChanged: (v) => setState(() => _selectedOnlineProvider = v.toString()),
    );
  }

  // --- RIGHT SECTION ---
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
                Text("Rs. ${(item.price * item.quantity).toStringAsFixed(0)}"),
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

  Widget _buildTextField(String label, TextEditingController? controller, {String? hint, bool isNumber = false, String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
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
        style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            final cart = Provider.of<CartProvider>(context, listen: false);
            String finalMethod = _selectedPaymentMethod == "ONLINE" ? _selectedOnlineProvider : "COD";

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Order Placed via $finalMethod")));
            cart.clearCart();
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          }
        },
        child: const Text("Pay now", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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