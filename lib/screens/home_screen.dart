import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/denim_reviews.dart';
import '../custom_drawer.dart';
import '../layout_feature.dart';
import '../widgets/denim_category_showcase.dart';
import 'crazy_deals_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchQuery = "";
  String selectedCategory = "ALL JEANS";
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> arrivalProducts = [
    {'name': 'PREMIUM HANGING DENIM', 'price': 1799.0, 'img': 'assets/images/premium_hanging.jpg'},
    {'name': 'VINTAGE WASHED JEANS', 'price': 1899.0, 'img': 'assets/images/wintage_washed.jpg'},
    {'name': 'DARK INDIGO SLIM', 'price': 1699.0, 'img': 'assets/images/indigo.jpg'},
    {'name': 'STREETWEAR BAGGY', 'price': 1999.0, 'img': 'assets/images/streetwear_baggy.jpg'},
    {'name': 'CLASSIC STRAIGHT CUT', 'price': 1799.0, 'img': 'assets/images/straight_wear.jpg'},
    {'name': 'RETRO LIGHT BLUE', 'price': 1999.0, 'img': 'assets/images/retro_light.jpg'},
  ];

  final List<Map<String, dynamic>> fitsData = [
    {'id': '1', 'name': 'VINTAGE BOOT CUT', 'image': 'assets/images/bootcut.jpg', 'originalPrice': 4330.0, 'category': 'MEN', 'rating': 4.5, 'reviews': 12},
    {'id': '2', 'name': 'HIGH WAIST MOM FIT', 'image': 'assets/images/momfit.jpg', 'originalPrice': 4665.0, 'category': 'WOMEN', 'rating': 4.8, 'reviews': 25},
    {'id': '3', 'name': 'BOYFRIEND DENIM', 'image': 'assets/images/boyfriend.jpg', 'originalPrice': 4998.0, 'category': 'WOMEN', 'rating': 4.2, 'reviews': 8},
    {'id': '4', 'name': 'STREET BAGGY', 'image': 'assets/images/baggy.jpg', 'originalPrice': 5498.0, 'category': 'MEN', 'rating': 4.6, 'reviews': 19},
  ];

  final List<String> categories = ["ALL JEANS", "MEN", "WOMEN", "CRAZY DEALS", "NEW ARRIVALS"];

  void _scrollToProducts() {
    _scrollController.animateTo(650, duration: const Duration(milliseconds: 800), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool isWeb = width > 950;

    return Scaffold(
      backgroundColor: const Color(0xFF0A192F),
      drawer: DenimDiverseDrawer(
        onCategorySelected: (category) {
          if (category == "CRAZY DEALS") {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const CrazyDealsScreen()));
          } else {
            setState(() => selectedCategory = category);
            _scrollToProducts();
          }
        },
      ),
      body: LayoutFeature(
        controller: _scrollController,
        child: Column(
          children: [
            if (isWeb) _buildBlueTopBar(),
            _buildHeader(context, isWeb),
            _buildHero(width, isWeb),

            Container(
              width: double.infinity,
              color: Colors.white,
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  if (!isWeb) _buildCategoryChips(),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: isWeb ? width * 0.1 : 20, vertical: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader(selectedCategory),
                        const SizedBox(height: 40),
                        _buildProductGrid(isWeb),
                      ],
                    ),
                  ),

                  _buildShopByCategory(width, isWeb),
                  const DenimScrollingTicker(),

                  // --- NEW ARRIVALS ---
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: isWeb ? width * 0.1 : 20, vertical: 60),
                    child: _buildNewArrivalsVerticalSection(width, isWeb),
                  ),

                  // --- NEW SECTION: BUNDLE & CLEARANCE BANNERS ---
                  _buildPromotionBanners(width, isWeb),

                  const DenimScrollingTicker(),

                  const DenimReviews(),
                  _buildCommunitySection(isWeb),
                  _buildFooter(isWeb),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- PROMOTION BANNERS (Image Inspired) ---
  Widget _buildPromotionBanners(double width, bool isWeb) {
    double h = isWeb ? 450 : 250;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isWeb ? width * 0.1 : 20, vertical: 30),
      child: Row(
        children: [
          // LEFT: BUNDLE BANNER
          Expanded(
            flex: 2,
            child: Container(
              height: h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25), // Rounded as per image
                image: const DecorationImage(
                  image: AssetImage('assets/images/hangging_banner.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: Colors.black26)),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("The More You Buy, The More You Save",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(color: Colors.white, fontSize: isWeb ? 28 : 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                          child: const Text("SHOP BY BUNDLE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(width: 15),
          // RIGHT: CLEARANCE BANNER
          Expanded(
            flex: 1,
            child: Container(
              height: h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                image: const DecorationImage(
                  image: AssetImage('assets/images/clearenss_jeans.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: Colors.black12)),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("LIMITED STOCK", style: TextStyle(color: Colors.white, fontSize: 8, letterSpacing: 2, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        Text("CLEARANCE", style: GoogleFonts.montserrat(color: Colors.white, fontSize: isWeb ? 36 : 18, fontWeight: FontWeight.w900)),
                        Container(height: 4, width: 100, color: Colors.orange), // Styled underline
                        const SizedBox(height: 10),
                        const Text("up to 60% off", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- REST OF THE CODE REMAINS UNCHANGED ---
  Widget _buildShopByCategory(double width, bool isWeb) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isWeb ? width * 0.1 : 20, vertical: 60),
      child: Column(
        children: [
          Text("FIND EVERYTHING YOU NEED IN ONE PLACE", style: GoogleFonts.montserrat(fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.bold, color: Colors.grey[600])),
          const SizedBox(height: 10),
          Text("SHOP BY CATEGORY", style: GoogleFonts.montserrat(fontSize: isWeb ? 32 : 24, fontWeight: FontWeight.w900, color: Colors.black)),
          const SizedBox(height: 40),
          Row(
            children: [
              Expanded(child: _categoryCard("MEN", "MODERN ELITE", "Style Redefined", "assets/images/cat_men.jpg", isWeb)),
              const SizedBox(width: 15),
              Expanded(child: _categoryCard("WOMEN", "DAILY EASE", "Made For Comfort", "assets/images/cat_women.jpg", isWeb)),
              const SizedBox(width: 15),
              Expanded(child: _categoryCard("KIDS", "DAILY FUN", "Designed For Activity", "assets/images/cat_kids.jpg", isWeb)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _categoryCard(String title, String subtitle, String tagline, String imgPath, bool isWeb) {
    return Container(
      height: isWeb ? 500 : 300,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), image: DecorationImage(image: AssetImage(imgPath), fit: BoxFit.cover)),
      child: Stack(
        children: [
          Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Colors.black.withOpacity(0.7), Colors.transparent]))),
          Positioned(
            bottom: 20, left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subtitle, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text(title, style: GoogleFonts.montserrat(color: Colors.white, fontSize: isWeb ? 28 : 18, fontWeight: FontWeight.w900)),
                const SizedBox(height: 5),
                Text(tagline, style: const TextStyle(color: Colors.white70, fontSize: 9)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewArrivalsVerticalSection(double width, bool isWeb) {
    double sectionHeight = isWeb ? 750 : 600;
    return SizedBox(
      height: sectionHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: isWeb ? width * 0.30 : width * 0.40, height: sectionHeight,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), image: const DecorationImage(image: AssetImage('assets/images/jeans_fit.jpg'), fit: BoxFit.cover)),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Colors.black.withOpacity(0.8), Colors.transparent])),
              child: Column(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text("2026 EDITION", style: GoogleFonts.montserrat(fontSize: 10, color: Colors.white70, letterSpacing: 2, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text("THE\nDENIM\nEDIT", style: GoogleFonts.montserrat(fontSize: isWeb ? 32 : 20, fontWeight: FontWeight.w900, color: Colors.white, height: 1.1)),
              ]),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 20),
              child: GridView.builder(
                padding: EdgeInsets.zero, itemCount: arrivalProducts.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: isWeb ? 2 : 1, childAspectRatio: isWeb ? 0.65 : 0.8, crossAxisSpacing: 15, mainAxisSpacing: 20),
                itemBuilder: (context, index) => _buildArrivalItem(arrivalProducts[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArrivalItem(Map<String, dynamic> product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Container(decoration: BoxDecoration(color: const Color(0xFFF6F6F6), borderRadius: BorderRadius.circular(4), image: DecorationImage(image: AssetImage(product['img']), fit: BoxFit.cover)))),
        const SizedBox(height: 10),
        Text(product['name'], maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.black87)),
        Text("Rs. ${product['price'].toStringAsFixed(0)}", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
        const SizedBox(height: 8),
        SizedBox(width: double.infinity, height: 35, child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)), elevation: 0), child: const Text("ADD TO BAG", style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)))),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, bool isWeb) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isWeb ? 40 : 15),
      height: isWeb ? 80 : 70, color: Colors.white,
      child: Row(children: [
        Builder(builder: (ctx) => IconButton(icon: const Icon(Icons.menu_outlined, color: Colors.black), onPressed: () => Scaffold.of(ctx).openDrawer())),
        const SizedBox(width: 10),
        Text("DenimDiverse.", style: GoogleFonts.montserrat(fontSize: isWeb ? 24 : 18, fontWeight: FontWeight.w900, color: Colors.black)),
        const Spacer(),
        Consumer<CartProvider>(builder: (context, cart, child) => InkWell(onTap: () => Navigator.pushNamed(context, '/cart'), child: Badge(label: Text("${cart.itemCount}"), child: const Icon(Icons.shopping_bag_outlined, color: Colors.black)))),
      ]),
    );
  }

  Widget _buildHero(double width, bool isWeb) => Container(
    width: double.infinity, height: isWeb ? 650 : 500,
    decoration: const BoxDecoration(color: Color(0xFF0A192F)),
    child: Stack(
      children: [
        Positioned.fill(child: Opacity(opacity: 0.8, child: Image.asset('assets/images/denim_diverse.jpg', fit: BoxFit.cover))),
        Positioned(
          left: isWeb ? 80 : 30, top: isWeb ? 220 : 160,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("COLLECTION 2026", style: GoogleFonts.montserrat(fontSize: 12, color: Colors.white70, letterSpacing: 4)),
            const SizedBox(height: 10),
            Text("BEYOND\nTHE BLUE", style: GoogleFonts.montserrat(fontSize: isWeb ? 85 : 48, fontWeight: FontWeight.w900, color: Colors.white, height: 0.9, letterSpacing: -2)),
            const SizedBox(height: 30),
            _blackButton("EXPLORE NOW", onTap: _scrollToProducts)
          ]),
        ),
      ],
    ),
  );

  Widget _buildProductGrid(bool isWeb) {
    final filtered = fitsData.where((p) => p['name']!.toLowerCase().contains(searchQuery.toLowerCase()) && (selectedCategory == "ALL JEANS" || p['category'] == selectedCategory)).toList();
    return GridView.builder(
      shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: filtered.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: isWeb ? 4 : 2, childAspectRatio: isWeb ? 0.65 : 0.58, mainAxisSpacing: 25, crossAxisSpacing: 15),
      itemBuilder: (context, index) => _buildProductCard(filtered[index]),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> data) {
    double originalPrice = data['originalPrice'];
    double discountedPrice = originalPrice * 0.60;
    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/product-detail', arguments: data),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Stack(children: [Container(color: const Color(0xFFF6F6F6), width: double.infinity, child: Image.asset(data['image']!, fit: BoxFit.cover)), Positioned(top: 10, left: 10, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), color: Colors.black, child: const Text("40% OFF", style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold))))])),
          const SizedBox(height: 12),
          Text(data['name']!.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 10, color: Colors.black, letterSpacing: 1)),
          const SizedBox(height: 6),
          Row(children: [Text("Rs. ${discountedPrice.toStringAsFixed(0)}", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Colors.redAccent)), const SizedBox(width: 8), Text("Rs. ${originalPrice.toStringAsFixed(0)}", style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11, color: Colors.grey, decoration: TextDecoration.lineThrough))]),
          const SizedBox(height: 6),
          _buildStars(data['rating'], data['reviews']),
        ],
      ),
    );
  }

  Widget _buildStars(double rating, int reviews) {
    return Row(children: [...List.generate(5, (index) => Icon(index < rating.floor() ? Icons.star : Icons.star_border, color: Colors.orange, size: 14)), const SizedBox(width: 5), Text("($reviews)", style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w600))]);
  }

  Widget _buildFooter(bool isWeb) => Container(width: double.infinity, color: Colors.black, padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 30), child: Column(children: [Text("DenimDiverse.", style: GoogleFonts.montserrat(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white)), const SizedBox(height: 20), const Text("BEYOND THE STANDARD BLUE", style: TextStyle(color: Colors.white54, fontSize: 10, letterSpacing: 2)), const SizedBox(height: 30), Row(mainAxisAlignment: MainAxisAlignment.center, children: [_socialIconButton(Icons.play_circle_fill, Colors.red), const SizedBox(width: 20), _socialIconButton(Icons.camera_alt, Colors.pinkAccent), const SizedBox(width: 20), _socialIconButton(Icons.facebook, Colors.blueAccent)]), const SizedBox(height: 40), const Text("© 2026 DENIM DIVERSE. BY SHAIWICODE", style: TextStyle(color: Colors.white24, fontSize: 9, letterSpacing: 1))]));
  Widget _socialIconButton(IconData icon, Color color) => IconButton(icon: Icon(icon, color: color, size: 28), onPressed: () {});
  Widget _buildCategoryChips() => SizedBox(height: 40, child: ListView.builder(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 15), itemCount: categories.length, itemBuilder: (context, index) => Padding(padding: const EdgeInsets.only(right: 10), child: ChoiceChip(label: Text(categories[index], style: TextStyle(fontSize: 10, color: selectedCategory == categories[index] ? Colors.white : Colors.black)), selected: selectedCategory == categories[index], onSelected: (val) { if (categories[index] == "CRAZY DEALS") { Navigator.push(context, MaterialPageRoute(builder: (context) => const CrazyDealsScreen())); } else { setState(() => selectedCategory = categories[index]); _scrollToProducts(); } }, selectedColor: Colors.black, backgroundColor: const Color(0xFFF6F6F6)))));
  Widget _buildSectionHeader(String title) => Column(children: [Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 2)), const SizedBox(height: 5), Container(height: 3, width: 30, color: Colors.black)]);
  Widget _blackButton(String text, {required VoidCallback onTap}) => InkWell(onTap: onTap, child: Container(padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 18), color: Colors.black, child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11))));
  Widget _buildBlueTopBar() => Container(height: 35, color: const Color(0xFF0066D4), child: const Center(child: Text("FREE DELIVERY ON ALL ORDERS OVER RS. 5000", style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold))));
  Widget _buildCommunitySection(bool isWeb) => Container(padding: const EdgeInsets.symmetric(vertical: 60), child: Column(children: [const Text("SHOP THE LOOK", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)), const SizedBox(height: 10), Text("Our Community", style: GoogleFonts.montserrat(fontSize: isWeb ? 32 : 26, fontWeight: FontWeight.w800)), const SizedBox(height: 40), Wrap(spacing: 20, runSpacing: 20, alignment: WrapAlignment.center, children: [_communityCard("@SHAWAIZ_N", 'assets/images/user1.jpg', isWeb), _communityCard("@ASAD_MUSTAFA", 'assets/images/user2.jpg', isWeb)])]));
  Widget _communityCard(String handle, String imgPath, bool isWeb) { double cardWidth = isWeb ? 300 : (MediaQuery.of(context).size.width / 2) - 30; return Column(children: [Container(width: cardWidth, height: cardWidth * 1.2, decoration: BoxDecoration(color: const Color(0xFFF6F6F6), image: DecorationImage(image: AssetImage(imgPath), fit: BoxFit.cover))), const SizedBox(height: 10), Text(handle, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54))]); }
}

