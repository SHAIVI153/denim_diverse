import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DenimFooter extends StatelessWidget {
  const DenimFooter({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool isWeb = width > 900;

    return Column(
      children: [
        // 1. TRUST SECTION (Footer se pehle wala section)
        _buildTrustSection(isWeb),

        // 2. MAIN FOOTER
        Container(
          width: double.infinity,
          color: const Color(0xFF0F172A), // Deep Navy Black
          padding: EdgeInsets.symmetric(
            horizontal: isWeb ? 80 : 20,
            vertical: 80,
          ),
          child: Column(
            children: [
              Wrap(
                spacing: 50,
                runSpacing: 50,
                alignment: WrapAlignment.spaceBetween,
                children: [
                  // Brand & Contact
                  _footerCol(
                    300,
                    "DENIM DIVERSE",
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          " Gulberg III, Lahore, Pakistan",
                          style: TextStyle(color: Colors.white54, fontSize: 13, height: 1.8),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Helpline: 0123456789",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        const SizedBox(height: 25),
                        Row(
                          children: [
                            _socialBtn(FontAwesomeIcons.facebookF),
                            _socialBtn(FontAwesomeIcons.instagram),
                            _socialBtn(FontAwesomeIcons.whatsapp),
                          ],
                        )
                      ],
                    ),
                  ),

                  // Customer Care Links
                  _footerLinks("CUSTOMER CARE", [
                    "How To Order",
                    "Returns & Exchanges",
                    "Shipping Details",
                    "Privacy Policy",
                    "FAQs"
                  ]),

                  // Newsletter Section
                  _footerCol(
                    250,
                    "STAY CONNECTED",
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Subscribe for early access to new drops and exclusive deals.",
                          style: TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                          decoration: InputDecoration(
                            hintText: "Enter Email Address",
                            hintStyle: const TextStyle(color: Colors.white24, fontSize: 12),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.05),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0),
                              borderSide: BorderSide.none,
                            ),
                            suffixIcon: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 80),
              const Divider(color: Colors.white10),
              const SizedBox(height: 30),

              // Bottom Bar with Local Payment Icons
              Row(
                mainAxisAlignment: isWeb ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                children: [
                  Text(
                    "© 2026 DENIM DIVERSE. Crafted by ShaiwiCode",
                    style: GoogleFonts.montserrat(color: Colors.white24, fontSize: 10),
                  ),
                  if (isWeb)
                    Row(
                      children: [
                        _paymentBadge("JazzCash"),
                        _paymentBadge("EasyPaisa"),
                        const Icon(FontAwesomeIcons.ccVisa, color: Colors.white24, size: 20),
                        const SizedBox(width: 15),
                        const Icon(FontAwesomeIcons.ccMastercard, color: Colors.white24, size: 20),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- Trust Section Builder ---
  Widget _buildTrustSection(bool isWeb) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Wrap(
        spacing: 40,
        runSpacing: 40,
        alignment: WrapAlignment.center,
        children: [
          _trustItem(Icons.local_shipping_outlined, "Free Shipping", "On all prepaid orders"),
          _trustItem(Icons.assignment_return_outlined, "Easy Returns", "Unused items exchange"),
          _trustItem(Icons.verified_outlined, "100% Genuine", "Original Denim Diverse quality"),
          _trustItem(Icons.savings_outlined, "Unbeatable Savings", "Factory prices for you"),
        ],
      ),
    );
  }

  Widget _trustItem(IconData icon, String title, String sub) {
    return SizedBox(
      width: 250,
      child: Column(
        children: [
          Icon(icon, size: 35, color: const Color(0xFF1A3A5F)),
          const SizedBox(height: 15),
          Text(
            title,
            style: GoogleFonts.montserrat(fontWeight: FontWeight.w900, fontSize: 15, letterSpacing: 0.5),
          ),
          const SizedBox(height: 5),
          Text(
            sub,
            style: const TextStyle(color: Colors.grey, fontSize: 11),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // --- UI Helpers ---
  Widget _footerCol(double w, String title, Widget content) {
    return SizedBox(
      width: w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 14,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 30),
          content
        ],
      ),
    );
  }

  Widget _footerLinks(String title, List<String> links) {
    return _footerCol(
      200,
      title,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: links.map((l) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(l, style: const TextStyle(color: Colors.white54, fontSize: 13)),
        )).toList(),
      ),
    );
  }

  Widget _socialBtn(IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: FaIcon(icon, color: Colors.white70, size: 18),
    );
  }

  Widget _paymentBadge(String text) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white10),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white24, fontSize: 9, fontWeight: FontWeight.bold),
      ),
    );
  }
}