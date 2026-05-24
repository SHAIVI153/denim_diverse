import 'package:flutter/material.dart';
import '../screens/app_theme.dart';

// ─── PRIMARY BUTTON ──────────────────────────────────────────────────────────
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final double? width;
  final double height;
  final bool isLoading;
  final Color? color;
  final Color? textColor;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.width,
    this.height = 52,
    this.isLoading = false,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppColors.black,
          foregroundColor: textColor ?? AppColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
        ),
        child: isLoading
            ? const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.white,
          ),
        )
            : Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 11,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}

// ─── GHOST BUTTON ────────────────────────────────────────────────────────────
class GhostButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final double? width;
  final double height;

  const GhostButton({
    super.key,
    required this.label,
    this.onPressed,
    this.width,
    this.height = 52,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.black,
          side: const BorderSide(color: AppColors.black, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
        ),
        child: Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 11,
            letterSpacing: 2,
            color: AppColors.black,
          ),
        ),
      ),
    );
  }
}

// ─── SECTION HEADER ──────────────────────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String label;
  final String title;
  final String? action;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.label = '',
    this.action,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 3,
              color: AppColors.medGrey,
            ),
          ),
        if (label.isNotEmpty) const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: AppColors.black,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            if (action != null)
              GestureDetector(
                onTap: onAction,
                child: Text(
                  action!,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                    decoration: TextDecoration.underline,
                    letterSpacing: 1,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        Container(height: 3, width: 40, color: AppColors.black),
      ],
    );
  }
}

// ─── STAR RATING ─────────────────────────────────────────────────────────────
class StarRating extends StatelessWidget {
  final double rating;
  final int reviews;
  final double size;

  const StarRating({
    super.key,
    required this.rating,
    this.reviews = 0,
    this.size = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (i) {
          if (i < rating.floor()) {
            return Icon(Icons.star_rounded, color: AppColors.gold, size: size);
          } else if (i < rating) {
            return Icon(Icons.star_half_rounded, color: AppColors.gold, size: size);
          }
          return Icon(Icons.star_outline_rounded, color: AppColors.lightGrey, size: size);
        }),
        if (reviews > 0) ...[
          const SizedBox(width: 5),
          Text(
            '($reviews)',
            style: TextStyle(
              fontSize: size - 2,
              color: AppColors.medGrey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ]
      ],
    );
  }
}

// ─── SCROLLING TICKER ────────────────────────────────────────────────────────
class ScrollingTicker extends StatefulWidget {
  final List<String> items;
  final Color bgColor;
  final Color textColor;
  final bool rounded;

  const ScrollingTicker({
    super.key,
    required this.items,
    this.bgColor = AppColors.navy,
    this.textColor = AppColors.white,
    this.rounded = false,
  });

  @override
  State<ScrollingTicker> createState() => _ScrollingTickerState();
}

class _ScrollingTickerState extends State<ScrollingTicker> {
  late ScrollController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scroll());
  }

  void _scroll() async {
    while (_ctrl.hasClients) {
      await Future.delayed(const Duration(milliseconds: 30));
      if (!_ctrl.hasClients) break;
      final max = _ctrl.position.maxScrollExtent;
      final cur = _ctrl.offset;
      if (cur >= max) {
        _ctrl.jumpTo(0);
      } else {
        _ctrl.animateTo(cur + 2.5,
            duration: const Duration(milliseconds: 30), curve: Curves.linear);
      }
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget ticker = Container(
      height: 44,
      color: widget.bgColor,
      child: ListView.builder(
        controller: _ctrl,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 200,
        itemBuilder: (_, i) => Row(
          children: [
            const SizedBox(width: 50),
            Text(
              widget.items[i % widget.items.length],
              style: TextStyle(
                color: widget.textColor,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(width: 50),
            Icon(Icons.fiber_manual_record, size: 5, color: AppColors.gold),
          ],
        ),
      ),
    );

    if (widget.rounded) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: ticker,
      );
    }
    return ticker;
  }
}

// ─── EMPTY STATE ─────────────────────────────────────────────────────────────
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? buttonLabel;
  final VoidCallback? onButton;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.buttonLabel,
    this.onButton,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: AppColors.lightGrey),
            const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.medGrey,
                fontSize: 13,
                height: 1.6,
              ),
            ),
            if (buttonLabel != null) ...[
              const SizedBox(height: 32),
              PrimaryButton(
                label: buttonLabel!,
                onPressed: onButton,
                width: 200,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── DISCOUNT BADGE ──────────────────────────────────────────────────────────
class DiscountBadge extends StatelessWidget {
  final String label;
  final Color? color;

  const DiscountBadge({
    super.key,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: color ?? AppColors.black,
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.white,
          fontSize: 8,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}