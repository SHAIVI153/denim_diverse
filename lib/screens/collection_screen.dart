import 'package:denim_diverse/screens/product_data.dart';
import 'package:flutter/material.dart';
import '../product.dart';
import '../providers/cart_provider.dart';
import '../widgets/product_card.dart';
import 'package:provider/provider.dart';

import 'app_theme.dart';

class CollectionScreen extends StatefulWidget {
  final String? initialCategory;

  const CollectionScreen({super.key, this.initialCategory});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  late String _selectedCat;
  String _sortBy = 'POPULAR';
  bool _showFilter = false;

  final _sortOptions = ['POPULAR', 'PRICE: LOW–HIGH', 'PRICE: HIGH–LOW', 'NEWEST'];

  @override
  void initState() {
    super.initState();
    _selectedCat = widget.initialCategory ?? 'ALL';
  }

  List<Product> get _products {
    List<Product> list = ProductData.allProducts;
    if (_selectedCat != 'ALL') {
      list = list.where((p) => p.category == _selectedCat).toList();
    }
    switch (_sortBy) {
      case 'PRICE: LOW–HIGH':
        list.sort((a, b) => a.salePrice.compareTo(b.salePrice));
        break;
      case 'PRICE: HIGH–LOW':
        list.sort((a, b) => b.salePrice.compareTo(a.salePrice));
        break;
      case 'NEWEST':
        list = list.where((p) => p.isNew).toList() +
            list.where((p) => !p.isNew).toList();
        break;
    }
    return list;
  }

  final _categories = [
    ('ALL', 'All'),
    ('MEN', 'Men'),
    ('WOMEN', 'Women'),
    ('KIDS', 'Kids'),
  ];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isWeb = w > 900;
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('COLLECTION'),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () => setState(() => _showFilter = !_showFilter),
          ),
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined),
                onPressed: () => Navigator.pushNamed(context, '/cart'),
              ),
              if (cart.uniqueCount > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                        color: AppColors.black, shape: BoxShape.circle),
                    child: Center(
                      child: Text('${cart.uniqueCount}',
                          style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w900)),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Category Tabs
          Container(
            color: AppColors.surface,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _categories.map((c) {
                  final selected = _selectedCat == c.$1;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedCat = c.$1),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 9),
                        decoration: BoxDecoration(
                          color: selected ? AppColors.black : AppColors.white,
                          borderRadius: BorderRadius.circular(2),
                          border: Border.all(
                            color:
                            selected ? AppColors.black : AppColors.border,
                          ),
                        ),
                        child: Text(
                          c.$2.toUpperCase(),
                          style: TextStyle(
                            color: selected
                                ? AppColors.white
                                : AppColors.darkGrey,
                            fontWeight: FontWeight.w800,
                            fontSize: 10,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Sort / Filter Bar
          if (_showFilter)
            Container(
              color: AppColors.white,
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Text('SORT BY:',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                          color: AppColors.medGrey)),
                  const SizedBox(width: 12),
                  ..._sortOptions.map((s) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _sortBy = s),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: _sortBy == s
                              ? AppColors.black
                              : AppColors.surface,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Text(
                          s,
                          style: TextStyle(
                            color: _sortBy == s
                                ? AppColors.white
                                : AppColors.darkGrey,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  )),
                ],
              ),
            ),

          // Count
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Row(
              children: [
                Text(
                  '${_products.length} PRODUCTS',
                  style: const TextStyle(
                    color: AppColors.medGrey,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),

          // Grid
          Expanded(
            child: _products.isEmpty
                ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off,
                      size: 60, color: AppColors.lightGrey),
                  SizedBox(height: 16),
                  Text('No products found',
                      style: TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 16)),
                ],
              ),
            )
                : GridView.builder(
              padding: EdgeInsets.fromLTRB(
                  isWeb ? w * 0.05 : 16, 20, isWeb ? w * 0.05 : 16, 40),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isWeb ? 4 : 2,
                childAspectRatio: isWeb ? 0.62 : 0.55,
                mainAxisSpacing: 30,
                crossAxisSpacing: 16,
              ),
              itemCount: _products.length,
              itemBuilder: (ctx, i) {
                final p = _products[i];
                return ProductCard(
                  product: p,
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/product-detail',
                    arguments: p.toMap(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}