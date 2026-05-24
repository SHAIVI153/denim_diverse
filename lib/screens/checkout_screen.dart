import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../widgets/common_widgets.dart';
import 'app_theme.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  String _paymentMethod = 'ONLINE';
  String _onlineProvider = 'CARD';
  bool _isPlacing = false;

  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _postalCtrl = TextEditingController();

  @override
  void dispose() {
    for (final c in [_firstNameCtrl, _lastNameCtrl, _emailCtrl, _phoneCtrl,
      _addressCtrl, _cityCtrl, _postalCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isPlacing = true);
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final cart = context.read<CartProvider>();
    final orders = context.read<OrderProvider>();

    orders.placeOrder(
      cartProducts: cart.items.values.toList(),
      total: cart.totalAmount,
      name: '${_firstNameCtrl.text} ${_lastNameCtrl.text}',
      email: _emailCtrl.text,
      address: _addressCtrl.text,
      city: _cityCtrl.text,
      phone: _phoneCtrl.text,
      paymentMethod: _paymentMethod,
    );
    cart.clearCart();

    setState(() => _isPlacing = false);
    _showSuccess();
  }

  void _showSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(36),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded,
                    size: 40, color: AppColors.success),
              ),
              const SizedBox(height: 24),
              const Text(
                'ORDER PLACED!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Thank you for your purchase.\nYour order is confirmed and will be delivered soon.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.medGrey,
                  fontSize: 13,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 28),
              PrimaryButton(
                label: 'CONTINUE SHOPPING',
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/', (r) => false);
                },
              ),
              const SizedBox(height: 12),
              GhostButton(
                label: 'VIEW ORDERS',
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/orders', (r) => false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final w = MediaQuery.of(context).size.width;
    final isWeb = w > 900;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(title: const Text('CHECKOUT')),
      body: isWeb
          ? Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 6,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(48),
              child: _form(),
            ),
          ),
          Container(width: 1, color: AppColors.border),
          SizedBox(
            width: 380,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(36),
              child: _orderReview(cart),
            ),
          ),
        ],
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _orderReview(cart),
            const SizedBox(height: 32),
            _form(),
          ],
        ),
      ),
    );
  }

  Widget _form() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section: Contact
          _sectionLabel('CONTACT INFORMATION'),
          const SizedBox(height: 16),
          _field(controller: _emailCtrl, label: 'Email Address',
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Email required';
                if (!v.contains('@')) return 'Invalid email';
                return null;
              }),
          const SizedBox(height: 12),
          _field(controller: _phoneCtrl, label: 'Phone Number',
              keyboardType: TextInputType.phone,
              validator: (v) =>
              (v == null || v.length < 10) ? 'Valid phone required' : null),

          const SizedBox(height: 32),
          _sectionLabel('SHIPPING ADDRESS'),
          const SizedBox(height: 16),

          Row(children: [
            Expanded(child: _field(
                controller: _firstNameCtrl, label: 'First Name',
                validator: (v) =>
                (v == null || v.isEmpty) ? 'Required' : null)),
            const SizedBox(width: 12),
            Expanded(child: _field(
                controller: _lastNameCtrl, label: 'Last Name',
                validator: (v) =>
                (v == null || v.isEmpty) ? 'Required' : null)),
          ]),
          const SizedBox(height: 12),
          _field(controller: _addressCtrl, label: 'Street Address',
              maxLines: 2,
              validator: (v) =>
              (v == null || v.isEmpty) ? 'Address required' : null),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: _field(
                controller: _cityCtrl, label: 'City',
                validator: (v) =>
                (v == null || v.isEmpty) ? 'Required' : null)),
            const SizedBox(width: 12),
            Expanded(child: _field(
                controller: _postalCtrl, label: 'Postal Code',
                keyboardType: TextInputType.number,
                validator: (v) =>
                (v == null || v.isEmpty) ? 'Required' : null)),
          ]),

          const SizedBox(height: 32),
          _sectionLabel('PAYMENT METHOD'),
          const SizedBox(height: 16),

          // Payment Toggle
          Row(children: [
            Expanded(child: _paymentOption('ONLINE', 'Online Payment',
                Icons.credit_card_outlined)),
            const SizedBox(width: 12),
            Expanded(child: _paymentOption('COD', 'Cash on Delivery',
                Icons.money_outlined)),
          ]),

          if (_paymentMethod == 'ONLINE') ...[
            const SizedBox(height: 16),
            Row(children: [
              _onlineOption('CARD', 'Card'),
              const SizedBox(width: 10),
              _onlineOption('EASYPAISA', 'Easypaisa'),
              const SizedBox(width: 10),
              _onlineOption('JAZZCASH', 'JazzCash'),
            ]),
          ],

          const SizedBox(height: 36),
          PrimaryButton(
            label: 'PLACE ORDER',
            isLoading: _isPlacing,
            onPressed: _placeOrder,
          ),
          const SizedBox(height: 20),

          // Trust
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 14, color: AppColors.medGrey),
              const SizedBox(width: 6),
              const Text(
                'Secured by 256-bit SSL encryption',
                style: TextStyle(color: AppColors.medGrey, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 6),
        Container(height: 2, width: 30, color: AppColors.black),
      ],
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(labelText: label),
    );
  }

  Widget _paymentOption(String value, String label, IconData icon) {
    final selected = _paymentMethod == value;
    return GestureDetector(
      onTap: () => setState(() => _paymentMethod = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: selected ? AppColors.black : AppColors.border,
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(4),
          color: selected ? AppColors.black.withOpacity(0.04) : AppColors.white,
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: selected ? AppColors.black : AppColors.medGrey),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: selected ? AppColors.black : AppColors.medGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _onlineOption(String value, String label) {
    final selected = _onlineProvider == value;
    return GestureDetector(
      onTap: () => setState(() => _onlineProvider = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.black : AppColors.surface,
          borderRadius: BorderRadius.circular(2),
          border: Border.all(
              color: selected ? AppColors.black : AppColors.border),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? AppColors.white : AppColors.darkGrey,
            fontWeight: FontWeight.w700,
            fontSize: 11,
          ),
        ),
      ),
    );
  }

  Widget _orderReview(CartProvider cart) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ORDER REVIEW',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 20),
          ...cart.items.values.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    width: 56,
                    height: 66,
                    color: AppColors.border,
                    child: Image.asset(item.image, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const SizedBox()),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name,
                          maxLines: 2,
                          style: const TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 11)),
                      const SizedBox(height: 4),
                      Text('Size ${item.size} · Qty ${item.quantity}',
                          style: const TextStyle(
                              color: AppColors.medGrey, fontSize: 10)),
                    ],
                  ),
                ),
                Text(
                  'Rs. ${(item.price * item.quantity).toStringAsFixed(0)}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w900, fontSize: 13),
                ),
              ],
            ),
          )),
          const Divider(),
          const SizedBox(height: 14),
          _summRow('Subtotal', 'Rs. ${cart.totalAmount.toStringAsFixed(0)}'),
          const SizedBox(height: 8),
          _summRow('Savings',
              '- Rs. ${cart.totalSavings.toStringAsFixed(0)}',
              valueColor: AppColors.success),
          const SizedBox(height: 8),
          _summRow('Delivery', cart.totalAmount > 5000 ? 'FREE' : 'Rs. 200',
              valueColor: cart.totalAmount > 5000 ? AppColors.success : null),
          const SizedBox(height: 14),
          const Divider(),
          const SizedBox(height: 14),
          Row(children: [
            const Text('TOTAL',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
            const Spacer(),
            Text(
              'Rs. ${(cart.totalAmount + (cart.totalAmount > 5000 ? 0 : 200)).toStringAsFixed(0)}',
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _summRow(String label, String value, {Color? valueColor}) => Row(
    children: [
      Text(label,
          style: const TextStyle(color: AppColors.darkGrey, fontSize: 12)),
      const Spacer(),
      Text(value,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 12,
            color: valueColor ?? AppColors.black,
          )),
    ],
  );
}