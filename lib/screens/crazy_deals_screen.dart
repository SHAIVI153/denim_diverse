import 'package:denim_diverse/screens/product_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../widgets/common_widgets.dart';
import '../widgets/product_card.dart';
import 'app_theme.dart';

class CrazyDealsScreen extends StatefulWidget {
  const CrazyDealsScreen({super.key});
  @override
  State<CrazyDealsScreen> createState() => _CrazyDealsScreenState();
}

class _CrazyDealsScreenState extends State<CrazyDealsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isWeb = w > 900;
    final cart = context.watch<CartProvider>();
    final deals = [
      ...ProductData.crazyDeals,
      ...ProductData.allProducts.where((p) => p.isOnSale),
    ];

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.white),
        title: const Text(
          'CRAZY DEALS',
          style: TextStyle(
            color: AppColors.gold,
            fontWeight: FontWeight.w900,
            fontSize: 13,
            letterSpacing: 3,
          ),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/cart'),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.shopping_bag_outlined,
                      color: AppColors.white, size: 22),
                  if (cart.uniqueCount > 0)
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                            color: AppColors.gold,
                            shape: BoxShape.circle),
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
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Hero Banner
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.black,
              padding: EdgeInsets.symmetric(
                  horizontal: isWeb ? w * 0.1 : 24, vertical: 40),
              child: Column(
                children: [
                  // Pulsing fire emoji
                  AnimatedBuilder(
                    animation: _pulse,
                    builder: (_, child) => Transform.scale(
                      scale: 1.0 + (_pulse.value * 0.12),
                      child: child,
                    ),
                    child: const Text('🔥',
                        style: TextStyle(fontSize: 52)),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'CRAZY DEALS',
                    style: TextStyle(
                      color: AppColors.gold,
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'UP TO 70% OFF  ·  LIMITED TIME ONLY',
                    style: TextStyle(
                      color: AppColors.lightGrey,
                      fontSize: 10,
                      letterSpacing: 2.5,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  // Stat badges
                  Wrap(
                    spacing: 14,
                    runSpacing: 14,
                    alignment: WrapAlignment.center,
                    children: [
                      _StatBadge('${deals.length}', 'Items on Sale'),
                      _StatBadge('70%', 'Max Discount'),
                      _StatBadge('FREE', 'Delivery'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Gold Ticker
          SliverToBoxAdapter(
            child: Container(
              height: 40,
              color: AppColors.gold,
              child: const ScrollingTicker(
                items: [
                  'SALE ENDS SOON.',
                  'LIMITED STOCK.',
                  "DON'T MISS OUT.",
                  'GRAB YOUR SIZE NOW.',
                  'CRAZY LOW PRICES.',
                ],
                bgColor: AppColors.gold,
                textColor: AppColors.black,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 28)),

          // Product Grid
          SliverPadding(
            padding: EdgeInsets.symmetric(
                horizontal: isWeb ? w * 0.06 : 14),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isWeb ? 4 : 2,
                childAspectRatio: isWeb ? 0.62 : 0.54,
                mainAxisSpacing: 20,
                crossAxisSpacing: 12,
              ),
              delegate: SliverChildBuilderDelegate(
                    (ctx, i) {
                  final p = deals[i];
                  return Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF111111),
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

          const SliverToBoxAdapter(child: SizedBox(height: 60)),

          // Footer note
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 24, vertical: 32),
              child: Column(
                children: [
                  Container(
                    height: 1,
                    color: const Color(0xFF1A1A1A),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'ALL DEALS ARE WHILE STOCKS LAST\nPRICES UPDATED DAILY',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 9,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String value;
  final String label;
  const _StatBadge(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.gold.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(
                  color: AppColors.gold,
                  fontSize: 26,
                  fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(
                  color: AppColors.lightGrey,
                  fontSize: 9,
                  letterSpacing: 1.5)),
        ],
      ),
    );
  }
}