import 'package:flutter/material.dart';
import '../screens/app_theme.dart';
import '../screens/collection_screen.dart';
import '../screens/crazy_deals_screen.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isWeb = w > 900;

    return Container(
      color: AppColors.charcoal,
      padding: EdgeInsets.symmetric(
        vertical: 60,
        horizontal: isWeb ? w * 0.08 : 28,
      ),
      child: Column(
        children: [
          isWeb
              ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: _brandSection(context)),
              Expanded(
                  flex: 2,
                  child: _linkColumn('SHOP', [
                    ('Men\'s Collection', () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const CollectionScreen(
                                initialCategory: 'MEN')))),
                    ('Women\'s Collection', () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const CollectionScreen(
                                initialCategory: 'WOMEN')))),
                    ('Kids', () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const CollectionScreen(
                                initialCategory: 'KIDS')))),
                    ('New Arrivals', () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const CollectionScreen()))),
                    ('Crazy Deals 🔥', () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const CrazyDealsScreen()))),
                  ])),
              Expanded(
                  flex: 2,
                  child: _linkColumn('HELP', [
                    ('Track My Order', () {}),
                    ('Returns & Exchanges', () {}),
                    ('Size Guide', () {}),
                    ('Contact Us', () {}),
                    ('FAQ', () {}),
                  ])),
              Expanded(
                  flex: 2,
                  child: _linkColumn('COMPANY', [
                    ('About Us', () {}),
                    ('Sustainability', () {}),
                    ('Press', () {}),
                    ('Careers', () {}),
                    ('Blog', () {}),
                  ])),
            ],
          )
              : Column(
            children: [
              _brandSection(context),
              const SizedBox(height: 36),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: _linkColumn('SHOP', [
                        ('Men', () {}),
                        ('Women', () {}),
                        ('Kids', () {}),
                        ('Deals', () {}),
                      ])),
                  Expanded(
                      child: _linkColumn('HELP', [
                        ('Track Order', () {}),
                        ('Returns', () {}),
                        ('Size Guide', () {}),
                        ('Contact', () {}),
                      ])),
                ],
              ),
            ],
          ),

          const SizedBox(height: 48),

          // Payment methods
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: ['VISA', 'MASTERCARD', 'EASYPAISA', 'JAZZCASH', 'COD']
                .map((m) => Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF2A2A2A)),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                m,
                style: const TextStyle(
                  color: AppColors.medGrey,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ))
                .toList(),
          ),

          const SizedBox(height: 36),
          const Divider(color: Color(0xFF222222)),
          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                '© 2026 DENIM DIVERSE  ·  ALL RIGHTS RESERVED  ·  BY SHAIWICODE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF3A3A3A),
                  fontSize: 9,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _brandSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'DenimDiverse.',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'BEYOND THE STANDARD BLUE',
          style: TextStyle(
            color: AppColors.gold,
            fontSize: 9,
            letterSpacing: 2.5,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Premium denim crafted for\nthe ones who dare to stand apart.',
          style: TextStyle(
            color: AppColors.medGrey,
            fontSize: 12,
            height: 1.7,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            _socialBtn(Icons.play_circle_outline, Colors.red),
            const SizedBox(width: 12),
            _socialBtn(Icons.camera_alt_outlined, Colors.pinkAccent),
            const SizedBox(width: 12),
            _socialBtn(Icons.facebook_outlined, Colors.blueAccent),
            const SizedBox(width: 12),
            _socialBtn(Icons.tiktok, AppColors.white),
          ],
        ),
      ],
    );
  }

  Widget _socialBtn(IconData icon, Color color) => Container(
    width: 38,
    height: 38,
    decoration: BoxDecoration(
      color: const Color(0xFF1F1F1F),
      borderRadius: BorderRadius.circular(50),
    ),
    child: Icon(icon, color: color, size: 18),
  );

  Widget _linkColumn(
      String title, List<(String, VoidCallback)> links) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 16),
        ...links.map(
              (l) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: l.$2,
              child: Text(
                l.$1,
                style: const TextStyle(
                  color: AppColors.medGrey,
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}