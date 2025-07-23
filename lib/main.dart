import 'package:flutter/material.dart';
import 'dart:async';
import 'login_page.dart';
import 'home_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './baseUrl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:convert';
import 'update_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling background message: ${message.messageId}");
  await _storeNotification(message);
}

// Store notification in SharedPreferences
Future<void> _storeNotification(RemoteMessage message) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> notifications = prefs.getStringList('notifications') ?? [];
  final notificationData = {
    'title': message.notification?.title ?? 'No Title',
    'description': message.notification?.body ?? 'No Body',
    'timestamp': DateTime.now().toIso8601String(),
    'concernId': message.data['concernId'] ?? '',
    'action': message.data['action'] ?? '',
  };
  notifications.add(jsonEncode(notificationData));
  await prefs.setStringList('notifications', notifications);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Handle FCM token refresh
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
    print('FCM Token Refreshed: $newToken');
    final storage = FlutterSecureStorage();
    final authToken = await storage.read(key: 'authToken');
    final depUserId = await storage.read(key: 'depUserId');
    if (authToken != null && depUserId != null) {
      final url = Uri.parse(
        '$baseUrl/api/app/department/update-fcm-token?token=$authToken',
      );
      final response = await http.post(
        url,
        headers: {'Content-Type': 'text/plain'},
        body: newToken,
      );
      print(
        'FCM token refresh registration: ${response.statusCode} - ${response.body}',
      );
      if (response.statusCode == 200) {
        print(
          'Successfully registered refreshed FCM token for depUserId=$depUserId: $newToken',
        );
      } else {
        print('Failed to register refreshed FCM token: ${response.body}');
      }
    } else {
      print('Token refresh skipped: authToken or depUserId missing');
    }
  });

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
    _setupFcmHandlers(context);
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
    _checkTokenAndNavigate();
  }

  void _setupFcmHandlers(BuildContext context) async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground message received: ${message.notification?.title}");
      _storeNotification(message);
      if (message.notification != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "${message.notification?.title}: ${message.notification?.body}",
            ),
            action: SnackBarAction(
              label: 'View',
              onPressed: () => _onNotificationTap(message, context),
            ),
          ),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Notification opened: ${message.data}");
      _onNotificationTap(message, context);
    });

    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      print("Initial message: ${initialMessage.data}");
      _onNotificationTap(initialMessage, context);
    }
  }

  void _onNotificationTap(RemoteMessage message, BuildContext context) async {
    if (message.data['concernId'] != null) {
      final concernId = int.tryParse(message.data['concernId'] ?? '');
      if (concernId == null) return;
      final token = await _storage.read(key: 'authToken');
      if (token == null) return;

      final url = '$baseUrl/api/app/department/display-all-concerns/$token';
      try {
        final response = await http.get(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
        );
        if (response.statusCode == 200) {
          final List<dynamic> concerns = jsonDecode(response.body);
          final concern = concerns.firstWhere(
            (c) => c['id'] == concernId,
            orElse: () => null,
          );
          if (concern != null && mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) =>
                        UpdatePage(data: Map<String, dynamic>.from(concern)),
              ),
            );
          } else if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Grievance not found')),
            );
          }
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Unable to fetch grievances')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error fetching details: $e')));
        }
      }
    }
  }

  Future<void> _checkTokenAndNavigate() async {
    final minSplashFuture = Future.delayed(const Duration(seconds: 2));
    final token = await _storage.read(key: 'authToken');

    if (token == null || token.isEmpty) {
      await minSplashFuture;
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    } else {
      final isValid = await _verifyToken(token);
      await minSplashFuture;
      if (isValid && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardPage()),
        );
      } else if (mounted) {
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
                      color: Colors.white,
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
