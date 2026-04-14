import 'package:flutter/material.dart';

class PromoBannerOverlay extends StatefulWidget {
  const PromoBannerOverlay({Key? key}) : super(key: key);

  @override
  State<PromoBannerOverlay> createState() => _PromoBannerOverlayState();
}

class _PromoBannerOverlayState extends State<PromoBannerOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _opacityAnimation;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5), // Niche se start hoga
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart));

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isWeb = screenWidth > 950;

    // Is widget se pata chalta hai ke user scroll karke banner tak pohnch gaya hai
    return VisibilityDetector(
      key: const Key('promo-banner-key'),
      onVisibilityChanged: (visibilityInfo) {
        if (visibilityInfo.visibleFraction > 0.2 && !_isVisible) {
          _controller.forward();
          _isVisible = true;
        }
      },
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: SlideTransition(
          position: _offsetAnimation,
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(
              horizontal: isWeb ? screenWidth * 0.1 : 20,
              vertical: 30,
            ),
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  "SHOP BEFORE IT ENDS",
                  style: TextStyle(fontSize: 12, letterSpacing: 3, color: Colors.grey, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      "Save Minimum ",
                      style: TextStyle(fontSize: isWeb ? 32 : 22, fontWeight: FontWeight.w400, color: Colors.black),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.orange, width: 2),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        "40%",
                        style: TextStyle(fontWeight: FontWeight.w900, fontSize: isWeb ? 32 : 22, color: Colors.black),
                      ),
                    ),
                    Text(
                      " on Crazy Deal",
                      style: TextStyle(fontSize: isWeb ? 32 : 22, fontWeight: FontWeight.w400, color: Colors.black),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                InkWell(
                  onTap: () {},
                  child: const Text(
                    "SHOP THE SALE",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      letterSpacing: 1,
                      decoration: TextDecoration.underline,
                      decorationThickness: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Chota sa helper widget taaki extra package install na karna paray
class VisibilityDetector extends StatelessWidget {
  final Key key;
  final Widget child;
  final Function(VisibilityInfo) onVisibilityChanged;

  const VisibilityDetector({required this.key, required this.child, required this.onVisibilityChanged});

  @override
  Widget build(BuildContext context) {
    // Simple implementation: trigger animation immediately or use a ScrollController
    // For simplicity in this file, it will trigger when built.
    Future.delayed(Duration.zero, () => onVisibilityChanged(VisibilityInfo()));
    return child;
  }
}
class VisibilityInfo { double visibleFraction = 1.0; }