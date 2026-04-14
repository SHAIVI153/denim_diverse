import 'package:flutter/material.dart';

class AdminInventoryScreen extends StatefulWidget {
  const AdminInventoryScreen({super.key});

  @override
  State<AdminInventoryScreen> createState() => _AdminInventoryScreenState();
}

class _AdminInventoryScreenState extends State<AdminInventoryScreen> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();
  String selectedCategory = 'MEN';

  // Temporary list to show how it works before Firebase
  List<Map<String, dynamic>> tempProducts = [
    {'name': 'BOOT CUT', 'price': '4500', 'category': 'MEN'},
    {'name': 'MOM FIT', 'price': '4200', 'category': 'WOMEN'},
  ];

  void _addNewProduct() {
    if (_nameController.text.isEmpty || _priceController.text.isEmpty) return;

    setState(() {
      tempProducts.add({
        'name': _nameController.text.toUpperCase(),
        'price': _priceController.text,
        'category': selectedCategory,
      });
    });

    _nameController.clear();
    _priceController.clear();
    _descController.clear();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("MANAGE INVENTORY", style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildStatBar(),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: tempProducts.length,
                itemBuilder: (ctx, i) => ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  tileColor: const Color(0xFFF9F9F9),
                  title: Text(tempProducts[i]['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: Text("Rs. ${tempProducts[i]['price']} | ${tempProducts[i]['category']}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                    onPressed: () => setState(() => tempProducts.removeAt(i)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _showAddProductSheet(context),
      ),
    );
  }

  Widget _buildStatBar() {
    return Row(
      children: [
        _statTile("TOTAL ITEMS", tempProducts.length.toString()),
        const SizedBox(width: 15),
        _statTile("OUT OF STOCK", "0"),
      ],
    );
  }

  Widget _statTile(String label, String val) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 9, letterSpacing: 1)),
            Text(val, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  void _showAddProductSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, top: 20, left: 20, right: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("ADD NEW JEAN", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 20),
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: "PRODUCT NAME")),
            TextField(controller: _priceController, decoration: const InputDecoration(labelText: "PRICE (RS)")),
            const SizedBox(height: 20),
            const Text("CATEGORY", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
            Row(
              children: [
                _catChip("MEN"),
                _catChip("WOMEN"),
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                onPressed: _addNewProduct,
                child: const Text("SAVE PRODUCT", style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _catChip(String cat) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: ChoiceChip(
        label: Text(cat),
        selected: selectedCategory == cat,
        onSelected: (val) => setState(() => selectedCategory = cat),
      ),
    );
  }
}