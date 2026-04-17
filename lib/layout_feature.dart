import 'package:flutter/material.dart';
import 'denim_footer.dart';

class LayoutFeature extends StatelessWidget {
  final Widget child;
  final ScrollController? controller;

  const LayoutFeature({super.key, required this.child, this.controller});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool isWeb = width > 950;

    return Stack(
      children: [
        const Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: DenimFooter(),
        ),
        CustomScrollView(
          controller: controller,
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 25, offset: Offset(0, 10))
                  ],
                ),
                child: child,
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: isWeb ? 450 : 650),
            ),
          ],
        ),
        // Floating Chat Button (Left Side)
        Positioned(
          bottom: 20,
          left: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.chat_bubble_outline, color: Colors.white, size: 16),
                SizedBox(width: 8),
                Text("Chat", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}