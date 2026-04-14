import 'package:denim_diverse/providers/denim_deal_banner.dart';
import 'package:denim_diverse/providers/denim_reviews.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'login/login_screen.dart';
import 'denim_footer.dart';
import 'custom_drawer.dart'; // 1. Custom Drawer import kiya

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchQuery = "";
  String selectedCategory = "ALL JEANS";
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> fitsData = [
    {'id': '1', 'name': 'VINTAGE BOOT CUT', 'image': 'assets/images/bootcut.jpg', 'price': 2599.0, 'category': 'MEN'},
    {'id': '2', 'name': 'HIGH WAIST MOM FIT', 'image': 'assets/images/momfit.jpg', 'price': 2799.0, 'category': 'WOMEN'},
    {'id': '3', 'name': 'BOYFRIEND DENIM', 'image': 'assets/images/boyfriend.jpg', 'price': 2999.0, 'category': 'WOMEN'},
    {'id': '4', 'name': 'STREET BAGGY', 'image': 'assets/images/baggy.jpg', 'price': 3299.0, 'category': 'MEN'},
    {'id': '5', 'name': 'CLASSIC STRAIGHT', 'image': 'assets/images/straight.jpg', 'price': 2799.0, 'category': 'MEN'},
    {'id': '6', 'name': 'SUPER SKINNY', 'image': 'assets/images/skinny.jpg', 'price': 3599.0, 'category': 'WOMEN'},
  ];

  final List<String> categories = ["ALL JEANS", "MEN", "WOMEN", "NEW ARRIVALS"];

  void _scrollToProducts() {
    _scrollController.animateTo(
      600,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool isWeb = width > 950;

    return Scaffold(
      backgroundColor: Colors.white,
      // 2. Drawer ab Mobile aur Web dono par enable hai
      drawer: const DenimDiverseDrawer(),
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Top Bars
            SliverToBoxAdapter(
              child: Column(
                children: [
                  if (isWeb) _buildBlueTopBar(),
                  _buildHeader(context, isWeb),
                ],
              ),
            ),

            // Hero Section
            SliverPersistentHeader(
              pinned: false,
              delegate: HeroSectionDelegate(
                maxHeight: isWeb ? 600 : 450,
                child: _buildHero(width, isWeb),
              ),
            ),

            // Product & Content Area
            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5))
                  ],
                ),
                child: Column(
                  children: [
                    const PromoBannerOverlay(),
                    _buildPromoBar(),
                    const SizedBox(height: 30),

                    if (!isWeb) _buildCategoryChips(),

                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: isWeb ? width * 0.05 : 20,
                          vertical: 40
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isWeb)
                            Container(
                              width: 200,
                              margin: const EdgeInsets.only(right: 40),
                              child: _buildSidebarContent(),
                            ),
                          Expanded(
                            child: Column(
                              children: [
                                _buildSectionHeader(selectedCategory),
                                const SizedBox(height: 40),
                                _buildProductGrid(isWeb),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const DenimReviews(),
                    const SizedBox(height: 40),
                    const DenimFooter(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Updated Header with Menu Icon for All ---
  Widget _buildHeader(BuildContext context, bool isWeb) {
    return Container(
      height: isWeb ? 90 : null,
      padding: EdgeInsets.symmetric(horizontal: isWeb ? 40 : 15, vertical: isWeb ? 0 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        children: [
          // 3. Burger Icon hamesha ke liye enable kar diya
          Builder(
              builder: (ctx) => IconButton(
                  icon: const Icon(Icons.menu_outlined, color: Colors.black, size: 28),
                  onPressed: () => Scaffold.of(ctx).openDrawer()
              )
          ),

          const SizedBox(width: 10),

          Text("DenimDiverse.",
              style: GoogleFonts.montserrat(
                  fontSize: isWeb ? 26 : 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1
              )
          ),

          if (isWeb) const Spacer(),

          if (isWeb)
            SizedBox(
              width: 350,
              height: 45,
              child: TextField(
                onChanged: (value) => setState(() => searchQuery = value),
                decoration: InputDecoration(
                  hintText: "SEARCH COLLECTION...",
                  hintStyle: const TextStyle(fontSize: 10, letterSpacing: 1),
                  prefixIcon: const Icon(Icons.search, size: 18),
                  filled: true,
                  fillColor: const Color(0xFFF6F6F6),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide.none),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),

          const Spacer(),

          if (isWeb) ...[
            InkWell(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen())),
              child: _navIcon(Icons.person_outline),
            ),
            const SizedBox(width: 15),
            _navIcon(Icons.favorite_border),
            const SizedBox(width: 15),
          ],

          Consumer<CartProvider>(
            builder: (context, cart, child) => InkWell(
              onTap: () => Navigator.pushNamed(context, '/cart'),
              child: Badge(
                label: Text("${cart.itemCount}", style: const TextStyle(fontSize: 8, color: Colors.white)),
                backgroundColor: const Color(0xFF0066D4),
                child: const Icon(Icons.shopping_cart_outlined, size: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Grid & Helpers ---
  Widget _buildProductGrid(bool isWeb) {
    final filteredProducts = fitsData.where((p) {
      bool matchesSearch = p['name']!.toLowerCase().contains(searchQuery.toLowerCase());
      bool matchesCategory = selectedCategory == "ALL JEANS" || p['category'] == selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    if (filteredProducts.isEmpty) return _buildEmptyState();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredProducts.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isWeb ? 3 : 2,
        childAspectRatio: isWeb ? 0.65 : 0.6,
        mainAxisSpacing: 25,
        crossAxisSpacing: 15,
      ),
      itemBuilder: (context, index) => _buildProductCard(filteredProducts[index]),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> data) {
    double price = data['price'];
    double originalPrice = price / 0.7;
    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/product-detail', arguments: data),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(width: double.infinity, decoration: const BoxDecoration(color: Color(0xFFFBFBFB)), child: Hero(tag: data['id'], child: Image.asset(data['image']!, fit: BoxFit.cover))),
                Positioned(top: 10, left: 10, child: Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3), color: Colors.red.shade700, child: const Text("30% OFF", style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)))),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(data['name']!.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 10, letterSpacing: 1)),
          const SizedBox(height: 4),
          Row(
            children: [
              Text("Rs. ${price.toStringAsFixed(0)}", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
              const SizedBox(width: 8),
              Text("Rs. ${originalPrice.toStringAsFixed(0)}", style: const TextStyle(fontSize: 10, color: Colors.grey, decoration: TextDecoration.lineThrough)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHero(double width, bool isWeb) {
    return Container(
      width: double.infinity,
      height: isWeb ? 600 : 450,
      decoration: const BoxDecoration(color: Colors.black),
      child: Stack(
        children: [
          Positioned.fill(child: Image.asset('assets/images/denim_diverse.jpg', fit: BoxFit.cover)),
          Positioned.fill(child: Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.bottomLeft, end: Alignment.centerRight, colors: [Colors.black.withOpacity(0.8), Colors.black.withOpacity(0.2), Colors.transparent])))),
          Positioned(
            left: isWeb ? 80 : 30, bottom: isWeb ? 100 : 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 2, width: 40, color: Colors.white, margin: const EdgeInsets.only(bottom: 20)),
                Text("BEYOND THE", style: GoogleFonts.montserrat(fontSize: 12, color: Colors.white, letterSpacing: 10, fontWeight: FontWeight.w300)),
                const SizedBox(height: 5),
                Text("STANDARD\nBLUE", style: GoogleFonts.montserrat(fontSize: isWeb ? 65 : 36, fontWeight: FontWeight.w900, color: Colors.white, height: 1.0, letterSpacing: -1)),
                const SizedBox(height: 30),
                _blackButton("SHOP NOW", onTap: _scrollToProducts),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Static UI Helpers ---
  Widget _buildBlueTopBar() => Container(height: 40, color: const Color(0xFF0066D4), padding: const EdgeInsets.symmetric(horizontal: 40), child: Row(children: [Icon(Icons.email_outlined, color: Colors.white, size: 14), const SizedBox(width: 5), Text("support@denimdiverse.com", style: TextStyle(color: Colors.white, fontSize: 10)), Spacer(), Text("Welcome to Denim Diverse!", style: TextStyle(color: Colors.white, fontSize: 10)), Spacer(), Text("PKR", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))]));
  Widget _navIcon(IconData icon) => Icon(icon, size: 24, color: Colors.black87);
  Widget _buildPromoBar() => Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 12), color: Colors.black, child: const Center(child: Text("SALE: UP TO 30% OFF", style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 2))));
  Widget _buildCategoryChips() => SizedBox(height: 40, child: ListView.builder(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 15), itemCount: categories.length, itemBuilder: (context, index) { bool isSelected = selectedCategory == categories[index]; return Padding(padding: const EdgeInsets.only(right: 10), child: ChoiceChip(label: Text(categories[index], style: TextStyle(fontSize: 10, color: isSelected ? Colors.white : Colors.black)), selected: isSelected, onSelected: (val) { setState(() => selectedCategory = categories[index]); _scrollToProducts(); }, selectedColor: Colors.black, backgroundColor: Colors.white, shape: const RoundedRectangleBorder())); }));
  Widget _buildSidebarContent() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text("CATEGORIES", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 2)), const SizedBox(height: 20), ...categories.map((cat) => InkWell(onTap: () { setState(() => selectedCategory = cat); _scrollToProducts(); }, child: Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text(cat, style: TextStyle(fontSize: 10, fontWeight: selectedCategory == cat ? FontWeight.w900 : FontWeight.w400, color: selectedCategory == cat ? Colors.black : Colors.grey))))).toList()]);
  Widget _buildSectionHeader(String title) => Column(children: [Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 3)), const SizedBox(height: 8), Container(height: 2, width: 40, color: Colors.black)]);
  Widget _buildEmptyState() => Column(children: [const SizedBox(height: 50), const Icon(Icons.search_off, size: 50, color: Colors.grey), const SizedBox(height: 20), const Text("NO MATCHES FOUND", style: TextStyle(letterSpacing: 2, color: Colors.grey, fontSize: 10))]);
  Widget _blackButton(String text, {required VoidCallback onTap}) => InkWell(onTap: onTap, child: Container(padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15), color: Colors.black, child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 2))));
}

class HeroSectionDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double maxHeight;
  HeroSectionDelegate({required this.child, required this.maxHeight});
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => SizedBox.expand(child: child);
  @override
  double get maxExtent => maxHeight;
  @override
  double get minExtent => maxHeight;
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}