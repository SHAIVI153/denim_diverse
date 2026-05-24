import 'package:denim_diverse/screens/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'login/login_screen.dart';
import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';
import 'screens/home_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/collection_screen.dart';
import 'screens/crazy_deals_screen.dart';
import 'screens/order_history_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/profile_screen.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: const DenimDiverseApp(),
    ),
  );
}

class DenimDiverseApp extends StatelessWidget {
  const DenimDiverseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DenimDiverse',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme.copyWith(
        textTheme: GoogleFonts.montserratTextTheme(AppTheme.theme.textTheme),
      ),
      initialRoute: '/',
      onGenerateRoute: _generateRoute,
    );
  }

  Route<dynamic>? _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _fade(const HomeScreen());

      case '/cart':
        return _slide(const CartScreen());

      case '/checkout':
        return _slide(const CheckoutScreen());

      case '/collection':
        final cat = settings.arguments as String?;
        return _fade(CollectionScreen(initialCategory: cat));

      case '/deals':
        return _fade(const CrazyDealsScreen());

      case '/orders':
        return _slide(const OrderHistoryScreen());

      case '/profile':
        return _slide(const ProfileScreen());

      case '/login':
        return _slide(const LoginScreen());

      case '/product-detail':
        if (settings.arguments is Map<String, dynamic>) {
          return _slide(
            ProductDetailScreen(
              product: settings.arguments as Map<String, dynamic>,
            ),
          );
        }
        return _fade(const HomeScreen());

      default:
        return _fade(const HomeScreen());
    }
  }

  PageRoute _fade(Widget page) => PageRouteBuilder(
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, anim, __, child) =>
        FadeTransition(opacity: anim, child: child),
    transitionDuration: const Duration(milliseconds: 250),
  );

  PageRoute _slide(Widget page) => PageRouteBuilder(
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, anim, __, child) => SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
      child: child,
    ),
    transitionDuration: const Duration(milliseconds: 300),
  );
}