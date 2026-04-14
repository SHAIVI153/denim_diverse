import 'package:flutter/material.dart';

class DenimDiverseDrawer extends StatelessWidget {
  const DenimDiverseDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,

      width: MediaQuery.of(context).size.width * 0.85,
      child: Column(
        children: [
          // Header: Logo Section
          _buildHeader(),

          // Body: Categories Section
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _drawerItem(context, "New Arrivals", Icons.fiber_new_outlined),
                _drawerItem(context, "Crazy Deals", Icons.local_offer_outlined),
                _drawerItem(context, "Bundle Offers", Icons.inventory_2_outlined),
                _drawerItem(context, "Men", Icons.male_outlined),
                _drawerItem(context, "Women", Icons.female_outlined),
                _drawerItem(context, "Kids", Icons.child_care_outlined),
                _drawerItem(context, "Shop By Collection", Icons.grid_view_outlined),

                const Divider(thickness: 1, height: 30),

                _drawerItem(context, "My Account", Icons.person_outline),
                _drawerItem(context, "Track Order", Icons.local_shipping_outlined),
                _drawerItem(context, "Log in", Icons.login_outlined),
              ],
            ),
          ),

          // Footer: Language/Currency (Optional elo style)
          _buildFooter(),
        ],
      ),
    );
  }

  // Header Widget
  Widget _buildHeader() {
    return Container(
      height: 150,
      width: double.infinity,
      color: Colors.white,
      child: const Center(
        child: Text(
          "DENIM DIVERSE",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  // Single Drawer Item Widget
  Widget _drawerItem(BuildContext context, String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87, size: 22),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
      onTap: () {
        Navigator.pop(context); // Drawer close karne ke liye
        // Add your navigation logic here
      },
    );
  }

  // Footer Widget
  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      color: Colors.grey[50],
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("PKRRs", style: TextStyle(fontWeight: FontWeight.bold)),
          Icon(Icons.keyboard_arrow_down),
        ],
      ),
    );
  }
}