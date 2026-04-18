import 'package:flutter/material.dart';

class DenimDiverseDrawer extends StatelessWidget {
  // Callback function add kiya
  final Function(String)? onCategorySelected;

  const DenimDiverseDrawer({super.key, this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      width: MediaQuery.of(context).size.width * 0.85,
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _drawerItem(context, "NEW ARRIVALS", Icons.fiber_new_outlined),
                // Crazy Deals ko special color diya
                _drawerItem(context, "CRAZY DEALS", Icons.local_offer_outlined, isSpecial: true),
                _drawerItem(context, "BUNDLE OFFERS", Icons.inventory_2_outlined),
                _drawerItem(context, "MEN", Icons.male_outlined),
                _drawerItem(context, "WOMEN", Icons.female_outlined),
                _drawerItem(context, "KIDS", Icons.child_care_outlined),
                _drawerItem(context, "SHOP BY COLLECTION", Icons.grid_view_outlined),

                const Divider(thickness: 1, height: 30),

                _drawerItem(context, "My Account", Icons.person_outline),
                _drawerItem(context, "Track Order", Icons.local_shipping_outlined),
                _drawerItem(context, "Log in", Icons.login_outlined),
              ],
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 120, // Height thori kam ki
      width: double.infinity,
      color: Colors.white,
      child: const Center(
        child: Text(
          "DENIM DIVERSE",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  // Parameter 'isSpecial' add kiya crazy deals ko highlight karne ke liye
  Widget _drawerItem(BuildContext context, String title, IconData icon, {bool isSpecial = false}) {
    return ListTile(
      leading: Icon(icon, color: isSpecial ? Colors.red : Colors.black87, size: 22),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14, // Thora sleek size
          fontWeight: isSpecial ? FontWeight.bold : FontWeight.w500,
          color: isSpecial ? Colors.red : Colors.black87,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
      onTap: () {
        Navigator.pop(context); // Drawer close

        // Agar callback set hai toh home screen ko category bhej do
        if (onCategorySelected != null) {
          onCategorySelected!(title.toUpperCase());
        }
      },
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      color: Colors.grey[50],
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("PKR Rs.", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          Icon(Icons.keyboard_arrow_down, size: 16),
        ],
      ),
    );
  }
}