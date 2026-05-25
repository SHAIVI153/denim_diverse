import 'package:flutter/material.dart';

import '../screens/app_theme.dart';

/// An animated promotional banner that slides in when scrolled into view.
/// Shows the current sale discount offer.
class DenimDealBanner extends StatefulWidget {
  final String discount;
  final String headline;
  final String subline;
  final VoidCallback? onShopNow;

  const DenimDealBanner({
    super.key,
    this.discount = '40%',
    this.headline = 'Save Minimum',
    this.subline = 'on Crazy Deals — Limited Time Only',
    this.onShopNow,
  });

  @override
  State<DenimDealBanner> createState() => _DenimDealBannerState();
}

class _DenimDealBannerState extends State<DenimDealBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<Offset> _slide;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutQuart));
    _fade = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeIn));

    // Auto-trigger
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) _ctrl.forward();
      });
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isWeb = w > 900;

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(
            horizontal: isWeb ? w * 0.08 : 20,
            vertical: 40,
          ),
          padding: EdgeInsets.symmetric(
            vertical: isWeb ? 50 : 36,
            horizontal: isWeb ? 60 : 28,
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.05),
                blurRadius: 30,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            children: [
              // Label
              const Text(
                'SHOP BEFORE IT ENDS',
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 3,
                  color: AppColors.medGrey,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),

              // Main Headline
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10,
                runSpacing: 8,
                children: [
                  Text(
                    widget.headline,
                    style: TextStyle(
                      fontSize: isWeb ? 32 : 22,
                      fontWeight: FontWeight.w400,
                      color: AppColors.black,
                    ),
                  ),
                  // Discount Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.gold, width: 2),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      widget.discount,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: isWeb ? 32 : 22,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  Text(
                    widget.subline,
                    style: TextStyle(
                      fontSize: isWeb ? 32 : 22,
                      fontWeight: FontWeight.w400,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // CTA
              GestureDetector(
                onTap: widget.onShopNow,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'SHOP THE SALE',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                        letterSpacing: 2,
                        color: AppColors.black,
                        decoration: TextDecoration.underline,
                        decorationThickness: 2,
                        decorationColor: AppColors.gold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward,
                        size: 16, color: AppColors.black),
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