import 'package:denim_diverse/screens/product_data.dart';
import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart';
import 'app_theme.dart';

class AdminInventoryScreen extends StatefulWidget {
  const AdminInventoryScreen({super.key});

  @override
  State<AdminInventoryScreen> createState() => _AdminInventoryScreenState();
}

class _AdminInventoryScreenState extends State<AdminInventoryScreen> {
  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String _selectedCategory = 'MEN';
  String _searchQuery = '';

  late List<Map<String, dynamic>> _products;

  @override
  void initState() {
    super.initState();
    _products = ProductData.allProducts
        .map((p) => {
      'id': p.id,
      'name': p.name,
      'price': p.originalPrice.toStringAsFixed(0),
      'salePrice': p.salePrice.toStringAsFixed(0),
      'category': p.category,
      'image': p.image,
      'inStock': true,
    })
        .toList();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filtered {
    if (_searchQuery.isEmpty) return _products;
    return _products
        .where((p) =>
    (p['name'] as String)
        .toLowerCase()
        .contains(_searchQuery.toLowerCase()) ||
        (p['category'] as String)
            .toLowerCase()
            .contains(_searchQuery.toLowerCase()))
        .toList();
  }

  void _addProduct() {
    if (_nameCtrl.text.isEmpty || _priceCtrl.text.isEmpty) return;
    setState(() {
      _products.insert(0, {
        'id': 'new_${DateTime.now().millisecondsSinceEpoch}',
        'name': _nameCtrl.text.toUpperCase(),
        'price': _priceCtrl.text,
        'salePrice':
        (double.tryParse(_priceCtrl.text) ?? 0 * 0.6).toStringAsFixed(0),
        'category': _selectedCategory,
        'image': '',
        'inStock': true,
      });
    });
    _nameCtrl.clear();
    _priceCtrl.clear();
    _descCtrl.clear();
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Product added successfully')),
    );
  }

  void _deleteProduct(String id) {
    setState(() => _products.removeWhere((p) => p['id'] == id));
  }

  void _toggleStock(String id) {
    setState(() {
      final idx = _products.indexWhere((p) => p['id'] == id);
      if (idx != -1) {
        _products[idx]['inStock'] = !(_products[idx]['inStock'] as bool);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final inStock = _products.where((p) => p['inStock'] == true).length;
    final outOfStock = _products.length - inStock;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('INVENTORY MANAGER'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_outlined),
            onPressed: () {},
            tooltip: 'Export',
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.black,
        foregroundColor: AppColors.white,
        onPressed: () => _showAddSheet(context),
        icon: const Icon(Icons.add),
        label: const Text(
          'ADD PRODUCT',
          style: TextStyle(
              fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 1.5),
        ),
      ),
      body: Column(
        children: [
          // Stats Bar
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _StatTile(
                  label: 'TOTAL PRODUCTS',
                  value: '${_products.length}',
                  icon: Icons.inventory_2_outlined,
                  color: AppColors.navy,
                ),
                const SizedBox(width: 12),
                _StatTile(
                  label: 'IN STOCK',
                  value: '$inStock',
                  icon: Icons.check_circle_outline,
                  color: AppColors.success,
                ),
                const SizedBox(width: 12),
                _StatTile(
                  label: 'OUT OF STOCK',
                  value: '$outOfStock',
                  icon: Icons.warning_amber_outlined,
                  color: AppColors.crimson,
                ),
              ],
            ),
          ),

          // Search Bar
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: const InputDecoration(
                hintText: 'Search products...',
                prefixIcon:
                Icon(Icons.search, size: 20, color: AppColors.medGrey),
                isDense: true,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Product List
          Expanded(
            child: _filtered.isEmpty
                ? const EmptyState(
              icon: Icons.inventory_2_outlined,
              title: 'No products found',
              subtitle: 'Try a different search or add a new product.',
            )
                : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
              itemCount: _filtered.length,
              itemBuilder: (_, i) {
                final p = _filtered[i];
                return _ProductRow(
                  product: p,
                  onDelete: () => _deleteProduct(p['id'] as String),
                  onToggleStock: () =>
                      _toggleStock(p['id'] as String),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setBS) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            top: 28,
            left: 24,
            right: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ADD NEW PRODUCT',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Product Name'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _priceCtrl,
                keyboardType: TextInputType.number,
                decoration:
                const InputDecoration(labelText: 'Price (Rs.)'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _descCtrl,
                maxLines: 2,
                decoration:
                const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 20),
              const Text(
                'CATEGORY',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: ['MEN', 'WOMEN', 'KIDS'].map((cat) {
                  final sel = _selectedCategory == cat;
                  return GestureDetector(
                    onTap: () =>
                        setBS(() => _selectedCategory = cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 9),
                      decoration: BoxDecoration(
                        color: sel ? AppColors.black : AppColors.surface,
                        borderRadius: BorderRadius.circular(2),
                        border: Border.all(
                            color: sel
                                ? AppColors.black
                                : AppColors.border),
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          color: sel
                              ? AppColors.white
                              : AppColors.darkGrey,
                          fontWeight: FontWeight.w800,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 28),
              PrimaryButton(label: 'SAVE PRODUCT', onPressed: _addProduct),
              const SizedBox(height: 8),
              GhostButton(
                label: 'CANCEL',
                onPressed: () => Navigator.pop(ctx),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Sub Widgets ─────────────────────────────────────────────────────────────

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.07),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 20,
                color: color,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.medGrey,
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductRow extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback onDelete;
  final VoidCallback onToggleStock;

  const _ProductRow({
    required this.product,
    required this.onDelete,
    required this.onToggleStock,
  });

  @override
  Widget build(BuildContext context) {
    final inStock = product['inStock'] as bool;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Container(
              width: 54,
              height: 64,
              color: AppColors.surface,
              child: (product['image'] as String).isNotEmpty
                  ? Image.asset(product['image'] as String,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.dry_cleaning_outlined,
                    color: AppColors.lightGrey,
                  ))
                  : const Icon(Icons.dry_cleaning_outlined,
                  color: AppColors.lightGrey),
            ),
          ),
          const SizedBox(width: 14),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${product['category']}  ·  Rs. ${product['salePrice']} (Sale)',
                  style: const TextStyle(
                    color: AppColors.medGrey,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          // Stock toggle
          GestureDetector(
            onTap: onToggleStock,
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: (inStock ? AppColors.success : AppColors.crimson)
                    .withOpacity(0.1),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Text(
                inStock ? 'IN STOCK' : 'OUT',
                style: TextStyle(
                  color: inStock ? AppColors.success : AppColors.crimson,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Actions
          IconButton(
            icon: const Icon(Icons.edit_outlined,
                size: 18, color: AppColors.blue),
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 6),
          IconButton(
            icon: const Icon(Icons.delete_outline,
                size: 18, color: AppColors.crimson),
            onPressed: () => _confirmDelete(context),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        title: const Text('Delete Product',
            style: TextStyle(fontWeight: FontWeight.w900)),
        content: Text(
            'Remove "${product['name']}" from inventory?\nThis cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL',
                style: TextStyle(color: AppColors.medGrey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete();
            },
            child: const Text('DELETE',
                style: TextStyle(color: AppColors.crimson)),
          ),
        ],
      ),
    );
  }
}