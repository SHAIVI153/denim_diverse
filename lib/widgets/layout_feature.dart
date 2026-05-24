import 'package:flutter/material.dart';
import '../screens/app_theme.dart';

/// A layout wrapper that adds a floating chat button and smooth scroll behavior.
/// Used to wrap page content with consistent padding and overlay features.
class LayoutFeature extends StatelessWidget {
  final Widget child;
  final ScrollController? controller;

  const LayoutFeature({
    super.key,
    required this.child,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main scrollable content
        CustomScrollView(
          controller: controller,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: child),
          ],
        ),

        // Floating Live Chat Button
        Positioned(
          bottom: 24,
          right: 20,
          child: _FloatingChatButton(),
        ),
      ],
    );
  }
}

class _FloatingChatButton extends StatefulWidget {
  @override
  State<_FloatingChatButton> createState() => _FloatingChatButtonState();
}

class _FloatingChatButtonState extends State<_FloatingChatButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _anim;
  late Animation<double> _scale;
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scale = CurvedAnimation(parent: _anim, curve: Curves.easeOutBack);
    // Pop in after 1.5s
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) _anim.forward();
    });
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: GestureDetector(
        onTap: () => setState(() => _expanded = !_expanded),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.black,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.25),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.chat_bubble_outline_rounded,
                color: AppColors.white,
                size: 16,
              ),
              const SizedBox(width: 8),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Text(
                  _expanded ? 'Chat Soon' : 'Live Chat',
                  key: ValueKey(_expanded),
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}