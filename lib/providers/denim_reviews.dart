import 'dart:async';
import 'package:flutter/material.dart';
import '../screens/app_theme.dart';

/// Auto-scrolling horizontal review carousel widget.
/// Displays customer reviews with product images.
class DenimReviews extends StatefulWidget {
  const DenimReviews({super.key});

  @override
  State<DenimReviews> createState() => _DenimReviewsState();
}

class _DenimReviewsState extends State<DenimReviews> {
  late ScrollController _scroll;
  Timer? _timer;

  final List<Map<String, String>> _reviews = [
    {
      'name': 'Umer J.',
      'title': 'VINTAGE BOOT CUT',
      'date': '19/07/25',
      'review':
      'The fit is perfect and the denim quality is premium. Honestly the best jeans purchase I\'ve made in years!',
      'image': 'assets/images/bootcut.jpg',
    },
    {
      'name': 'Rida B.',
      'title': 'HIGH WAIST MOM FIT',
      'date': '01/05/25',
      'review':
      'Very comfortable for daily wear. The fabric is super soft and the fit is exactly as described. So satisfied!',
      'image': 'assets/images/momfit.jpg',
    },
    {
      'name': 'Hamza A.',
      'title': 'STREET BAGGY',
      'date': '12/08/25',
      'review':
      'Exactly what I was looking for. The baggy style is on point and the quality is unmatched at this price.',
      'image': 'assets/images/baggy.jpg',
    },
    {
      'name': 'Sara K.',
      'title': 'BOYFRIEND DENIM',
      'date': '05/09/25',
      'review':
      'Amazing quality and fast delivery. The jeans look even better in person. Highly recommended for everyone.',
      'image': 'assets/images/boyfriend.jpg',
    },
    {
      'name': 'Bilal M.',
      'title': 'STRAIGHT LEG WEAR',
      'date': '28/09/25',
      'review':
      'Clean, classic fit. Premium stitching and the colour is exactly right. Will order again for sure.',
      'image': 'assets/images/straight_wear.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    _scroll = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startScroll());
  }

  void _startScroll() {
    _timer = Timer.periodic(const Duration(milliseconds: 30), (_) {
      if (!_scroll.hasClients) return;
      final max = _scroll.position.maxScrollExtent;
      if (_scroll.offset >= max) {
        _scroll.jumpTo(0);
      } else {
        _scroll.animateTo(
          _scroll.offset + 2.0,
          duration: const Duration(milliseconds: 30),
          curve: Curves.linear,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'WHAT CUSTOMERS SAY',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 3,
                    color: AppColors.medGrey,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Real Reviews',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Container(height: 3, width: 36, color: AppColors.black),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Row(
                      children: List.generate(
                        5,
                            (_) => const Icon(Icons.star_rounded,
                            color: AppColors.gold, size: 16),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '4.9 / 5  ·  12,000+ reviews',
                      style: const TextStyle(
                          color: AppColors.medGrey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Scrolling Cards
          SizedBox(
            height: 190,
            child: ListView.builder(
              controller: _scroll,
              scrollDirection: Axis.horizontal,
              itemCount: _reviews.length * 10, // repeat
              itemBuilder: (_, i) {
                final item = _reviews[i % _reviews.length];
                return _ReviewCard(item: item);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final Map<String, String> item;

  const _ReviewCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 420,
      margin: const EdgeInsets.only(left: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.asset(
              item['image']!,
              width: 95,
              height: 155,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 95,
                color: AppColors.border,
                child:
                const Icon(Icons.image_outlined, color: AppColors.lightGrey),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Review Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item['name']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Text(
                      item['date']!,
                      style: const TextStyle(
                          color: AppColors.lightGrey, fontSize: 10),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: List.generate(
                    5,
                        (_) => const Icon(Icons.star_rounded,
                        color: AppColors.gold, size: 13),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item['title']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 10,
                    letterSpacing: 1.5,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '"${item['review']!}"',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.darkGrey,
                    height: 1.5,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}