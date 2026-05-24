import 'package:denim_diverse/screens/app_theme.dart';
import 'package:flutter/material.dart';

/// A premium icon button with image + label, used in category and feature sections.
class DenimIconButton extends StatefulWidget {
  final String iconPath;
  final String label;
  final VoidCallback onTap;
  final double size;
  final Color? labelColor;

  const DenimIconButton({
    super.key,
    required this.iconPath,
    required this.label,
    required this.onTap,
    this.size = 75,
    this.labelColor,
  });

  @override
  State<DenimIconButton> createState() => _DenimIconButtonState();
}

class _DenimIconButtonState extends State<DenimIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.93,
      upperBound: 1.0,
    )..value = 1.0;
    _scaleAnim = _ctrl;
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.reverse(),
      onTapUp: (_) {
        _ctrl.forward();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.forward(),
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon Container
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withOpacity(0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: AppColors.white.withOpacity(0.6),
                    blurRadius: 2,
                    offset: const Offset(-2, -2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  widget.iconPath,
                  width: widget.size,
                  height: widget.size,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: widget.size,
                    height: widget.size,
                    color: AppColors.surface,
                    child: const Icon(
                      Icons.dry_cleaning_outlined,
                      color: AppColors.medGrey,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Label
            Text(
              widget.label.toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
                color: widget.labelColor ?? AppColors.navyLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}