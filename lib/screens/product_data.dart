import '../product.dart';

class ProductData {
  static List<Product> get allProducts => [
    Product(
      id: 'p1',
      name: 'VINTAGE BOOT CUT',
      image: 'assets/images/bootcut.jpg',
      originalPrice: 4330.0,
      category: 'MEN',
      fit: 'Boot Cut',
      rating: 4.5,
      reviews: 12,
      isOnSale: true,
      description:
      'Classic boot cut silhouette with a slight flare at the knee. Perfect for a retro-inspired look with premium stretch denim.',
    ),
    Product(
      id: 'p2',
      name: 'HIGH WAIST MOM FIT',
      image: 'assets/images/momfit.jpg',
      originalPrice: 4665.0,
      category: 'WOMEN',
      fit: 'Mom Fit',
      rating: 4.8,
      reviews: 25,
      isNew: true,
      isOnSale: true,
      description:
      'The ultimate relaxed-fit denim with a high rise and tapered leg. Effortlessly cool with comfort stretch technology.',
    ),
    Product(
      id: 'p3',
      name: 'BOYFRIEND DENIM',
      image: 'assets/images/boyfriend.jpg',
      originalPrice: 4998.0,
      category: 'WOMEN',
      fit: 'Boyfriend',
      rating: 4.2,
      reviews: 8,
      isOnSale: true,
      description:
      'Relaxed through the hip and thigh with a slightly tapered leg. The go-to style for effortless everyday wear.',
    ),
    Product(
      id: 'p4',
      name: 'STREET BAGGY',
      image: 'assets/images/baggy.jpg',
      originalPrice: 5498.0,
      category: 'MEN',
      fit: 'Baggy',
      rating: 4.6,
      reviews: 19,
      isNew: true,
      isOnSale: true,
      description:
      'Oversized street-style denim with a relaxed fit through the seat and thigh. Built for comfort and maximum style impact.',
    ),
    Product(
      id: 'p5',
      name: 'SKINNY FIT CLASSIC',
      image: 'assets/images/skinny.jpg',
      originalPrice: 3999.0,
      category: 'WOMEN',
      fit: 'Skinny',
      rating: 4.3,
      reviews: 31,
      isOnSale: true,
      description:
      'A timeless skinny silhouette with 4-way stretch for all-day comfort. The perfect versatile denim staple.',
    ),
    Product(
      id: 'p6',
      name: 'STRAIGHT LEG WEAR',
      image: 'assets/images/straight_wear.jpg',
      originalPrice: 4100.0,
      category: 'MEN',
      fit: 'Straight',
      rating: 4.7,
      reviews: 44,
      isOnSale: true,
      description:
      'Clean, modern straight-leg cut with premium rigid denim. A foundational wardrobe piece done right.',
    ),
  ];

  static List<Product> get newArrivals => [
    Product(
      id: 'a1',
      name: 'PREMIUM HANGING DENIM',
      image: 'assets/images/premium_hanging.jpg',
      originalPrice: 1799.0,
      category: 'MEN',
      isNew: true,
      description: 'Premium quality denim with expert craftsmanship.',
    ),
    Product(
      id: 'a2',
      name: 'VINTAGE WASHED JEANS',
      image: 'assets/images/wintage_washed.jpg',
      originalPrice: 1899.0,
      category: 'WOMEN',
      isNew: true,
      description: 'Sun-faded vintage wash for authentic retro style.',
    ),
    Product(
      id: 'a3',
      name: 'DARK INDIGO SLIM',
      image: 'assets/images/indigo.jpg',
      originalPrice: 1699.0,
      category: 'MEN',
      isNew: true,
      description: 'Deep indigo dye with slim contemporary cut.',
    ),
    Product(
      id: 'a4',
      name: 'STREETWEAR BAGGY',
      image: 'assets/images/streetwear_baggy.jpg',
      originalPrice: 1999.0,
      category: 'MEN',
      isNew: true,
      description: 'Street-inspired oversized denim for bold looks.',
    ),
    Product(
      id: 'a5',
      name: 'CLASSIC STRAIGHT CUT',
      image: 'assets/images/straight_wear.jpg',
      originalPrice: 1799.0,
      category: 'MEN',
      isNew: true,
      description: 'The classic cut, perfected with premium fabric.',
    ),
    Product(
      id: 'a6',
      name: 'RETRO LIGHT BLUE',
      image: 'assets/images/retro_light.jpg',
      originalPrice: 1999.0,
      category: 'WOMEN',
      isNew: true,
      description: 'Light wash retro denim with authentic fade detail.',
    ),
  ];

  static List<Product> get crazyDeals => [
    Product(
      id: 'd1',
      name: 'CLEARANCE SKINNY',
      image: 'assets/images/skinny.jpg',
      originalPrice: 3999.0,
      discountedPrice: 1299.0,
      category: 'WOMEN',
      fit: 'Skinny',
      isOnSale: true,
      rating: 4.1,
      reviews: 7,
      description: 'Clearance sale — limited sizes available!',
      sizes: ['28', '30'],
    ),
    Product(
      id: 'd2',
      name: 'BAGGY END-OF-SEASON',
      image: 'assets/images/baggy.jpg',
      originalPrice: 5498.0,
      discountedPrice: 1899.0,
      category: 'MEN',
      fit: 'Baggy',
      isOnSale: true,
      rating: 4.4,
      reviews: 13,
      description: 'End of season mega sale. Get it before it\'s gone!',
      sizes: ['30', '32', '34'],
    ),
  ];

  static List<Map<String, String>> get categories => [
    {'id': 'ALL', 'label': 'ALL JEANS'},
    {'id': 'MEN', 'label': 'MEN'},
    {'id': 'WOMEN', 'label': 'WOMEN'},
    {'id': 'KIDS', 'label': 'KIDS'},
    {'id': 'DEALS', 'label': 'CRAZY DEALS'},
  ];

  static List<Map<String, dynamic>> get reviews => [
    {
      'name': 'Shawaiz N.',
      'rating': 5,
      'comment':
      'Best denim I\'ve ever bought. The quality is unreal, super comfortable and looks amazing.',
      'product': 'Street Baggy',
      'date': '2 days ago',
    },
    {
      'name': 'Asad Mustafa',
      'rating': 5,
      'comment':
      'DenimDiverse has changed the way I think about jeans. Premium quality at an affordable price.',
      'product': 'Vintage Boot Cut',
      'date': '1 week ago',
    },
    {
      'name': 'Fatima K.',
      'rating': 4,
      'comment':
      'Love the Mom Fit! Fits perfectly and the stretch fabric is incredibly comfortable.',
      'product': 'High Waist Mom Fit',
      'date': '3 days ago',
    },
    {
      'name': 'Bilal A.',
      'rating': 5,
      'comment':
      'Ordered the Straight Leg and it arrived in 2 days. Packaging was premium. Absolutely love it.',
      'product': 'Straight Leg Wear',
      'date': '5 days ago',
    },
  ];
}