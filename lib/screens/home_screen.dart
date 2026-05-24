import 'package:denim_diverse/screens/product_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../product.dart';
import '../providers/cart_provider.dart';
import '../widgets/common_widgets.dart';
import '../widgets/product_card.dart';
import 'app_drawer.dart';
import 'app_theme.dart';
import 'collection_screen.dart';
import 'crazy_deals_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scroll = ScrollController();
  String _selectedCategory = 'ALL';
  final GlobalKey _productsKey = GlobalKey();

  void _scrollToProducts() {
    final ctx = _productsKey.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(ctx,
          duration: const Duration(milliseconds: 700), curve: Curves.easeInOut);
    }
  }

  List<Product> get _filteredProducts {
    final all = ProductData.allProducts;
    if (_selectedCategory == 'ALL') return all;
    return all.where((p) => p.category == _selectedCategory).toList();
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isWeb = w > 900;
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.white,
      drawer: const AppDrawer(),
      body: CustomScrollView(
        controller: _scroll,
        slivers: [
          // ── Top Banner ──
          if (isWeb)
            SliverToBoxAdapter(child: _topBanner()),

          // ── App Bar ──
          SliverAppBar(
            pinned: true,
            floating: false,
            backgroundColor: AppColors.white,
            elevation: 0,
            scrolledUnderElevation: 1,
            surfaceTintColor: Colors.transparent,
            leading: Builder(
              builder: (ctx) => IconButton(
                icon: const Icon(Icons.menu, color: AppColors.black),
                onPressed: () => Scaffold.of(ctx).openDrawer(),
              ),
            ),
            title: const Text(
              'DenimDiverse.',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 20,
                color: AppColors.black,
                letterSpacing: -0.5,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search, color: AppColors.black),
                onPressed: () {},
              ),
              Stack(
                alignment: Alignment.topRight,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_bag_outlined,
                        color: AppColors.black),
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
                          color: AppColors.black,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${cart.uniqueCount}',
                            style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 8),
            ],
          ),

          // ── Hero Section ──
          SliverToBoxAdapter(child: _hero(w, isWeb)),

          // ── Scrolling Ticker ──
          const SliverToBoxAdapter(
            child: ScrollingTicker(
              items: [
                "FREE DELIVERY ON ORDERS OVER RS. 5000",
                "PREMIUM DENIM ONLY.",
                "QUALITY YOU CAN FEEL.",
                "NEW COLLECTION 2026.",
                "BEYOND THE BLUE.",
              ],
            ),
          ),

          // ── Shop By Category ──
          SliverToBoxAdapter(
            child: _shopByCategory(w, isWeb),
          ),

          // ── Category Filter Chips ──
          SliverToBoxAdapter(
            child: _categoryChips(isWeb, w),
          ),

          // ── Product Grid Header ──
          SliverToBoxAdapter(
            child: Padding(
              key: _productsKey,
              padding: EdgeInsets.fromLTRB(
                isWeb ? w * 0.08 : 20,
                40,
                isWeb ? w * 0.08 : 20,
                20,
              ),
              child: SectionHeader(
                label: 'Our Best Sellers',
                title: _selectedCategory == 'ALL'
                    ? 'All Jeans'
                    : _selectedCategory == 'MEN'
                    ? "Men's Denim"
                    : "Women's Denim",
                action: 'VIEW ALL',
                onAction: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CollectionScreen()),
                ),
              ),
            ),
          ),

          // ── Product Grid ──
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: isWeb ? w * 0.08 : 20),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isWeb ? 4 : 2,
                childAspectRatio: isWeb ? 0.62 : 0.55,
                mainAxisSpacing: 30,
                crossAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate(
                    (ctx, i) {
                  final product = _filteredProducts[i];
                  return ProductCard(
                    product: product,
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/product-detail',
                      arguments: product.toMap(),
                    ),
                  );
                },
                childCount: _filteredProducts.length,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 60)),

          // ── Ticker ──
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ScrollingTicker(
                items: [
                  "STRETCH THAT LASTS.",
                  "CRAFTED FOR COMFORT.",
                  "PREMIUM FABRIC ONLY.",
                  "THE DENIM EDIT 2026.",
                ],
                rounded: true,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 60)),

          // ── New Arrivals ──
          SliverToBoxAdapter(
            child: _newArrivals(w, isWeb),
          ),

          // ── Promo Banners ──
          SliverToBoxAdapter(child: _promoBanners(w, isWeb)),

          // ── Ticker ──
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ScrollingTicker(
                items: [
                  "MADE TO MOVE WITH YOU.",
                  "RESPONSIBLY SOURCED DENIM.",
                  "ZERO COMPROMISE ON QUALITY.",
                ],
                rounded: true,
              ),
            ),
          ),

          // ── Reviews ──
          SliverToBoxAdapter(child: _reviews(isWeb, w)),

          // ── Community ──
          SliverToBoxAdapter(child: _community(isWeb, w)),

          // ── Footer ──
          SliverToBoxAdapter(child: _footer(isWeb)),
        ],
      ),
    );
  }

  Widget _topBanner() => Container(
    height: 36,
    color: AppColors.blue,
    child: const Center(
      child: Text(
        'FREE DELIVERY ON ALL ORDERS OVER RS. 5000  ·  SHOP NOW',
        style: TextStyle(
          color: AppColors.white,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
        ),
      ),
    ),
  );

  Widget _hero(double w, bool isWeb) {
    return Container(
      width: double.infinity,
      height: isWeb ? 680 : 520,
      color: AppColors.navy,
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.75,
              child: Image.asset('assets/images/denim_diverse.jpg',
                  fit: BoxFit.cover),
            ),
          ),
          // Gradient overlay
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [
                    Colors.transparent,
                    AppColors.navy.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ),
          // Content
          Positioned(
            left: isWeb ? w * 0.08 : 28,
            bottom: isWeb ? 100 : 60,
            right: isWeb ? w * 0.4 : 28,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'COLLECTION 2026',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.gold,
                    letterSpacing: 4,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'BEYOND\nTHE BLUE',
                  style: TextStyle(
                    fontSize: isWeb ? 80 : 52,
                    fontWeight: FontWeight.w900,
                    color: AppColors.white,
                    height: 0.9,
                    letterSpacing: -2,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Premium denim crafted for the ones\nwho dare to stand apart.',
                  style: TextStyle(
                    color: AppColors.lightGrey,
                    fontSize: 13,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 36),
                Row(
                  children: [
                    _heroBtn('EXPLORE NOW', AppColors.white, AppColors.black,
                        _scrollToProducts),
                    const SizedBox(width: 16),
                    _heroBtn('VIEW DEALS', Colors.transparent, AppColors.white,
                            () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const CrazyDealsScreen()),
                        )),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _heroBtn(
      String label, Color bg, Color text, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: AppColors.white.withOpacity(0.5)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: text,
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }

  Widget _shopByCategory(double w, bool isWeb) {
    final cats = [
      {'label': 'MEN', 'image': 'assets/images/cat_men.jpg'},
      {'label': 'WOMEN', 'image': 'assets/images/cat_women.jpg'},
      {'label': 'KIDS', 'image': 'assets/images/cat_kids.jpg'},
    ];
    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.symmetric(
          horizontal: isWeb ? w * 0.08 : 20, vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(label: 'Explore', title: 'Shop By Category'),
          const SizedBox(height: 32),
          isWeb
              ? Row(
            children: cats
                .map((c) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    right: c == cats.last ? 0 : 16),
                child: _categoryCard(c['label']!, c['image']!),
              ),
            ))
                .toList(),
          )
              : Column(
            children: cats
                .map((c) => Padding(
              padding: EdgeInsets.only(
                  bottom: c == cats.last ? 0 : 16),
              child: _categoryCard(c['label']!, c['image']!),
            ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _categoryCard(String label, String image) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CollectionScreen(initialCategory: label),
        ),
      ),
      child: Stack(
        children: [
          Container(
            height: 240,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.navyLight,
              borderRadius: BorderRadius.circular(4),
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Row(
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.arrow_forward, color: AppColors.white, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryChips(bool isWeb, double w) {
    final cats = ['ALL', 'MEN', 'WOMEN'];
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.fromLTRB(
          isWeb ? w * 0.08 : 20, 40, isWeb ? w * 0.08 : 20, 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: cats.map((cat) {
            final selected = _selectedCategory == cat;
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: () {
                  if (cat == 'DEALS') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const CrazyDealsScreen()));
                  } else {
                    setState(() => _selectedCategory = cat);
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 22, vertical: 10),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.black : AppColors.surface,
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(
                      color: selected ? AppColors.black : AppColors.border,
                    ),
                  ),
                  child: Text(
                    cat == 'ALL' ? 'ALL JEANS' : cat,
                    style: TextStyle(
                      color: selected ? AppColors.white : AppColors.darkGrey,
                      fontWeight: FontWeight.w800,
                      fontSize: 10,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _newArrivals(double w, bool isWeb) {
    final arrivals = ProductData.newArrivals;
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.symmetric(
          horizontal: isWeb ? w * 0.08 : 20, vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            label: 'Just Dropped',
            title: 'New Arrivals',
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: isWeb ? 380 : 280,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: arrivals.length,
              itemBuilder: (_, i) {
                final p = arrivals[i];
                return GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/product-detail',
                      arguments: p.toMap()),
                  child: Container(
                    width: isWeb ? 220 : 160,
                    margin: EdgeInsets.only(
                        right: i == arrivals.length - 1 ? 0 : 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: Image.asset(p.image,
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                const Positioned(
                                  top: 10,
                                  left: 10,
                                  child: DiscountBadge(
                                      label: 'NEW', color: AppColors.blue),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          p.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 10,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Rs. ${p.originalPrice.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _promoBanners(double w, bool isWeb) {
    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.symmetric(
          horizontal: isWeb ? w * 0.08 : 20, vertical: 60),
      child: isWeb
          ? Row(children: [
        Expanded(child: _promoBanner(
            'assets/images/clearenss_jeans.jpg',
            'CLEARANCE SALE',
            'Up to 70% Off on selected styles',
            'SHOP CLEARANCE',
                () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const CrazyDealsScreen())))),
        const SizedBox(width: 20),
        Expanded(child: _promoBanner(
            'assets/images/premium_hanging.jpg',
            'PREMIUM COLLECTION',
            'Crafted from the finest denim',
            'EXPLORE NOW',
                () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const CollectionScreen())))),
      ])
          : Column(children: [
        _promoBanner(
            'assets/images/clearenss_jeans.jpg',
            'CLEARANCE SALE',
            'Up to 70% Off on selected styles',
            'SHOP CLEARANCE',
                () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const CrazyDealsScreen()))),
        const SizedBox(height: 16),
        _promoBanner(
            'assets/images/premium_hanging.jpg',
            'PREMIUM COLLECTION',
            'Crafted from the finest denim',
            'EXPLORE NOW',
                () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const CollectionScreen()))),
      ]),
    );
  }

  Widget _promoBanner(String img, String label, String sub, String btn,
      VoidCallback onTap) {
    return Container(
      height: 260,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        image: DecorationImage(image: AssetImage(img), fit: BoxFit.cover),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, AppColors.black.withOpacity(0.8)],
              ),
            ),
          ),
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        color: AppColors.gold,
                        fontSize: 10,
                        letterSpacing: 3,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text(sub,
                    style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900)),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    color: AppColors.white,
                    child: Text(btn,
                        style: const TextStyle(
                            color: AppColors.black,
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _reviews(bool isWeb, double w) {
    final reviews = ProductData.reviews;
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.symmetric(
          horizontal: isWeb ? w * 0.08 : 20, vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(label: 'What They Say', title: 'Customer Reviews'),
          const SizedBox(height: 32),
          isWeb
              ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: reviews
                .map((r) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    right: r == reviews.last ? 0 : 16),
                child: _reviewCard(r),
              ),
            ))
                .toList(),
          )
              : Column(
            children: reviews
                .map((r) => Padding(
              padding: EdgeInsets.only(
                  bottom: r == reviews.last ? 0 : 16),
              child: _reviewCard(r),
            ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _reviewCard(Map<String, dynamic> r) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StarRating(rating: r['rating'].toDouble()),
          const SizedBox(height: 12),
          Text(
            '"${r['comment']}"',
            style: const TextStyle(
              fontSize: 12,
              height: 1.6,
              color: AppColors.darkGrey,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: AppColors.navy,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    r['name'][0],
                    style: const TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(r['name'],
                      style: const TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 12)),
                  Text('Bought: ${r['product']}',
                      style: const TextStyle(
                          color: AppColors.medGrey, fontSize: 10)),
                ],
              ),
              const Spacer(),
              Text(r['date'],
                  style: const TextStyle(
                      color: AppColors.lightGrey, fontSize: 9)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _community(bool isWeb, double w) {
    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.symmetric(
          horizontal: isWeb ? w * 0.08 : 20, vertical: 60),
      child: Column(
        children: [
          const Text(
            'SHOP THE LOOK',
            style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.medGrey,
                letterSpacing: 3),
          ),
          const SizedBox(height: 8),
          const Text(
            'Our Community',
            style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tag us @denimdiv_pk to be featured',
            style: TextStyle(color: AppColors.medGrey, fontSize: 12),
          ),
          const SizedBox(height: 32),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: isWeb ? 4 : 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              'assets/images/community_jeans.jpeg',
              'assets/images/hangging_banner.jpg',
              'assets/images/banner_jeans.jpg',
              'assets/images/jeans_fit.jpg',
            ]
                .map((img) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                image: DecorationImage(
                  image: AssetImage(img),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: AppColors.navy.withOpacity(0.1),
                    ),
                  ),
                  const Positioned(
                    bottom: 10,
                    left: 10,
                    child: Icon(Icons.add_circle_outline,
                        color: AppColors.white, size: 22),
                  ),
                ],
              ),
            ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _footer(bool isWeb) {
    return Container(
      color: AppColors.charcoal,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 40),
      child: Column(
        children: [
          isWeb
              ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _footerBrand()),
              Expanded(child: _footerLinks('SHOP', ['Men', 'Women', 'Kids', 'New Arrivals', 'Crazy Deals'])),
              Expanded(child: _footerLinks('HELP', ['Track Order', 'Returns', 'Size Guide', 'Contact Us', 'FAQ'])),
              Expanded(child: _footerLinks('COMPANY', ['About Us', 'Sustainability', 'Careers', 'Press', 'Blog'])),
            ],
          )
              : Column(
            children: [
              _footerBrand(),
              const SizedBox(height: 40),
              _footerLinks('SHOP', ['Men', 'Women', 'Kids', 'New Arrivals']),
            ],
          ),
          const SizedBox(height: 48),
          const Divider(color: Color(0xFF2A2A2A)),
          const SizedBox(height: 24),
          const Text(
            '© 2026 DENIM DIVERSE — BY SHAIWICODE. ALL RIGHTS RESERVED.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF444444),
              fontSize: 9,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _footerBrand() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'DenimDiverse.',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Premium denim for the ones\nwho dare to stand apart.',
          style: TextStyle(color: AppColors.medGrey, fontSize: 12, height: 1.7),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            _socialIcon(Icons.play_circle_outline, Colors.red),
            const SizedBox(width: 16),
            _socialIcon(Icons.camera_alt_outlined, Colors.pinkAccent),
            const SizedBox(width: 16),
            _socialIcon(Icons.facebook, Colors.blueAccent),
          ],
        ),
      ],
    );
  }

  Widget _socialIcon(IconData icon, Color color) => Container(
    width: 38,
    height: 38,
    decoration: BoxDecoration(
      color: const Color(0xFF222222),
      borderRadius: BorderRadius.circular(50),
    ),
    child: Icon(icon, color: color, size: 18),
  );

  Widget _footerLinks(String title, List<String> links) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 16),
        ...links.map((l) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            l,
            style: const TextStyle(
              color: AppColors.medGrey,
              fontSize: 12,
              height: 1.5,
            ),
          ),
        )),
      ],
    );
  }
}