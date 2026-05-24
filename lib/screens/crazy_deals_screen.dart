import 'package:denim_diverse/screens/product_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/common_widgets.dart';
import '../widgets/product_card.dart';
import 'app_theme.dart';

class CrazyDealsScreen extends StatelessWidget {
  const CrazyDealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isWeb = w > 900;
    final cart = context.watch<CartProvider>();
    final deals = [...ProductData.crazyDeals, ...ProductData.allProducts
        .where((p) => p.isOnSale)
        .toList()];

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        iconTheme: const IconThemeData(color: AppColors.white),
        title: const Text('CRAZY DEALS',
            style: TextStyle(color: AppColors.white)),
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined,
                    color: AppColors.white),
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
                        color: AppColors.gold, shape: BoxShape.circle),
                    child: Center(
                      child: Text('${cart.uniqueCount}',
                          style: const TextStyle(
                              color: AppColors.black,
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
      body: CustomScrollView(
        slivers: [
          // Hero Banner
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.black,
              padding: EdgeInsets.symmetric(
                  horizontal: isWeb ? w * 0.1 : 24, vertical: 48),
              child: Column(
                children: [
                  const Text(
                    '🔥',
                    style: TextStyle(fontSize: 48),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'CRAZY DEALS',
                    style: TextStyle(
                      color: AppColors.gold,
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'UP TO 70% OFF · LIMITED TIME ONLY',
                    style: TextStyle(
                      color: AppColors.lightGrey,
                      fontSize: 11,
                      letterSpacing: 3,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Countdown-style badges
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _statBadge('${deals.length}', 'Items on Sale'),
                      const SizedBox(width: 20),
                      _statBadge('70%', 'Max Discount'),
                      const SizedBox(width: 20),
                      _statBadge('FREE', 'Delivery'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Scrolling Ticker (gold theme)
          SliverToBoxAdapter(
            child: Container(
              height: 44,
              color: AppColors.gold,
              child: const ScrollingTicker(
                items: [
                  'SALE ENDS SOON.',
                  'LIMITED STOCK.',
                  'DON\'T MISS OUT.',
                  'GRAB YOUR SIZE NOW.',
                ],
                bgColor: AppColors.gold,
                textColor: AppColors.black,
              ),
            ),
          ),

          // Products Grid
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
                isWeb ? w * 0.05 : 16, 32, isWeb ? w * 0.05 : 16, 60),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isWeb ? 4 : 2,
                childAspectRatio: isWeb ? 0.62 : 0.55,
                mainAxisSpacing: 24,
                crossAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate(
                    (ctx, i) {
                  final p = deals[i];
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.charcoal,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: ProductCard(
                      product: p,
                      onTap: () => Navigator.pushNamed(
                          context, '/product-detail',
                          arguments: p.toMap()),
                    ),
                  );
                },
                childCount: deals.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statBadge(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.gold.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: AppColors.gold,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.lightGrey,
              fontSize: 9,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}