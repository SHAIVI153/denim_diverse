import 'package:denim_diverse/providers/denim_deal_banner.dart';
import 'package:denim_diverse/providers/denim_reviews.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
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
    {'id': '5', 'name': 'CLASSIC STRAIGHT', 'image': 'assets/images/straight_wear.jpg', 'price': 2799.0, 'category': 'MEN'},
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
      backgroundColor: Colors.white, // Standard white for better mobile readability
      drawer: const DenimDiverseDrawer(),
      body: LayoutFeature(
        controller: _scrollController,
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (isWeb) _buildBlueTopBar(),
              _buildHeader(context, isWeb),
              _buildHero(width, isWeb),
              const PromoBannerOverlay(),
              _buildPromoBar(),
              const SizedBox(height: 20),

              if (!isWeb) _buildCategoryChips(),

              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: isWeb ? width * 0.05 : 15,
                    vertical: isWeb ? 40 : 20
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
                          const SizedBox(height: 30),
                          _buildProductGrid(isWeb),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const DenimReviews(),

              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "FOLLOW US ON SOCIAL MEDIA",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: isWeb ? 11 : 9, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                ),
              ),
              const SizedBox(height: 25),
              const SocialMarquee(),

              _buildCommunitySection(isWeb),

              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  // --- Community Grid Section ---
  Widget _buildCommunitySection(bool isWeb) {
    return Column(
      children: [
        const SizedBox(height: 60),
        Text("TAG @DENIM_DIVERSE",
            style: TextStyle(fontSize: isWeb ? 10 : 8, letterSpacing: 2, fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 10),
        Text("Join our community",
            style: GoogleFonts.montserrat(fontSize: isWeb ? 35 : 22, fontWeight: FontWeight.w800)),
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Wrap(
            spacing: isWeb ? 20 : 10,
            runSpacing: isWeb ? 30 : 20,
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
    double width = MediaQuery.of(context).size.width;
    double cardWidth = isWeb ? 280 : (width / 2) - 25;
    return Column(
      children: [
        Text(handle, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          width: cardWidth,
          height: cardWidth * 1.2,
          decoration: BoxDecoration(
            color: const Color(0xFFF6F6F6),
            image: DecorationImage(image: AssetImage(imgPath), fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 8),
        const Text("SHOP THE LOOK",
            style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, bool isWeb) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isWeb ? 40 : 10, vertical: 15),
      decoration: BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: Colors.grey.shade100))),
      child: Row(
        children: [
          Builder(builder: (ctx) => IconButton(icon: Icon(Icons.menu_outlined, color: Colors.black, size: isWeb ? 28 : 24), onPressed: () => Scaffold.of(ctx).openDrawer())),
          const SizedBox(width: 5),
          Text("DenimDiverse.", style: GoogleFonts.montserrat(fontSize: isWeb ? 24 : 16, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
          const Spacer(),
          if (isWeb)
            SizedBox(
              width: 300, height: 40,
              child: TextField(
                onChanged: (value) => setState(() => searchQuery = value),
                decoration: InputDecoration(hintText: "SEARCH...", prefixIcon: const Icon(Icons.search, size: 16), filled: true, fillColor: const Color(0xFFF6F6F6), border: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide.none), contentPadding: EdgeInsets.zero),
              ),
            ),
          if (!isWeb) IconButton(onPressed: (){}, icon: const Icon(Icons.search, size: 22)),
          Consumer<CartProvider>(
            builder: (context, cart, child) => InkWell(
              onTap: () => Navigator.pushNamed(context, '/cart'),
              child: Badge(label: Text("${cart.itemCount}", style: const TextStyle(fontSize: 8, color: Colors.white)), backgroundColor: const Color(0xFF0066D4), child: const Icon(Icons.shopping_cart_outlined, size: 22)),
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
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isWeb ? 3 : 2,
          childAspectRatio: isWeb ? 0.7 : 0.62,
          mainAxisSpacing: 20,
          crossAxisSpacing: 12
      ),
      itemBuilder: (context, index) => _buildProductCard(filteredProducts[index]),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> data) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/product-detail', arguments: data),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Container(decoration: BoxDecoration(color: const Color(0xFFFBFBFB), borderRadius: BorderRadius.circular(4)), child: ClipRRect(borderRadius: BorderRadius.circular(4), child: Image.asset(data['image']!, fit: BoxFit.cover)))),
          const SizedBox(height: 10),
          Text(data['name']!.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 9, letterSpacing: 0.5), maxLines: 1, overflow: TextOverflow.ellipsis),
          Text("Rs. ${data['price'].toStringAsFixed(0)}", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildHero(double width, bool isWeb) {
    return Container(
      width: double.infinity, height: isWeb ? 600 : 350,
      child: Stack(
        children: [
          Positioned.fill(child: Image.asset('assets/images/denim_diverse.jpg', fit: BoxFit.cover)),
          Positioned.fill(child: Container(color: Colors.black.withOpacity(0.2))),
          Positioned(
              left: isWeb ? 80 : 20,
              bottom: isWeb ? 100 : 40,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("BEYOND THE", style: GoogleFonts.montserrat(fontSize: isWeb ? 12 : 10, color: Colors.white, letterSpacing: 8)),
                    Text("STANDARD\nBLUE", style: GoogleFonts.montserrat(fontSize: isWeb ? 60 : 32, fontWeight: FontWeight.w900, color: Colors.white, height: 1.0)),
                    const SizedBox(height: 20),
                    _blackButton("SHOP NOW", onTap: _scrollToProducts, isWeb: isWeb)
                  ]
              )
          ),
        ],
      ),
    );
  }

  Widget _buildBlueTopBar() => Container(height: 35, color: const Color(0xFF0066D4), child: const Center(child: Text("FREE SHIPPING OVER RS. 5000", style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold))));
  Widget _buildPromoBar() => Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 10), color: Colors.black, child: const Center(child: Text("SALE: UP TO 30% OFF", style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 2))));

  Widget _buildCategoryChips() => Container(
      height: 50,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            bool isSelected = selectedCategory == categories[index];
            return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(categories[index], style: TextStyle(fontSize: 9, color: isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
                  selected: isSelected,
                  onSelected: (val) { setState(() => selectedCategory = categories[index]); _scrollToProducts(); },
                  selectedColor: Colors.black,
                  backgroundColor: Colors.grey.shade100,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                )
            );
          }
      )
  );

  Widget _buildSidebarContent() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text("CATEGORIES", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12)), const SizedBox(height: 20), ...categories.map((cat) => InkWell(onTap: () { setState(() => selectedCategory = cat); _scrollToProducts(); }, child: Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text(cat, style: TextStyle(fontSize: 10, fontWeight: selectedCategory == cat ? FontWeight.w900 : FontWeight.w400))))).toList()]);
  Widget _buildSectionHeader(String title) => Column(children: [Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 2)), Container(height: 2, width: 30, color: Colors.black, margin: const EdgeInsets.only(top: 4))]);
  Widget _buildEmptyState() => const Column(children: [SizedBox(height: 50), Icon(Icons.search_off, size: 40, color: Colors.grey), Text("NO MATCHES FOUND", style: TextStyle(fontSize: 10))]);

  Widget _blackButton(String text, {required VoidCallback onTap, required bool isWeb}) => InkWell(
      onTap: onTap,
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: isWeb ? 40 : 25, vertical: isWeb ? 15 : 12),
          color: Colors.black,
          child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 9))
      )
  );
}

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
    bool isWeb = MediaQuery.of(context).size.width > 950;
    return SizedBox(
      height: 40,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 12,
        itemBuilder: (context, index) => Row(
          children: [
            _item(Icons.camera_alt, const Color(0xFFE4405F), "@denim.diverse", isWeb),
            _item(Icons.facebook, const Color(0xFF1877F2), "denim.intl", isWeb),
            _item(Icons.play_circle_fill, const Color(0xFFFF0000), "@denim_diverse", isWeb),
            _item(Icons.tiktok, Colors.black, "@denim.diverse", isWeb),
          ],
        ),
      ),
    );
  }

  Widget _item(IconData icon, Color color, String text, bool isWeb) => Padding(
    padding: EdgeInsets.symmetric(horizontal: isWeb ? 50 : 25),
    child: Row(
      children: [
        Icon(icon, size: isWeb ? 28 : 20, color: color),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(fontSize: isWeb ? 13 : 10, fontWeight: FontWeight.w600, color: Colors.black))
      ],
    ),
  );
}