
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_theme.dart';


class DenimFooter extends StatelessWidget {
  final bool isWeb;
  const DenimFooter({super.key, required this.isWeb});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.black,
      padding: EdgeInsets.symmetric(horizontal: isWeb ? 80 : 28, vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isWeb) _webLayout() else _mobileLayout(),
          const SizedBox(height: 50),
          const Divider(color: Color(0xFF2A2A2A)),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('© 2026 DENIM DIVERSE. ALL RIGHTS RESERVED.',
                  style: TextStyle(color: Color(0xFF555555), fontSize: 9, letterSpacing: 1)),
              const Text('BY SHAIWICODE', style: TextStyle(color: Color(0xFF555555), fontSize: 9, letterSpacing: 1)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _webLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: _brand()),
        const SizedBox(width: 60),
        Expanded(child: _column('SHOP', ['New Arrivals', 'Men', 'Women', 'Kids', 'Crazy Deals', 'Bundle Offers'])),
        Expanded(child: _column('HELP', ['Track Order', 'Returns & Exchanges', 'Size Guide', 'Contact Us', 'FAQ'])),
        Expanded(child: _column('COMPANY', ['About Us', 'Careers', 'Press', 'Stores', 'Sustainability'])),
        Expanded(child: _newsletter()),
      ],
    );
  }

  Widget _mobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _brand(),
        const SizedBox(height: 40),
        _column('SHOP', ['New Arrivals', 'Men', 'Women', 'Kids']),
        const SizedBox(height: 30),
        _column('HELP', ['Track Order', 'Returns', 'Size Guide', 'Contact']),
        const SizedBox(height: 30),
        _newsletter(),
      ],
    );
  }

  Widget _brand() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('DenimDiverse.',
            style: GoogleFonts.montserrat(fontSize: 26, fontWeight: FontWeight.w900, color: AppColors.white, letterSpacing: -0.5)),
        const SizedBox(height: 12),
        const Text('BEYOND THE STANDARD BLUE',
            style: TextStyle(color: Color(0xFF666666), fontSize: 9, letterSpacing: 2, fontWeight: FontWeight.w700)),
        const SizedBox(height: 24),
        Row(
          children: [
            _socialBtn(Icons.play_circle_fill, Colors.red),
            const SizedBox(width: 16),
            _socialBtn(Icons.camera_alt_outlined, Colors.pinkAccent),
            const SizedBox(width: 16),
            _socialBtn(Icons.facebook, const Color(0xFF1877F2)),
          ],
        ),
      ],
    );
  }

  Widget _socialBtn(IconData icon, Color color) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(4)),
      child: Icon(icon, color: color, size: 18),
    );
  }

  Widget _column(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: AppColors.white, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
        const SizedBox(height: 20),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(item, style: const TextStyle(color: Color(0xFF888888), fontSize: 12)),
        )),
      ],
    );
  }

  Widget _newsletter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('STAY IN THE LOOP',
            style: TextStyle(color: AppColors.white, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
        const SizedBox(height: 12),
        const Text('Get exclusive deals, new arrivals & style inspo.',
            style: TextStyle(color: Color(0xFF888888), fontSize: 12)),
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(border: Border.all(color: const Color(0xFF333333))),
          child: Row(
            children: [
              const Expanded(
                child: TextField(
                  style: TextStyle(color: AppColors.white, fontSize: 12),
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    hintStyle: TextStyle(color: Color(0xFF555555), fontSize: 12),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                color: AppColors.white,
                child: const Text('JOIN', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 10, letterSpacing: 1)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


