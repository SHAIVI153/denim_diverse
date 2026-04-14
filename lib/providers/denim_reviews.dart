import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DenimReviews extends StatefulWidget {
  const DenimReviews({super.key});

  @override
  State<DenimReviews> createState() => _DenimReviewsState();
}

class _DenimReviewsState extends State<DenimReviews> {
  late ScrollController _scrollController;
  Timer? _timer;

  // Wahi products jo HomeScreen mein hain, reviews ke sath map kiye gaye hain
  final List<Map<String, String>> reviews = [
    {
      'name': 'Umer J.',
      'title': 'VINTAGE BOOT CUT',
      'date': '19/07/25',
      'review': 'The fit is perfect and the denim quality is premium. Best purchase!',
      'image': 'assets/images/bootcut.jpg',
    },
    {
      'name': 'Rida B.',
      'title': 'HIGH WAIST MOM FIT',
      'date': '01/05/25',
      'review': 'Very comfortable for daily wear. Stuff is super soft. Satisfied!',
      'image': 'assets/images/momfit.jpg',
    },
    {
      'name': 'Hamza A.',
      'title': 'STREET BAGGY',
      'date': '12/08/25',
      'review': 'Exactly what I was looking for. The baggy style is on point.',
      'image': 'assets/images/baggy.jpg',
    },
    {
      'name': 'Sara K.',
      'title': 'BOYFRIEND DENIM',
      'date': '05/09/25',
      'review': 'Amazing quality and fast delivery. Highly recommended for everyone.',
      'image': 'assets/images/boyfriend.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startAutoScroll());
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (_scrollController.hasClients) {
        if (_scrollController.offset >= _scrollController.position.maxScrollExtent) {
          _scrollController.jumpTo(0);
        } else {
          _scrollController.animateTo(
            _scrollController.offset + 2.5,
            duration: const Duration(milliseconds: 30),
            curve: Curves.linear,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "WHAT OUR CUSTOMERS SAY",
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  letterSpacing: 2,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Row(children: List.generate(5, (i) => const Icon(Icons.star, color: Color(0xFFFFB800), size: 16))),
                  const SizedBox(width: 10),
                  Text("4.9/5 Based on 12,000+ reviews", style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 180, // Responsive height for review cards
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final item = reviews[index];
              return _buildReviewCard(item);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildReviewCard(Map<String, String> item) {
    return Container(
      width: 450,
      margin: const EdgeInsets.only(left: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // 1. Product Image (Same as HomeScreen)
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: Image.asset(
              item['image']!,
              width: 100,
              height: 140,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 100, color: Colors.grey.shade300, child: const Icon(Icons.image),
              ),
            ),
          ),
          const SizedBox(width: 20),

          // 2. Review Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    Text(item['date']!, style: const TextStyle(color: Colors.grey, fontSize: 10)),
                  ],
                ),
                const SizedBox(height: 5),
                Row(children: List.generate(5, (i) => const Icon(Icons.star, color: Color(0xFFFFB800), size: 12))),
                const SizedBox(height: 10),
                Text(
                  item['title']!,
                  style: GoogleFonts.montserrat(fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1),
                ),
                const SizedBox(height: 8),
                Text(
                  item['review']!,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: Colors.black87, height: 1.4, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}