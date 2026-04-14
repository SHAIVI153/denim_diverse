import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool isWeb = width > 950;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text("MY PROFILE",
            style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.black, letterSpacing: 2)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: isWeb ? width * 0.2 : 20, vertical: 40),
          child: Column(
            children: [
              // --- PROFILE HEADER ---
              const CircleAvatar(
                radius: 60,
                backgroundColor: Color(0xFFF5F5F5),
                child: Icon(Icons.person_outline, size: 60, color: Colors.black),
              ),
              const SizedBox(height: 20),
              Text("SHAWAIZ NIAMAT",
                  style: GoogleFonts.montserrat(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 1)),
              Text("shawiCode",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14, letterSpacing: 1)),

              const SizedBox(height: 40),
              const Divider(),
              const SizedBox(height: 20),

              // --- SKILLS SECTION ---
              _buildSectionTitle("TECHNICAL EXPERTISE"),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  _buildSkillChip("FLUTTER"),
                  _buildSkillChip("FIREBASE"),
                  _buildSkillChip("DATABASE"),
                  _buildSkillChip("UI/UX DESIGN"),
                  _buildSkillChip("APIs"),
                  _buildSkillChip("STATE MANAGEMENT"),
                ],
              ),

              const SizedBox(height: 40),
              const Divider(),
              const SizedBox(height: 20),

              // --- ACCOUNT DETAILS ---
              _buildSectionTitle("ACCOUNT DETAILS"),
              const SizedBox(height: 20),
              _buildInfoRow("EMAIL", "shawaizniamat@example.com"),
              _buildInfoRow("CONTACT", "+92 300 0000000"),
              _buildInfoRow("LOCATION", "Pakistan"),

              const SizedBox(height: 50),

              // --- LOGOUT BUTTON ---
              SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.black),
                    shape: const RoundedRectangleBorder(),
                  ),
                  onPressed: () {
                    // Logout Logic
                  },
                  child: const Text("LOGOUT",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, letterSpacing: 2)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title,
        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 2));
  }

  Widget _buildSkillChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(0),
      ),
      child: Text(label,
          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }
}