class DenimScrollingTicker extends StatefulWidget {
  const DenimScrollingTicker({super.key});
  @override
  State<DenimScrollingTicker> createState() => _DenimScrollingTickerState();
}

class _DenimScrollingTickerState extends State<DenimScrollingTicker> {
  late ScrollController _tickerController;
  @override
  void initState() { super.initState(); _tickerController = ScrollController(); WidgetsBinding.instance.addPostFrameCallback((_) => _startScrolling()); }
  void _startScrolling() async { while (_tickerController.hasClients) { await Future.delayed(const Duration(milliseconds: 30)); if (_tickerController.hasClients) { double maxScroll = _tickerController.position.maxScrollExtent; double currentScroll = _tickerController.offset; if (currentScroll >= maxScroll) { _tickerController.jumpTo(0); } else { _tickerController.animateTo(currentScroll + 2.5, duration: const Duration(milliseconds: 30), curve: Curves.linear); } } } }
  @override
  void dispose() { _tickerController.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    final List<String> tickerItems = ["DENIM YOU'LL LOVE.", "QUALITY YOU CAN FEEL.", "STRETCH THAT LASTS.", "CRAFTED FOR COMFORT.", "BEYOND THE BLUE.", "PREMIUM FABRIC ONLY."];
    return Container(
      height: 45, width: double.infinity, decoration: const BoxDecoration(color: Colors.black),
      child: ListView.builder(
        controller: _tickerController, scrollDirection: Axis.horizontal, physics: const NeverScrollableScrollPhysics(), itemCount: 200,
        itemBuilder: (context, index) => Row(children: [const SizedBox(width: 50), Text(tickerItems[index % tickerItems.length], style: GoogleFonts.montserrat(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.5)), const SizedBox(width: 50), const Icon(Icons.circle, size: 4, color: Colors.orange)]),
      ),
    );
  }
}