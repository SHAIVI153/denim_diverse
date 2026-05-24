import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../product.dart';
import '../providers/cart_provider.dart';
import '../screens/app_theme.dart';
import 'common_widgets.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final bool showAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.showAddToCart = true,
  });

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final inCart = cart.contains(product.id);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Container
          Expanded(
            child: Stack(
              children: [
                // Product Image
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                  ),
                  child: Image.asset(
                    product.image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Center(
                      child: Icon(Icons.image_not_supported_outlined,
                          color: AppColors.lightGrey, size: 40),
                    ),
                  ),
                ),
                // Badges
                Positioned(
                  top: 10,
                  left: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (product.isOnSale)
                        DiscountBadge(
                          label: '${product.discountPercent.toInt()}% OFF',
                          color: AppColors.black,
                        ),
                      if (product.isNew) ...[
                        const SizedBox(height: 4),
                        const DiscountBadge(
                          label: 'NEW',
                          color: AppColors.blue,
                        ),
                      ],
                    ],
                  ),
                ),
                // Wishlist
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.favorite_border,
                        size: 16, color: AppColors.darkGrey),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Product Info
          Text(
            product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 10,
              color: AppColors.black,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                'Rs. ${product.salePrice.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                  color: AppColors.crimson,
                ),
              ),
              if (product.isOnSale) ...[
                const SizedBox(width: 6),
                Text(
                  'Rs. ${product.originalPrice.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 10,
                    color: AppColors.lightGrey,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 5),
          StarRating(rating: product.rating, reviews: product.reviews),
          if (showAddToCart) ...[
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 36,
              child: ElevatedButton(
                onPressed: () {
                  context.read<CartProvider>().addItem(
                    product.id,
                    product.salePrice,
                    product.name,
                    product.image,
                    '32',
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(inCart
                          ? '${product.name} quantity updated'
                          : 'Added to bag'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  inCart ? AppColors.navyLight : AppColors.black,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2)),
                ),
                child: Text(
                  inCart ? 'IN BAG ✓' : 'ADD TO BAG',
                  style: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}