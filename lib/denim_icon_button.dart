import 'package:flutter/material.dart';

class DenimIconButton extends StatelessWidget {
  final String iconPath;
  final String label;
  final VoidCallback onTap;

  const DenimIconButton({
    super.key,
    required this.iconPath,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // The Textured Icon Container
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15), // Smooth rounded corners
              boxShadow: [
                // Soft shadow for 3D effect
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
                // Inner highlight for depth
                BoxShadow(
                  color: Colors.white.withOpacity(0.5),
                  blurRadius: 2,
                  offset: const Offset(-2, -2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                iconPath,
                width: 75,
                height: 75,
                fit: BoxFit.cover,
                // Error handling in case image is missing
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 75,
                    height: 75,
                    color: Colors.blueGrey[100],
                    child: const Icon(Icons.image_not_supported),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Label with Denim Typography
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
              color: Color(0xFF2E4053), // Deep Navy Blue
            ),
          ),
        ],
      ),
    );
  }
}