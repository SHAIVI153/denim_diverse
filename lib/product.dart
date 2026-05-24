class Product {
  final String id;
  final String name;
  final String image;
  final double originalPrice;
  final double? discountedPrice;
  final String category;
  final String? fit;
  final double rating;
  final int reviews;
  final bool isNew;
  final bool isOnSale;
  final List<String> sizes;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.originalPrice,
    this.discountedPrice,
    required this.category,
    this.fit,
    this.rating = 4.5,
    this.reviews = 0,
    this.isNew = false,
    this.isOnSale = false,
    this.sizes = const ['28', '30', '32', '34', '36', '38'],
    this.description = '',
  });

  double get salePrice => discountedPrice ?? originalPrice * 0.6;
  double get discountPercent =>
      ((originalPrice - salePrice) / originalPrice * 100).roundToDouble();

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'image': image,
    'price': salePrice,
    'originalPrice': originalPrice,
    'category': category,
    'rating': rating,
    'reviews': reviews,
    'description': description,
    'sizes': sizes,
  };
}