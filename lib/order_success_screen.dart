import 'package:denim_diverse/screens/app_theme.dart';
import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart';

class OrderSuccessScreen extends StatelessWidget {
  final String orderId;
  final double amount;

  const OrderSuccessScreen({
    super.key,
    required this.orderId,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success Icon
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 600),
                curve: Curves.elasticOut,
                builder: (_, v, child) => Transform.scale(
                  scale: v,
                  child: child,
                ),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: AppColors.success.withOpacity(0.3), width: 2),
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 52,
                    color: AppColors.success,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              const Text(
                'ORDER PLACED!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                'Thank you for your purchase.\nYour denim is on its way!',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.medGrey,
                  fontSize: 14,
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 36),

              // Order Details Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    _detailRow('Order ID', orderId),
                    const SizedBox(height: 12),
                    _detailRow(
                        'Amount', 'Rs. ${amount.toStringAsFixed(0)}'),
                    const SizedBox(height: 12),
                    _detailRow('Status', 'Confirmed ✓',
                        valueColor: AppColors.success),
                    const SizedBox(height: 12),
                    _detailRow('Delivery', '3–5 Business Days'),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              PrimaryButton(
                label: 'CONTINUE SHOPPING',
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context, '/', (r) => false),
              ),

              const SizedBox(height: 12),

              GhostButton(
                label: 'VIEW MY ORDERS',
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context, '/orders', (r) => false),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value, {Color? valueColor}) {
    return Row(
      children: [
        Text(label,
            style:
            const TextStyle(color: AppColors.medGrey, fontSize: 13)),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 13,
            color: valueColor ?? AppColors.black,
          ),
        ),
      ],
    );
  }
}