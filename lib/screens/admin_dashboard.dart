import 'package:denim_diverse/screens/product_data.dart';
import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart';
import 'app_theme.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.navy,
        iconTheme: const IconThemeData(color: AppColors.white),
        title: const Text('ADMIN DASHBOARD',
            style: TextStyle(color: AppColors.white)),
        bottom: TabBar(
          controller: _tab,
          indicatorColor: AppColors.gold,
          labelColor: AppColors.white,
          unselectedLabelColor: AppColors.lightGrey,
          labelStyle: const TextStyle(
              fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.5),
          tabs: const [
            Tab(text: 'OVERVIEW'),
            Tab(text: 'INVENTORY'),
            Tab(text: 'ORDERS'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _OverviewTab(),
          _InventoryTab(),
          _OrdersTab(),
        ],
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stats = [
      _StatCard('TOTAL REVENUE', 'Rs. 2,48,500', Icons.payments_outlined,
          AppColors.success, '+12% this week'),
      _StatCard('TOTAL ORDERS', '126', Icons.receipt_long_outlined,
          AppColors.blue, '+8 today'),
      _StatCard('PRODUCTS', '${ProductData.allProducts.length}',
          Icons.inventory_2_outlined, AppColors.gold, 'In stock'),
      _StatCard('CUSTOMERS', '89', Icons.people_outline, AppColors.navy,
          'Unique buyers'),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const Text('DASHBOARD OVERVIEW',
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                  color: AppColors.medGrey)),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount:
            MediaQuery.of(context).size.width > 700 ? 4 : 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: stats,
          ),
          const SizedBox(height: 28),
          const Text('RECENT ACTIVITY',
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                  color: AppColors.medGrey)),
          const SizedBox(height: 16),
          ...List.generate(
            5,
                (i) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.blue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.shopping_bag_outlined,
                        size: 18, color: AppColors.blue),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order #DD-${1000 + i} placed',
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 13),
                        ),
                        Text(
                          '${i + 1} hour${i > 0 ? 's' : ''} ago · Rs. ${(1800 + i * 300).toString()}',
                          style: const TextStyle(
                              color: AppColors.medGrey, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: const Text('CONFIRMED',
                        style: TextStyle(
                            color: AppColors.success,
                            fontSize: 9,
                            fontWeight: FontWeight.w800)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String sub;

  const _StatCard(this.label, this.value, this.icon, this.color, this.sub);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 22),
              Text(sub,
                  style: TextStyle(
                      color: color,
                      fontSize: 9,
                      fontWeight: FontWeight.w700)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: const TextStyle(
                      fontWeight: FontWeight.w900, fontSize: 20)),
              Text(label,
                  style: const TextStyle(
                      color: AppColors.medGrey,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1)),
            ],
          ),
        ],
      ),
    );
  }
}

class _InventoryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final products = ProductData.allProducts;
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: products.length,
      itemBuilder: (_, i) {
        final p = products[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: SizedBox(
                  width: 60,
                  height: 70,
                  child: Image.asset(p.image,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                      const ColoredBox(color: AppColors.surface)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 12)),
                    const SizedBox(height: 3),
                    Text('${p.category} · ${p.fit ?? ""}',
                        style: const TextStyle(
                            color: AppColors.medGrey, fontSize: 11)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text('Rs. ${p.salePrice.toStringAsFixed(0)}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 13,
                                color: AppColors.crimson)),
                        const SizedBox(width: 8),
                        Text('Rs. ${p.originalPrice.toStringAsFixed(0)}',
                            style: const TextStyle(
                                color: AppColors.lightGrey,
                                fontSize: 11,
                                decoration: TextDecoration.lineThrough)),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    color: AppColors.success.withOpacity(0.1),
                    child: const Text('IN STOCK',
                        style: TextStyle(
                            color: AppColors.success,
                            fontSize: 9,
                            fontWeight: FontWeight.w800)),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        child: const Icon(Icons.edit_outlined,
                            size: 18, color: AppColors.blue),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        child: const Icon(Icons.delete_outline,
                            size: 18, color: AppColors.crimson),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _OrdersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 8,
      itemBuilder: (_, i) {
        final statuses = ['Confirmed', 'Processing', 'Shipped', 'Delivered'];
        final status = statuses[i % statuses.length];
        final colors = {
          'Confirmed': AppColors.blue,
          'Processing': AppColors.gold,
          'Shipped': AppColors.navy,
          'Delivered': AppColors.success,
        };

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Order #DD-${1000 + i}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w900, fontSize: 13),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: colors[status]!.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Text(
                      status.toUpperCase(),
                      style: TextStyle(
                          color: colors[status]!,
                          fontSize: 9,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Customer ${i + 1}  ·  ${i + 1} item(s)  ·  Rs. ${1500 + i * 400}',
                style: const TextStyle(
                    color: AppColors.medGrey, fontSize: 12),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GhostButton(
                    label: 'VIEW DETAILS',
                    height: 34,
                    width: 130,
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}