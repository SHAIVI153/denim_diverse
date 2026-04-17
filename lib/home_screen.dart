import 'package:denim_diverse/providers/denim_deal_banner.dart';
import 'package:denim_diverse/providers/denim_reviews.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'login/login_screen.dart';
import 'custom_drawer.dart';
import 'layout_feature.dart';

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
      backgroundColor: const Color(0xFF0A192F),
      drawer: const DenimDiverseDrawer(),
      body: LayoutFeature(
        controller: _scrollController,
        child: Column(
          children: [
            if (isWeb) _buildBlueTopBar(),
            _buildHeader(context, isWeb),
            _buildHero(width, isWeb),
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

            // Image 38bbc5.png: Social Bar Section
            const SizedBox(height: 60),
            const Text("FOLLOW US ON SOCIAL MEDIA FOR THE LATEST UPDATES",
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
            const SizedBox(height: 25),
            const SocialMarquee(),

            // Image 2ecda0.jpg: Community Section
            _buildCommunitySection(isWeb),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  // --- Community Grid Section ---
  Widget _buildCommunitySection(bool isWeb) {
    return Column(
      children: [
        const SizedBox(height: 80),
        const Text("TAG @DENIM_DIVERSE FOR A CHANCE TO BE FEATURED",
            style: TextStyle(fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 15),
        Text("Join our community of 725K+",
            style: GoogleFonts.montserrat(fontSize: isWeb ? 35 : 24, fontWeight: FontWeight.w800)),
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Wrap(
            spacing: 20,
            runSpacing: 30,
            alignment: WrapAlignment.center,
            children: [
              _communityCard("@SHAWAIZ_N", 'assets/images/user1.jpg', isWeb),
              _communityCard("@ASAD_MUSTAFA", 'assets/images/user2.jpg', isWeb),
              _communityCard("@NOMAN_KHAN", 'assets/images/user3.jpg', isWeb),
              _communityCard("@SALMAN_KHAN", 'assets/images/user4.jpg', isWeb),
            ],
          ),
        ),
      ],
    );
  }

  Widget _communityCard(String handle, String imgPath, bool isWeb) {
    double cardWidth = isWeb ? 280 : (MediaQuery.of(context).size.width / 2) - 30;
    return Column(
      children: [
        Text(handle, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Container(
          width: cardWidth,
          height: cardWidth * 1.3,
          decoration: BoxDecoration(
            color: const Color(0xFFF6F6F6),
            image: DecorationImage(image: AssetImage(imgPath), fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 12),
        const Text("SHOP THE LOOK",
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
      ],
    );
  }

  // --- UI Helpers ---
  Widget _buildHeader(BuildContext context, bool isWeb) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isWeb ? 40 : 15, vertical: isWeb ? 0 : 20),
      height: isWeb ? 90 : null,
      decoration: BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: Colors.grey.shade100))),
      child: Row(
        children: [
          Builder(builder: (ctx) => IconButton(icon: const Icon(Icons.menu_outlined, color: Colors.black, size: 28), onPressed: () => Scaffold.of(ctx).openDrawer())),
          const SizedBox(width: 10),
          Text("DenimDiverse.", style: GoogleFonts.montserrat(fontSize: isWeb ? 26 : 18, fontWeight: FontWeight.w900, letterSpacing: -1)),
          if (isWeb) const Spacer(),
          if (isWeb)
            SizedBox(
              width: 350, height: 45,
              child: TextField(
                onChanged: (value) => setState(() => searchQuery = value),
                decoration: InputDecoration(hintText: "SEARCH COLLECTION...", prefixIcon: const Icon(Icons.search, size: 18), filled: true, fillColor: const Color(0xFFF6F6F6), border: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide.none), contentPadding: EdgeInsets.zero),
              ),
            ),
          const Spacer(),
          Consumer<CartProvider>(
            builder: (context, cart, child) => InkWell(
              onTap: () => Navigator.pushNamed(context, '/cart'),
              child: Badge(label: Text("${cart.itemCount}", style: const TextStyle(fontSize: 8, color: Colors.white)), backgroundColor: const Color(0xFF0066D4), child: const Icon(Icons.shopping_cart_outlined, size: 24)),
            ),
          ),
        ],
      ),
    );
  }

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
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: isWeb ? 3 : 2, childAspectRatio: isWeb ? 0.65 : 0.6, mainAxisSpacing: 25, crossAxisSpacing: 15),
      itemBuilder: (context, index) => _buildProductCard(filteredProducts[index]),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> data) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/product-detail', arguments: data),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Container(color: const Color(0xFFFBFBFB), child: Image.asset(data['image']!, fit: BoxFit.cover))),
          const SizedBox(height: 12),
          Text(data['name']!.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 10, letterSpacing: 1)),
          Text("Rs. ${data['price'].toStringAsFixed(0)}", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildHero(double width, bool isWeb) {
    return Container(
      width: double.infinity, height: isWeb ? 600 : 450, color: Colors.black,
      child: Stack(
        children: [
          Positioned.fill(child: Image.asset('assets/images/denim_diverse.jpg', fit: BoxFit.cover)),
          Positioned(left: isWeb ? 80 : 30, bottom: isWeb ? 100 : 60, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("BEYOND THE", style: GoogleFonts.montserrat(fontSize: 12, color: Colors.white, letterSpacing: 10)), Text("STANDARD\nBLUE", style: GoogleFonts.montserrat(fontSize: isWeb ? 65 : 36, fontWeight: FontWeight.w900, color: Colors.white, height: 1.0)), const SizedBox(height: 30), _blackButton("SHOP NOW", onTap: _scrollToProducts)])),
        ],
      ),
    );
  }

  Widget _buildBlueTopBar() => Container(height: 40, color: const Color(0xFF0066D4), child: const Center(child: Text("FREE SHIPPING ON ORDERS OVER RS. 5000", style: TextStyle(color: Colors.white, fontSize: 10))));
  Widget _buildPromoBar() => Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 12), color: Colors.black, child: const Center(child: Text("SALE: UP TO 30% OFF", style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 2))));
  Widget _buildCategoryChips() => SizedBox(height: 40, child: ListView.builder(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 15), itemCount: categories.length, itemBuilder: (context, index) { bool isSelected = selectedCategory == categories[index]; return Padding(padding: const EdgeInsets.only(right: 10), child: ChoiceChip(label: Text(categories[index], style: TextStyle(fontSize: 10, color: isSelected ? Colors.white : Colors.black)), selected: isSelected, onSelected: (val) { setState(() => selectedCategory = categories[index]); _scrollToProducts(); }, selectedColor: Colors.black, backgroundColor: Colors.white)); }));
  Widget _buildSidebarContent() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text("CATEGORIES", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12)), const SizedBox(height: 20), ...categories.map((cat) => InkWell(onTap: () { setState(() => selectedCategory = cat); _scrollToProducts(); }, child: Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text(cat, style: TextStyle(fontSize: 10, fontWeight: selectedCategory == cat ? FontWeight.w900 : FontWeight.w400))))).toList()]);
  Widget _buildSectionHeader(String title) => Column(children: [Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 3)), Container(height: 2, width: 40, color: Colors.black)]);
  Widget _buildEmptyState() => const Column(children: [SizedBox(height: 50), Icon(Icons.search_off, size: 50, color: Colors.grey), Text("NO MATCHES FOUND", style: TextStyle(fontSize: 10))]);
  Widget _blackButton(String text, {required VoidCallback onTap}) => InkWell(onTap: onTap, child: Container(padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15), color: Colors.black, child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10))));
}

