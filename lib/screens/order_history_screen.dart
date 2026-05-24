import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';
import '../widgets/common_widgets.dart';
import 'app_theme.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrderProvider>().orders;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(title: const Text('MY ORDERS')),
      body: orders.isEmpty
          ? EmptyState(
        icon: Icons.receipt_long_outlined,
        title: 'No orders yet',
        subtitle: 'Your order history will\nappear here once you shop.',
        buttonLabel: 'Start Shopping',
        onButton: () =>
            Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: orders.length,
        itemBuilder: (_, i) => _OrderCard(order: orders[i]),
      ),
    );
  }
}

class _OrderCard extends StatefulWidget {
  final OrderItem order;

  const _OrderCard({required this.order});

  @override
  State<_OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<_OrderCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final o = widget.order;
    final date = DateFormat('dd MMM yyyy · hh:mm a').format(o.dateTime);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              o.id,
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 12,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(date,
                                style: const TextStyle(
                                    color: AppColors.medGrey, fontSize: 11)),
                          ],
                        ),
                      ),
                      _statusChip(o.status),
                      const SizedBox(width: 12),
                      Icon(
                        _expanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: AppColors.medGrey,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _infoChip(
                          '${o.products.length} ITEM${o.products.length > 1 ? 'S' : ''}'),
                      const SizedBox(width: 8),
                      _infoChip(o.paymentMethod),
                      const Spacer(),
                      Text(
                        'Rs. ${o.amount.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Expanded Details
          if (_expanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Products
                  ...o.products.map((p) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Container(
                            width: 56,
                            height: 68,
                            color: AppColors.surface,
                            child: Image.asset(p.image,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                const SizedBox()),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(p.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 11)),
                              const SizedBox(height: 4),
                              Text('Size: ${p.size} · Qty: ${p.quantity}',
                                  style: const TextStyle(
                                      color: AppColors.medGrey,
                                      fontSize: 11)),
                            ],
                          ),
                        ),
                        Text(
                          'Rs. ${(p.price * p.quantity).toStringAsFixed(0)}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 13),
                        ),
                      ],
                    ),
                  )),

                  const Divider(),
                  const SizedBox(height: 14),

                  // Shipping Info
                  const Text('SHIPPED TO',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2,
                          color: AppColors.medGrey)),
                  const SizedBox(height: 8),
                  Text(o.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 13)),
                  Text('${o.address}, ${o.city}',
                      style: const TextStyle(
                          color: AppColors.darkGrey, fontSize: 12)),
                  Text(o.phone,
                      style: const TextStyle(
                          color: AppColors.darkGrey, fontSize: 12)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _statusChip(String status) {
    Color color;
    switch (status) {
      case 'Delivered':
        color = AppColors.success;
        break;
      case 'Processing':
        color = AppColors.gold;
        break;
      default:
        color = AppColors.blue;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _infoChip(String label) {
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