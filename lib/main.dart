import 'package:denim_diverse/checkout_screen.dart';
import 'package:denim_diverse/home_screen.dart';
import 'package:denim_diverse/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'cart_screen.dart';
import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';



void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => OrderProvider()),
      ],
      child: const DenimDynasty(),
    ),
  );
}

class DenimDynasty extends StatelessWidget {
  const DenimDynasty({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Denim Dynasty',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).textTheme,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),

      initialRoute: '/',
      onGenerateRoute: (settings) {
        if (settings.name == '/') {
          return MaterialPageRoute(builder: (_) => const HomeScreen());
        }
        if (settings.name == '/cart') {
          return MaterialPageRoute(builder: (_) =>  CartScreen());
        }
        if (settings.name == '/checkout') {
          return MaterialPageRoute(builder: (_) => const CheckoutScreen());
        }
        if (settings.name == '/product-detail') {
          // Null safety check for arguments
          if (settings.arguments is Map<String, dynamic>) {
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => ProductDetailScreen(product: args),
            );
          }
        }
        return null;
      },
      // App start home screen se hogi
      home: const HomeScreen(),
    );
  }
}