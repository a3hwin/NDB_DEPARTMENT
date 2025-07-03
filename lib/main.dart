import 'package:flutter/material.dart';
import 'dart:async';
import 'login_page.dart';
import 'home_page.dart'; // Ensure this import matches your DashboardPage location
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './baseUrl.dart'; // Adjust path if necessary

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Citizen Connect Splash',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
    _checkTokenAndNavigate();
  }

  Future<void> _checkTokenAndNavigate() async {
    final minSplashFuture = Future.delayed(const Duration(seconds: 2));

    final token = await _storage.read(key: 'authToken');

    if (token == null || token.isEmpty) {
      await minSplashFuture;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } else {
      final isValid = await _verifyToken(token);
      await minSplashFuture; // Ensure minimum splash time
      if (isValid) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardPage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    }
  }

  Future<bool> _verifyToken(String token) async {
    try {
      final url = Uri.parse('$baseUrl/api/app/department/verify-token/$token');
      final response = await http.get(url);
      return response.statusCode == 200;
    } catch (e) {
      print('Error verifying token: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(color: Color(0xFFF97D09)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: _animation,
                child: ClipOval(
                  child: Container(
                    width: screenWidth * 0.3,
                    height: screenWidth * 0.3,
                    decoration: BoxDecoration(
                      color: Colors.white, // White background
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x19000000),
                          blurRadius: 30,
                          offset: Offset(0, 4),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: ClipRect(
                        child: SizedBox(
                          width: 147,
                          height: 236,
                          child: Image.asset(
                            'assets/images/dheeraj-1.png',
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20, width: 274),
              const Text(
                'NAVADODDBALLAPURA\nGRIEVANCE DESK',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Inter Display',
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.33,
                ),
              ),
              const SizedBox(height: 10, width: 274),
              const Text(
                'Serving Citizens • Resolving Issues',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Inter Display',
                  fontWeight: FontWeight.w400,
                  height: 1.67,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