// --- Moving Social Bar (Infinite Slow Loop) ---
class SocialMarquee extends StatefulWidget {
  const SocialMarquee({super.key});
  @override
  State<SocialMarquee> createState() => _SocialMarqueeState();
}

class _SocialMarqueeState extends State<SocialMarquee> {
  late ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    Future.delayed(const Duration(milliseconds: 500), _animate);
  }

  void _animate() {
    if (_scrollController.hasClients) {
      double maxScroll = _scrollController.position.maxScrollExtent;
      // Duration ko mazeed barha kar 100 seconds kar diya hai mazeed slow karne ke liye
      _scrollController.animateTo(
        maxScroll,
        duration: const Duration(seconds: 100),
        curve: Curves.linear,
      ).then((_) {
        if (mounted) {
          _scrollController.jumpTo(0);
          _animate();
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 1000,
        itemBuilder: (context, index) => Row(
          children: [
            _item(Icons.camera_alt, const Color(0xFFE4405F), "@denim.diverse"),
            _item(Icons.facebook, const Color(0xFF1877F2), "denim.intl"),
            _item(Icons.play_circle_fill, const Color(0xFFFF0000), "@denim_diverse"),
            _item(Icons.music_note, Colors.black, "@denim.diverse"),
          ],
        ),
      ),
    );
  }

  Widget _item(IconData icon, Color color, String text) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 50),
    child: Row(
      children: [
        Icon(icon, size: 22, color: color),
        const SizedBox(width: 10),
        Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black))
      ],
    ),
  );
}