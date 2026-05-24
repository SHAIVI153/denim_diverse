import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/common_widgets.dart';
import 'app_theme.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final w = MediaQuery.of(context).size.width;
    final isWeb = w > 900;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          cart.items.isEmpty
              ? 'YOUR BAG'
              : 'YOUR BAG (${cart.itemCount})',
        ),
      ),
      body: cart.items.isEmpty
          ? EmptyState(
        icon: Icons.shopping_bag_outlined,
        title: 'Your bag is empty',
        subtitle: 'Looks like you haven\'t added\nany denim yet.',
        buttonLabel: 'Start Shopping',
        onButton: () =>
            Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false),
      )
          : isWeb
          ? _webLayout(context, cart, w)
          : _mobileLayout(context, cart),
    );
  }

  Widget _webLayout(BuildContext context, CartProvider cart, double w) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 6,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ITEMS IN YOUR BAG',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                    color: AppColors.medGrey,
                  ),
                ),
                const SizedBox(height: 24),
                ...cart.items.values
                    .map((item) => _CartItemTile(
                  item: item,
                  onIncrease: () =>
                      context.read<CartProvider>().increaseQuantity(item.id),
                  onDecrease: () =>
                      context.read<CartProvider>().decreaseQuantity(item.id),
                  onRemove: () =>
                      context.read<CartProvider>().removeItem(item.id),
                ))
                    .toList(),
              ],
            ),
          ),
        ),
        Container(width: 1, color: AppColors.border),
        SizedBox(
          width: 380,
          child: _OrderSummary(cart: cart),
        ),
      ],
    );
  }

  Widget _mobileLayout(BuildContext context, CartProvider cart) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: cart.items.values
                .map((item) => _CartItemTile(
              item: item,
              onIncrease: () =>
                  context.read<CartProvider>().increaseQuantity(item.id),
              onDecrease: () =>
                  context.read<CartProvider>().decreaseQuantity(item.id),
              onRemove: () =>
                  context.read<CartProvider>().removeItem(item.id),
            ))
                .toList(),
          ),
        ),
        _OrderSummary(cart: cart, compact: true),
      ],
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final CartItem item;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onRemove;

  const _CartItemTile({
    required this.item,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Container(
              width: 90,
              height: 110,
              color: AppColors.surface,
              child: Image.asset(item.image, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                  const Icon(Icons.image_outlined, color: AppColors.lightGrey)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Size: ${item.size}',
                  style: const TextStyle(
                    color: AppColors.medGrey,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      'Rs. ${item.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                        color: AppColors.crimson,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Rs. ${item.originalPrice.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.lightGrey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    // Quantity
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _qtyIcon(Icons.remove, onDecrease),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Text(
                              '${item.quantity}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          _qtyIcon(Icons.add, onIncrease),
                        ],
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: onRemove,
                      child: const Icon(Icons.delete_outline,
                          color: AppColors.lightGrey, size: 20),
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

  Widget _qtyIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        child: Icon(icon, size: 16, color: AppColors.black),
      ),
    );
  }
}

class _OrderSummary extends StatelessWidget {
  final CartProvider cart;
  final bool compact;

  const _OrderSummary({required this.cart, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(compact ? 20 : 32),
      decoration: BoxDecoration(
        color: compact ? AppColors.surface : AppColors.white,
        border: compact
            ? const Border(top: BorderSide(color: AppColors.border))
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'ORDER SUMMARY',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 20),

          // Promo Input
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Promo Code',
                    hintStyle: TextStyle(fontSize: 12),
                    isDense: true,
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                color: AppColors.black,
                child: const Center(
                  child: Text(
                    'APPLY',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),

          _summaryRow('Subtotal', 'Rs. ${cart.totalAmount.toStringAsFixed(0)}'),
          const SizedBox(height: 10),
          _summaryRow('You Save',
              'Rs. ${cart.totalSavings.toStringAsFixed(0)}',
              valueColor: AppColors.success),
          const SizedBox(height: 10),
          _summaryRow('Shipping', cart.totalAmount > 5000 ? 'FREE' : 'Rs. 200',
              valueColor: cart.totalAmount > 5000
                  ? AppColors.success
                  : AppColors.black),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),

          Row(
            children: [
              const Text(
                'TOTAL',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
              ),
              const Spacer(),
              Text(
                'Rs. ${(cart.totalAmount + (cart.totalAmount > 5000 ? 0 : 200)).toStringAsFixed(0)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
          PrimaryButton(
            label: 'PROCEED TO CHECKOUT',
            onPressed: () => Navigator.pushNamed(context, '/checkout'),
          ),
          const SizedBox(height: 12),
          GhostButton(
            label: 'CONTINUE SHOPPING',
            onPressed: () =>
                Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false),
          ),

          const SizedBox(height: 20),
          // Trust Badges
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _trustBadge(Icons.lock_outline, 'Secure Pay'),
              const SizedBox(width: 20),
              _trustBadge(Icons.local_shipping_outlined, 'Fast Ship'),
              const SizedBox(width: 20),
              _trustBadge(Icons.replay_outlined, '14d Return'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {Color? valueColor}) {
    return Row(
      children: [
        Text(label,
            style:
            const TextStyle(color: AppColors.darkGrey, fontSize: 13)),
        const Spacer(),
        Text(value,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: valueColor ?? AppColors.black,
            )),
      ],
    );
  }

  Widget _trustBadge(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppColors.medGrey),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(
                fontSize: 9, color: AppColors.medGrey, fontWeight: FontWeight.w600)),
      ],
    );
  }
}