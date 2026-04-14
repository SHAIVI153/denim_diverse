import 'package:flutter/material.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_outline, size: 100, color: Colors.black),
              const SizedBox(height: 30),
              const Text("THANK YOU FOR YOUR ORDER!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 2)),
              const SizedBox(height: 15),
              const Text("Your premium denim is being prepared for delivery.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 50),
              SizedBox(
                width: 200,
                height: 50,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.black),
                    shape: const RoundedRectangleBorder(),
                  ),
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: const Text("CONTINUE SHOPPING",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}