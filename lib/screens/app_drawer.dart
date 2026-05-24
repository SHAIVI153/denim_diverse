import 'package:flutter/material.dart';
import 'app_theme.dart';

class AppDrawer extends StatelessWidget {
  final Function(String)? onNavigate;

  const AppDrawer({super.key, this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 300,
      backgroundColor: AppColors.navy,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 30, 24, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.white),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'DenimDiverse.',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'BEYOND THE STANDARD BLUE',
                    style: TextStyle(
                      color: AppColors.lightGrey,
                      fontSize: 9,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const Divider(color: Color(0xFF1E3A5F)),

            // Nav Items
            _drawerItem(context, 'HOME', Icons.home_outlined, '/'),
            _drawerItem(context, 'MEN\'S COLLECTION', Icons.person_outline, '/collection?cat=MEN'),
            _drawerItem(context, 'WOMEN\'S COLLECTION', Icons.person_outline, '/collection?cat=WOMEN'),
            _drawerItem(context, 'NEW ARRIVALS', Icons.new_releases_outlined, '/collection?cat=NEW'),
            _drawerItem(context, 'CRAZY DEALS', Icons.local_fire_department_outlined, '/deals'),
            _drawerItem(context, 'MY ORDERS', Icons.receipt_long_outlined, '/orders'),
            _drawerItem(context, 'MY CART', Icons.shopping_bag_outlined, '/cart'),

            const Spacer(),
            const Divider(color: Color(0xFF1E3A5F)),

            // Social
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'FOLLOW US',
                    style: TextStyle(
                      color: AppColors.lightGrey,
                      fontSize: 9,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _socialChip('@denimdiv_pk'),
                      const SizedBox(width: 10),
                      _socialChip('@dd_style'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '© 2026 DENIM DIVERSE',
                    style: TextStyle(
                      color: Color(0xFF2A4A6A),
                      fontSize: 9,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(BuildContext context, String label, IconData icon, String route) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        if (route == '/') {
          Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false);
        } else {
          Navigator.pushNamed(context, route.split('?')[0]);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: AppColors.white.withOpacity(0.6), size: 18),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, color: Color(0xFF1E3A5F), size: 12),
          ],
        ),
      ),
    );
  }

  Widget _socialChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF1E3A5F)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.lightGrey,
          fontSize: 9,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}