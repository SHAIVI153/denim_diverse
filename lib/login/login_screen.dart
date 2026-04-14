import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  bool isLogin = true; // Toggle between Login and Sign Up
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggleView() {
    setState(() {
      isLogin = !isLogin;
    });
    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool isWeb = width > 900;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // 1. LEFT PANEL: Welcome Section (Web View Only)
          if (isWeb)
            Expanded(
              child: Stack(
                children: [
                  Container(color: const Color(0xFF1A3A5F)),
                  Positioned.fill(child: Opacity(opacity: 0.2, child: CustomPaint(painter: WavePainter()))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 80),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBadge("BEYOND THE STANDARD BLUE"),
                        const SizedBox(height: 40),
                        Text(
                          isLogin ? "Welcome to\nDenim Diverse" : "Join the\nDenim Community",
                          style: GoogleFonts.montserrat(color: Colors.white, fontSize: 50, fontWeight: FontWeight.w900, height: 1.1),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          isLogin
                              ? "Premium denim apparel, crafted for unique fits and sustainable style."
                              : "Create an account to track your orders and get early access to new drops.",
                          style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.6),
                        ),
                        const SizedBox(height: 50),
                        Container(height: 3, width: 60, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10))),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // 2. RIGHT PANEL: Dynamic Form (Login/Sign Up)
          Expanded(
            child: FadeTransition(
              opacity: _fadeIn,
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: isWeb ? 100 : 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(isLogin ? "Sign in" : "Create Account",
                          style: GoogleFonts.montserrat(fontSize: 35, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 40),

                      if (!isLogin) ...[
                        _inputField("Full Name", Icons.person_outline, hint: "Shawaiz Niamat"),
                        const SizedBox(height: 20),
                      ],

                      _inputField("Email Address", Icons.email_outlined, hint: "denim.user@example.com"),
                      const SizedBox(height: 20),
                      _inputField("Password", Icons.lock_outline, isPassword: true, hint: "••••••••"),

                      const SizedBox(height: 15),
                      if (isLogin)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildRememberMe(),
                            const Text("Forgot Password?", style: TextStyle(color: Colors.redAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                          ],
                        ),

                      const SizedBox(height: 35),
                      _actionButton(isLogin ? "LOGIN" : "SIGN UP"),

                      const SizedBox(height: 40),
                      _buildSocialDivider(),
                      const SizedBox(height: 30),

                      // Social Icons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _socialIcon(FontAwesomeIcons.google, Colors.red.shade700),
                          const SizedBox(width: 25),
                          _socialIcon(FontAwesomeIcons.facebookF, const Color(0xFF1877F2)),
                          const SizedBox(width: 25),
                          _socialIcon(FontAwesomeIcons.instagram, const Color(0xFFE4405F)),
                        ],
                      ),

                      const SizedBox(height: 40),
                      Center(
                        child: InkWell(
                          onTap: toggleView,
                          child: RichText(
                            text: TextSpan(
                              text: isLogin ? "Don't have an Account? " : "Already have an account? ",
                              style: const TextStyle(color: Colors.black54, fontSize: 12),
                              children: [
                                TextSpan(
                                  text: isLogin ? "Sign up" : "Login",
                                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w900),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGETS ---

  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: GoogleFonts.montserrat(color: Colors.white, fontSize: 9, letterSpacing: 3, fontWeight: FontWeight.w600)),
    );
  }

  Widget _inputField(String label, IconData icon, {bool isPassword = false, required String hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11)),
        TextField(
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 20, color: Colors.black54),
            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black12)),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF1A3A5F))),
          ),
        ),
      ],
    );
  }

  Widget _actionButton(String text) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A3A5F), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        onPressed: () {},
        child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2)),
      ),
    );
  }

  Widget _socialIcon(IconData icon, Color color) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white, border: Border.all(color: Colors.grey.shade100)),
        child: FaIcon(icon, color: color, size: 20),
      ),
    );
  }

  Widget _buildSocialDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.shade300)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text("OR CONTINUE WITH", style: GoogleFonts.montserrat(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
        ),
        Expanded(child: Divider(color: Colors.grey.shade300)),
      ],
    );
  }

  Widget _buildRememberMe() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(value: _rememberMe, onChanged: (v) => setState(() => _rememberMe = v!), activeColor: const Color(0xFF1A3A5F)),
        const Text("Remember Me", style: TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}

class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = Colors.white.withOpacity(0.1)..style = PaintingStyle.stroke..strokeWidth = 2.0;
    var path = Path();
    for (var i = 0; i < size.height; i += 40) {
      path.moveTo(0, i.toDouble());
      path.quadraticBezierTo(size.width * 0.25, i + 20, size.width * 0.5, i.toDouble());
      path.quadraticBezierTo(size.width * 0.75, i - 20, size.width, i.toDouble());
    }
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}