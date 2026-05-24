import 'package:flutter/material.dart';
import '../screens/app_theme.dart';

/// Full-width category showcase section with large image cards.
/// Used on the HomeScreen to feature Men, Women, Kids categories.
class DenimCategoryShowcase extends StatelessWidget {
  final Function(String)? onCategoryTap;

  const DenimCategoryShowcase({super.key, this.onCategoryTap});

  static const _categories = [
    {
      'tagline': 'MODERN INDIGO ELITE',
      'title': 'Men',
      'subtitle': 'Sophisticated Denim for Him',
      'image': 'assets/images/cat_men.jpg',
      'id': 'MEN',
    },
    {
      'tagline': 'DAILY DENIM EASE',
      'title': 'Women',
      'subtitle': 'Effortless Denim for Her',
      'image': 'assets/images/cat_women.jpg',
      'id': 'WOMEN',
    },
    {
      'tagline': 'DENIM FREEDOM RUN',
      'title': 'Kids',
      'subtitle': 'Playful Denim for Little Ones',
      'image': 'assets/images/cat_kids.jpg',
      'id': 'KIDS',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isWeb = w > 900;

    return Container(
      color: AppColors.white,
      padding: EdgeInsets.symmetric(
        horizontal: isWeb ? w * 0.08 : 20,
        vertical: 64,
      ),
      child: Column(
        children: [
          // Section headers
          const Text(
            'FIND THE PERFECT DENIM IN ONE PLACE',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.medGrey,
              letterSpacing: 2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'SHOP BY CATEGORY',
            style: TextStyle(
              fontSize: isWeb ? 30 : 22,
              fontWeight: FontWeight.w900,
              color: AppColors.black,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Center(
            child: Container(height: 3, width: 36, color: AppColors.black),
          ),
          const SizedBox(height: 48),

          // Cards
          isWeb
              ? Row(
            children: _categories.asMap().entries.map((e) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      right: e.key < _categories.length - 1 ? 16 : 0),
                  child: _CategoryCard(
                    data: e.value,
                    onTap: () =>
                        onCategoryTap?.call(e.value['id'] as String),
                  ),
                ),
              );
            }).toList(),
          )
              : Column(
            children: _categories.map((data) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _CategoryCard(
                  data: data,
                  onTap: () =>
                      onCategoryTap?.call(data['id'] as String),
                  height: 300,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatefulWidget {
  final Map<String, String> data;
  final VoidCallback? onTap;
  final double? height;

  const _CategoryCard({required this.data, this.onTap, this.height});

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 900;
    final cardHeight = widget.height ?? (isWeb ? 520 : 300);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: _hovered ? cardHeight + 10 : cardHeight,
          width: double.infinity,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: AppColors.navyLight,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background Image
              AnimatedScale(
                scale: _hovered ? 1.04 : 1.0,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOut,
                child: Image.asset(
                  widget.data['image']!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppColors.navyLight,
                    child: const Center(
                      child: Icon(
                        Icons.dry_cleaning_outlined,
                        color: AppColors.lightGrey,
                        size: 48,
                      ),
                    ),
                  ),
                ),
              ),

              // Gradient overlay
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppColors.black.withOpacity(0.72),
                      ],
                      stops: const [0.4, 1.0],
                    ),
                  ),
                ),
              ),

              // Text content
              Positioned(
                left: 24,
                bottom: 28,
                right: 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.data['tagline']!.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: AppColors.gold,
                        letterSpacing: 2.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.data['title']!,
                      style: TextStyle(
                        fontSize: isWeb ? 36 : 28,
                        fontWeight: FontWeight.w900,
                        color: AppColors.white,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.data['subtitle']!,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppColors.lightGrey,
                      ),
                    ),
                    const SizedBox(height: 14),
                    AnimatedOpacity(
                      opacity: _hovered ? 1.0 : 0.7,
                      duration: const Duration(milliseconds: 200),
                      child: Row(
                        children: const [
                          Text(
                            'SHOP NOW',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.white,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 2,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward,
                              size: 14, color: AppColors.white),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}