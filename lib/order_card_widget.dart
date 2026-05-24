import 'package:denim_diverse/screens/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/order_provider.dart';

/// A reusable card widget for displaying a single order summary.
/// Used in OrderHistoryScreen.
class OrderCardWidget extends StatelessWidget {
  final OrderItem order;
  final bool isExpanded;
  final VoidCallback? onToggle;

  const OrderCardWidget({
    super.key,
    required this.order,
    this.isExpanded = false,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('dd MMM yyyy').format(order.dateTime);
    final time = DateFormat('hh:mm a').format(order.dateTime);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          // ── Header ──────────────────────────────────
          InkWell(
            onTap: onToggle,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Order Icon
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: AppColors.navy.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.receipt_long_outlined,
                          size: 20,
                          color: AppColors.navy,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order.id,
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 12,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '$date · $time',
                              style: const TextStyle(
                                color: AppColors.medGrey,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Status Badge
                      _StatusBadge(status: order.status),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _InfoChip('${order.products.length} ITEM${order.products.length > 1 ? 'S' : ''}'),
                      const SizedBox(width: 8),
                      _InfoChip(order.paymentMethod),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Rs. ${order.amount.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                          const Text(
                            'Total Paid',
                            style: TextStyle(
                                color: AppColors.medGrey, fontSize: 10),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        color: AppColors.lightGrey,
                        size: 22,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── Expanded Details ─────────────────────────
          if (isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Products list
                  const Text(
                    'ITEMS ORDERED',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                      color: AppColors.medGrey,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...order.products.map(
                        (p) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Container(
                              width: 52,
                              height: 62,
                              color: AppColors.surface,
                              child: Image.asset(
                                p.image,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const SizedBox(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 11,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  'Size: ${p.size}  ·  Qty: ${p.quantity}',
                                  style: const TextStyle(
                                    color: AppColors.medGrey,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'Rs. ${(p.price * p.quantity).toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Divider(height: 24),

                  // Delivery Info
                  const Text(
                    'DELIVERY DETAILS',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                      color: AppColors.medGrey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _DetailRow(label: 'Name', value: order.name),
                  const SizedBox(height: 6),
                  _DetailRow(
                    label: 'Address',
                    value: '${order.address}, ${order.city}',
                  ),
                  const SizedBox(height: 6),
                  _DetailRow(label: 'Phone', value: order.phone),
                  const SizedBox(height: 6),
                  _DetailRow(label: 'Payment', value: order.paymentMethod),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Sub-widgets ────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  Color get _color {
    switch (status) {
      case 'Delivered':
        return AppColors.success;
      case 'Shipped':
        return AppColors.navy;
      case 'Processing':
        return AppColors.gold;
      default:
        return AppColors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: _color.withOpacity(0.3)),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: _color,
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;

  const _InfoChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      color: AppColors.surface,
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 1,
          color: AppColors.darkGrey,
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 72,
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.medGrey,
              fontSize: 12,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}