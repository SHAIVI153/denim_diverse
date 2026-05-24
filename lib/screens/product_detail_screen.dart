import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/common_widgets.dart';
import 'app_theme.dart';

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String _selectedSize = '32';
  int _quantity = 1;

  final List<String> _sizes = ['28', '30', '32', '34', '36', '38'];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isWeb = w > 900;
    final cart = context.watch<CartProvider>();
    final inCart = cart.contains(widget.product['id'] ?? '');

    final name = widget.product['name'] ?? 'Product';
    final price = (widget.product['price'] as num?)?.toDouble() ?? 0.0;
    final originalPrice =
        (widget.product['originalPrice'] as num?)?.toDouble() ?? price / 0.6;
    final image = widget.product['image'] ?? '';
    final description = widget.product['description'] ??
        'Premium quality denim with superior craftsmanship. Designed for style, comfort and durability.';
    final rating = (widget.product['rating'] as num?)?.toDouble() ?? 4.5;
    final reviews = (widget.product['reviews'] as num?)?.toInt() ?? 0;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(name.toString().toUpperCase()),
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined),
                onPressed: () => Navigator.pushNamed(context, '/cart'),
              ),
              if (cart.uniqueCount > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                        color: AppColors.black, shape: BoxShape.circle),
                    child: Center(
                      child: Text('${cart.uniqueCount}',
                          style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w900)),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: isWeb
          ? Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 5,
              child: _imageSection(image)),
          Expanded(
              flex: 5,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(48),
                child: _detailsSection(
                    name, price, originalPrice, description,
                    rating, reviews, cart, inCart),
              )),
        ],
      )
          : SingleChildScrollView(
        child: Column(
          children: [
            _imageSection(image, height: 420),
            Padding(
              padding: const EdgeInsets.all(24),
              child: _detailsSection(
                  name, price, originalPrice, description,
                  rating, reviews, cart, inCart),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageSection(String image, {double? height}) {
    return Container(
      height: height ?? MediaQuery.of(context).size.height,
      color: AppColors.surface,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              image,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Center(
                child: Icon(Icons.image_not_supported_outlined,
                    size: 80, color: AppColors.lightGrey),
              ),
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                  color: AppColors.white, shape: BoxShape.circle),
              child: const Icon(Icons.favorite_border,
                  size: 20, color: AppColors.darkGrey),
            ),
          ),
          const Positioned(
            top: 16,
            left: 16,
            child: DiscountBadge(label: '40% OFF'),
          ),
        ],
      ),
    );
  }

  Widget _detailsSection(
      String name,
      double price,
      double originalPrice,
      String description,
      double rating,
      int reviews,
      CartProvider cart,
      bool inCart,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category Tag
        const Text(
          'DENIM · PREMIUM COLLECTION',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppColors.medGrey,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 10),

        // Name
        Text(
          name,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 14),

        // Rating
        StarRating(rating: rating, reviews: reviews, size: 16),
        const SizedBox(height: 20),

        // Price
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Rs. ${price.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: AppColors.crimson,
              ),
            ),
            const SizedBox(width: 12),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                'Rs. ${originalPrice.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.lightGrey,
                  decoration: TextDecoration.lineThrough,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          color: AppColors.success.withOpacity(0.1),
          child: const Text(
            'You save Rs. 1,732 (40% off)',
            style: TextStyle(
              color: AppColors.success,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        const SizedBox(height: 28),
        const Divider(),
        const SizedBox(height: 24),

        // Size Selector
        Row(
          children: [
            const Text(
              'SELECT SIZE',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
              ),
            ),
            const Spacer(),
            GestureDetector(
              child: const Text(
                'SIZE GUIDE',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.blue,
                  decoration: TextDecoration.underline,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _sizes.map((size) {
            final selected = _selectedSize == size;
            return GestureDetector(
              onTap: () => setState(() => _selectedSize = size),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: selected ? AppColors.black : AppColors.white,
                  border: Border.all(
                    color: selected ? AppColors.black : AppColors.border,
                    width: selected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Center(
                  child: Text(
                    size,
                    style: TextStyle(
                      color: selected ? AppColors.white : AppColors.darkGrey,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 28),

        // Quantity Selector
        const Text(
          'QUANTITY',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _qtyBtn(Icons.remove, () {
              if (_quantity > 1) setState(() => _quantity--);
            }),
            Container(
              width: 52,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.symmetric(
                    horizontal: const BorderSide(color: AppColors.border)),
              ),
              child: Text(
                '$_quantity',
                style: const TextStyle(
                    fontWeight: FontWeight.w900, fontSize: 16),
              ),
            ),
            _qtyBtn(Icons.add, () => setState(() => _quantity++)),
          ],
        ),

        const SizedBox(height: 28),

        // CTA Buttons
        PrimaryButton(
          label: inCart ? 'GO TO BAG' : 'ADD TO BAG',
          color: inCart ? AppColors.navyLight : AppColors.black,
          onPressed: () {
            if (inCart) {
              Navigator.pushNamed(context, '/cart');
            } else {
              for (int i = 0; i < _quantity; i++) {
                context.read<CartProvider>().addItem(
                  widget.product['id'] ?? '',
                  price,
                  name,
                  widget.product['image'] ?? '',
                  _selectedSize,
                );
              }
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Added to bag')),
              );
            }
          },
        ),
        const SizedBox(height: 12),
        GhostButton(
          label: 'BUY NOW',
          onPressed: () {
            context.read<CartProvider>().addItem(
              widget.product['id'] ?? '',
              price,
              name,
              widget.product['image'] ?? '',
              _selectedSize,
            );
            Navigator.pushNamed(context, '/checkout');
          },
        ),

        const SizedBox(height: 32),
        const Divider(),
        const SizedBox(height: 24),

        // Description
        const Text(
          'PRODUCT DETAILS',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          description,
          style: const TextStyle(
            color: AppColors.darkGrey,
            fontSize: 13,
            height: 1.8,
          ),
        ),

        const SizedBox(height: 28),

        // Features
        ...[
          ('Premium quality denim fabric', Icons.check_circle_outline),
          ('4-way stretch for all-day comfort', Icons.check_circle_outline),
          ('Reinforced stitching for durability', Icons.check_circle_outline),
          ('Free delivery on this order', Icons.local_shipping_outlined),
          ('14-day easy returns', Icons.replay_outlined),
        ].map(
              (e) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Icon(e.$2, size: 18, color: AppColors.success),
                const SizedBox(width: 10),
                Text(e.$1,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.darkGrey)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Icon(icon, size: 18, color: AppColors.black),
      ),
    );
  }
}