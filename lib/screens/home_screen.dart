import 'package:denim_diverse/providers/denim_reviews.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../custom_drawer.dart';
import '../layout_feature.dart';
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

  final List<Map<String, dynamic>> fitsData = [
    {'id': '1', 'name': 'VINTAGE BOOT CUT', 'image': 'assets/images/bootcut.jpg', 'originalPrice': 4330.0, 'category': 'MEN', 'rating': 4.5, 'reviews': 12},
    {'id': '2', 'name': 'HIGH WAIST MOM FIT', 'image': 'assets/images/momfit.jpg', 'originalPrice': 4665.0, 'category': 'WOMEN', 'rating': 4.8, 'reviews': 25},
    {'id': '3', 'name': 'BOYFRIEND DENIM', 'image': 'assets/images/boyfriend.jpg', 'originalPrice': 4998.0, 'category': 'WOMEN', 'rating': 4.2, 'reviews': 8},
    {'id': '4', 'name': 'STREET BAGGY', 'image': 'assets/images/baggy.jpg', 'originalPrice': 5498.0, 'category': 'MEN', 'rating': 4.6, 'reviews': 19},
    {'id': '5', 'name': 'CLASSIC STRAIGHT', 'image': 'assets/images/straight.jpg', 'originalPrice': 4665.0, 'category': 'MEN', 'rating': 4.4, 'reviews': 15},
    {'id': '6', 'name': 'SUPER SKINNY', 'image': 'assets/images/skinny.jpg', 'originalPrice': 5998.0, 'category': 'WOMEN', 'rating': 4.9, 'reviews': 31},
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
                  // Mobile Categories Chips
                  if (!isWeb) _buildCategoryChips(),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: isWeb ? width * 0.1 : 20, vertical: 40),
                    child: Column(
                      children: [
                        _buildSectionHeader(selectedCategory),
                        const SizedBox(height: 40),
                        _buildProductGrid(isWeb),
                      ],
                    ),
                  ),
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

  Widget _buildProductCard(Map<String, dynamic> data) {
    double originalPrice = data['originalPrice'];
    double discountedPrice = originalPrice * 0.60;

    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/product-detail', arguments: data),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  color: const Color(0xFFF6F6F6),
                  width: double.infinity,
                  child: Image.asset(data['image']!, fit: BoxFit.cover),
                ),
                Positioned(
                  top: 10, left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    color: Colors.black,
                    child: const Text("40% OFF", style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(data['name']!.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 10, color: Colors.black, letterSpacing: 1)),
          const SizedBox(height: 6),
          Row(
            children: [
              Text("Rs. ${discountedPrice.toStringAsFixed(0)}", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Colors.redAccent)),
              const SizedBox(width: 8),
              Text("Rs. ${originalPrice.toStringAsFixed(0)}", style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11, color: Colors.grey, decoration: TextDecoration.lineThrough)),
            ],
          ),
          const SizedBox(height: 6),
          _buildStars(data['rating'], data['reviews']),
        ],
      ),
    );
  }

  Widget _buildStars(double rating, int reviews) {
    return Row(
      children: [
        ...List.generate(5, (index) => Icon(index < rating.floor() ? Icons.star : Icons.star_border, color: Colors.orange, size: 14)),
        const SizedBox(width: 5),
        Text("($reviews)", style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w600)),
      ],
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
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("NEW COLLECTION 2026", style: GoogleFonts.montserrat(fontSize: 12, color: Colors.white70, letterSpacing: 4)),
                  const SizedBox(height: 10),
                  Text("BEYOND\nTHE BLUE", style: GoogleFonts.montserrat(fontSize: isWeb ? 85 : 48, fontWeight: FontWeight.w900, color: Colors.white, height: 0.9, letterSpacing: -2)),
                  const SizedBox(height: 35),
                  _blackButton("EXPLORE NOW", onTap: _scrollToProducts)
                ]
            )
        ),
      ],
    ),
  );

  Widget _buildHeader(BuildContext context, bool isWeb) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isWeb ? 40 : 15),
      height: isWeb ? 80 : 70, color: Colors.white,
      child: Row(
        children: [
          Builder(builder: (ctx) => IconButton(icon: const Icon(Icons.menu_outlined, color: Colors.black), onPressed: () => Scaffold.of(ctx).openDrawer())),
          const SizedBox(width: 10),
          Text("DenimDiverse.", style: GoogleFonts.montserrat(fontSize: isWeb ? 24 : 18, fontWeight: FontWeight.w900, color: Colors.black)),
          const Spacer(),
          Consumer<CartProvider>(builder: (context, cart, child) => InkWell(onTap: () => Navigator.pushNamed(context, '/cart'), child: Badge(label: Text("${cart.itemCount}"), child: const Icon(Icons.shopping_bag_outlined, color: Colors.black)))),
        ],
      ),
    );
  }

  Widget _buildProductGrid(bool isWeb) {
    final filtered = fitsData.where((p) => p['name']!.toLowerCase().contains(searchQuery.toLowerCase()) && (selectedCategory == "ALL JEANS" || p['category'] == selectedCategory)).toList();
    return GridView.builder(
      shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: filtered.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: isWeb ? 4 : 2, childAspectRatio: isWeb ? 0.65 : 0.58, mainAxisSpacing: 25, crossAxisSpacing: 15),
      itemBuilder: (context, index) => _buildProductCard(filtered[index]),
    );
  }

  // --- Updated Footer with Social Icons (as per your images) ---
  Widget _buildFooter(bool isWeb) => Container(
    width: double.infinity, color: Colors.black, padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 30),
    child: Column(children: [
      Text("DenimDiverse.", style: GoogleFonts.montserrat(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white)),
      const SizedBox(height: 20),
      const Text("BEYOND THE STANDARD BLUE", style: TextStyle(color: Colors.white54, fontSize: 10, letterSpacing: 2)),
      const SizedBox(height: 30),
      // Social Icons Section
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _socialIconButton(Icons.play_circle_fill, Colors.red), // YouTube Icon
          const SizedBox(width: 20),
          _socialIconButton(Icons.camera_alt, Colors.pinkAccent), // Instagram Icon
          const SizedBox(width: 20),
          _socialIconButton(Icons.facebook, Colors.blueAccent), // Facebook Icon
        ],
      ),
      const SizedBox(height: 40),
      const Text("© 2026 DENIM DIVERSE. BY SHAIWICODE", style: TextStyle(color: Colors.white24, fontSize: 9, letterSpacing: 1)),
    ]),
  );

  Widget _socialIconButton(IconData icon, Color color) => IconButton(
    icon: Icon(icon, color: color, size: 28),
    onPressed: () {},
  );

  Widget _buildCategoryChips() => SizedBox(height: 40, child: ListView.builder(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 15), itemCount: categories.length, itemBuilder: (context, index) => Padding(padding: const EdgeInsets.only(right: 10), child: ChoiceChip(label: Text(categories[index], style: TextStyle(fontSize: 10, color: selectedCategory == categories[index] ? Colors.white : Colors.black)), selected: selectedCategory == categories[index], onSelected: (val) { if (categories[index] == "CRAZY DEALS") { Navigator.push(context, MaterialPageRoute(builder: (context) => const CrazyDealsScreen())); } else { setState(() => selectedCategory = categories[index]); _scrollToProducts(); } }, selectedColor: Colors.black, backgroundColor: const Color(0xFFF6F6F6)))));
  Widget _buildSectionHeader(String title) => Column(children: [Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 2)), const SizedBox(height: 5), Container(height: 3, width: 30, color: Colors.black)]);
  Widget _blackButton(String text, {required VoidCallback onTap}) => InkWell(onTap: onTap, child: Container(padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 18), color: Colors.black, child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11))));
  Widget _buildBlueTopBar() => Container(height: 35, color: const Color(0xFF0066D4), child: const Center(child: Text("FREE DELIVERY ON ALL ORDERS OVER RS. 5000", style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold))));
  Widget _buildCommunitySection(bool isWeb) => Container(padding: const EdgeInsets.symmetric(vertical: 60), child: Column(children: [const Text("SHOP THE LOOK", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)), const SizedBox(height: 10), Text("Our Community", style: GoogleFonts.montserrat(fontSize: isWeb ? 32 : 26, fontWeight: FontWeight.w800)), const SizedBox(height: 40), Wrap(spacing: 20, runSpacing: 20, alignment: WrapAlignment.center, children: [_communityCard("@SHAWAIZ_N", 'assets/images/user1.jpg', isWeb), _communityCard("@ASAD_MUSTAFA", 'assets/images/user2.jpg', isWeb)])]));
  Widget _communityCard(String handle, String imgPath, bool isWeb) { double cardWidth = isWeb ? 300 : (MediaQuery.of(context).size.width / 2) - 30; return Column(children: [Container(width: cardWidth, height: cardWidth * 1.2, decoration: BoxDecoration(color: const Color(0xFFF6F6F6), image: DecorationImage(image: AssetImage(imgPath), fit: BoxFit.cover))), const SizedBox(height: 10), Text(handle, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54))]); }
}