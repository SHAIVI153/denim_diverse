class Product {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.category,
  });
}

// Dummy Data for Frontend Testing
List<Product> dummyProducts = [
  Product(id: '1', name: 'Relaxed Fit Jeans', description: 'Classic relaxed denim', imageUrl: 'assets/images/relaxed.jpg', price: 4500, category: 'RELAXED'),
  Product(id: '2', name: 'Regular Fit Denim', description: 'Everyday comfort', imageUrl: 'assets/images/regular.jpg', price: 3800, category: 'REGULAR'),
  Product(id: '3', name: 'Denim Joggers', description: 'Sporty denim style', imageUrl: 'assets/images/joggers.jpg', price: 3200, category: 'JOGGERS'),
];