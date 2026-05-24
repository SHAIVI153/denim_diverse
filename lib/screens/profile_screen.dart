import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../widgets/common_widgets.dart';
import 'app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrderProvider>().orders;
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('MY PROFILE'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header Card
            Container(
              width: double.infinity,
              color: AppColors.white,
              padding: const EdgeInsets.all(28),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          color: AppColors.navy,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: AppColors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.black.withOpacity(0.12),
                              blurRadius: 20,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'G',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 34,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            color: AppColors.black,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.edit,
                              size: 14, color: AppColors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Guest User',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'guest@denimdiv.com',
                    style: TextStyle(
                        color: AppColors.medGrey, fontSize: 13),
                  ),
                  const SizedBox(height: 20),

                  // Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _statItem('${orders.length}', 'Orders'),
                      _dividerV(),
                      _statItem('${cart.uniqueCount}', 'In Bag'),
                      _dividerV(),
                      _statItem('0', 'Wishlist'),
                    ],
                  ),

                  const SizedBox(height: 20),
                  GhostButton(
                    label: 'SIGN IN / REGISTER',
                    height: 44,
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Menu Sections
            _menuSection(context, 'MY ACCOUNT', [
              _MenuTile(
                icon: Icons.receipt_long_outlined,
                label: 'My Orders',
                subtitle: '${orders.length} orders placed',
                onTap: () => Navigator.pushNamed(context, '/orders'),
              ),
              _MenuTile(
                icon: Icons.shopping_bag_outlined,
                label: 'My Bag',
                subtitle: '${cart.itemCount} items',
                onTap: () => Navigator.pushNamed(context, '/cart'),
              ),
              _MenuTile(
                icon: Icons.favorite_border,
                label: 'Wishlist',
                subtitle: '0 saved items',
                onTap: () {},
              ),
              _MenuTile(
                icon: Icons.location_on_outlined,
                label: 'Saved Addresses',
                subtitle: 'Manage delivery addresses',
                onTap: () {},
              ),
            ]),

            const SizedBox(height: 12),

            _menuSection(context, 'SUPPORT', [
              _MenuTile(
                icon: Icons.help_outline,
                label: 'Help & FAQ',
                onTap: () {},
              ),
              _MenuTile(
                icon: Icons.chat_bubble_outline,
                label: 'Contact Us',
                onTap: () {},
              ),
              _MenuTile(
                icon: Icons.policy_outlined,
                label: 'Return Policy',
                onTap: () {},
              ),
              _MenuTile(
                icon: Icons.info_outline,
                label: 'About DenimDiverse',
                onTap: () {},
              ),
            ]),

            const SizedBox(height: 12),

            _menuSection(context, 'APP', [
              _MenuTile(
                icon: Icons.notifications_outlined,
                label: 'Notifications',
                trailing: Switch(
                  value: true,
                  onChanged: (_) {},
                  activeColor: AppColors.black,
                ),
              ),
              _MenuTile(
                icon: Icons.dark_mode_outlined,
                label: 'Dark Mode',
                trailing: Switch(
                  value: false,
                  onChanged: (_) {},
                  activeColor: AppColors.black,
                ),
              ),
            ]),

            const SizedBox(height: 12),

            // Sign Out
            Container(
              color: AppColors.white,
              child: ListTile(
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.crimson.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.logout,
                      size: 20, color: AppColors.crimson),
                ),
                title: const Text(
                  'Sign Out',
                  style: TextStyle(
                    color: AppColors.crimson,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                onTap: () =>
                    Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false),
              ),
            ),

            const SizedBox(height: 40),

            // Footer
            const Text(
              'DenimDiverse  ·  v1.0.0',
              style: TextStyle(
                  color: AppColors.lightGrey,
                  fontSize: 11,
                  letterSpacing: 1),
            ),
            const SizedBox(height: 8),
            const Text(
              '© 2026 DenimDiverse by ShaiwiCode',
              style: TextStyle(color: AppColors.lightGrey, fontSize: 10),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _menuSection(
      BuildContext context, String title, List<_MenuTile> tiles) {
    return Container(
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 6),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 2.5,
                color: AppColors.medGrey,
              ),
            ),
          ),
          ...tiles.map((tile) {
            return Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 4),
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child:
                    Icon(tile.icon, size: 20, color: AppColors.darkGrey),
                  ),
                  title: Text(
                    tile.label,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  subtitle: tile.subtitle != null
                      ? Text(
                    tile.subtitle!,
                    style: const TextStyle(
                        color: AppColors.medGrey, fontSize: 11),
                  )
                      : null,
                  trailing: tile.trailing ??
                      (tile.onTap != null
                          ? const Icon(Icons.chevron_right,
                          color: AppColors.lightGrey)
                          : null),
                  onTap: tile.onTap,
                ),
                const Divider(height: 1, indent: 72),
              ],
            );
          }),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _statItem(String value, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.medGrey,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dividerV() {
    return Container(
      height: 40,
      width: 1,
      color: AppColors.border,
    );
  }
}

class _MenuTile {
  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  const _MenuTile({
    required this.icon,
    required this.label,
    this.subtitle,
    this.onTap,
    this.trailing,
  });
}