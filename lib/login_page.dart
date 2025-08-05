import 'package:flutter/material.dart';
import 'home_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './baseUrl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _mobileController = TextEditingController();
  final _otpController = TextEditingController();
  bool _isLoading = false;
  bool _otpSent = false;
  String? _errorMessage;
  int? _depUserId;
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    // Add listener to mobileController to rebuild UI on text change
    _mobileController.addListener(() {
      setState(() {
        // This will trigger a rebuild when the text changes
      });
    });
  }

  // Send OTP to mobile number
  Future<void> _sendOTP() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _depUserId = null;
    });

    final mobile = _mobileController.text.trim();
    if (mobile.isEmpty || mobile.length != 10) {
      setState(() {
        _errorMessage = 'Please enter a valid 10-digit mobile number';
        _isLoading = false;
      });
      return;
    }

    try {
      final map = <String, String>{};
      map['depMobile'] = mobile;
      final url = Uri.parse('$baseUrl/api/app/login-department-app-user');

      final response = await http.post(url, body: map);

      print('Send OTP API Response: ${response.statusCode} - ${response.body}');

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        if (responseData['errFlag'] == 1) {
          setState(() {
            _errorMessage = responseData['message'];
            _isLoading = false;
          });
          return;
        }

        setState(() {
          _otpSent = true;
          _depUserId = responseData['depUserId'];
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('OTP sent successfully!')));
      } else {
        setState(() {
          _errorMessage =
              'Failed to send OTP: ${responseData['message'] ?? response.body}';
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _errorMessage = 'Network error: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Verify OTP and store user data
  Future<void> _verifyOTP() async {
    final otp = _otpController.text.trim();
    if (otp.isEmpty || otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 6-digit OTP')),
      );
      return;
    }

    if (_depUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: Missing user ID. Please request a new OTP'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final map = <String, String>{};
      map['otp'] = otp;
      map['depMobile'] = _mobileController.text.trim();
      map['depUserId'] = _depUserId.toString();

      final url = Uri.parse('$baseUrl/api/app/department/verify-otp');

      final response = await http.post(url, body: map);
      print(
        'Verify OTP API Response: ${response.statusCode} - ${response.body}',
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        if (responseData['errFlag'] == 0) {
          final token = responseData['token'] ?? '';

          await _storeUserData(
            phone: _mobileController.text.trim(),
            depUserId: _depUserId!,
            token: token,
          );

          await _registerFcmToken(token);

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Login Successful!')));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DashboardPage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'OTP verification failed: ${responseData['message']}',
              ),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Server error: ${response.body}')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Network error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Store user data in secure storage
  Future<void> _storeUserData({
    required String phone,
    required int depUserId,
    required String token,
  }) async {
    try {
      await _storage.write(key: 'userPhone', value: phone);
      await _storage.write(key: 'depUserId', value: depUserId.toString());
      await _storage.write(key: 'authToken', value: token);

      print('User data stored securely:');
      print('Phone: $phone');
      print('depUserId: $depUserId');
      print('Token: $token');
    } catch (e) {
      print('Error storing user data: $e');
    }
  }

  Future<void> _registerFcmToken(String authToken) async {
    try {
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      print('Generated FCM Token: $fcmToken');
      if (fcmToken != null && authToken.isNotEmpty) {
        final depUserId = await _storage.read(key: 'depUserId');
        if (depUserId == null) {
          print('Error: depUserId not found in storage');
          return;
        }
        final url = Uri.parse(
          '$baseUrl/api/app/department/update-fcm-token?token=$authToken',
        );
        final response = await http.post(
          url,
          headers: {'Content-Type': 'text/plain'},
          body: fcmToken,
        );
        print(
          'FCM token registration status: ${response.statusCode} - ${response.body}',
        );
        if (response.statusCode != 200) {
          print('Failed to register FCM token: ${response.body}');
        } else {
          print(
            'Successfully registered FCM token for depUserId=$depUserId: $fcmToken',
          );
        }
      } else {
        print('FCM token registration skipped: fcmToken or authToken missing');
      }
    } catch (e) {
      print('Error registering FCM token: $e');
    }
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: const Color.fromARGB(255, 255, 255, 255),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 90),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: const Color(0xFFFFCDAE),
                              child: ClipOval(
                                child: SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: OverflowBox(
                                    maxWidth: 120,
                                    maxHeight: 192,
                                    alignment: Alignment.topCenter,
                                    child: Image.asset(
                                      'assets/images/dheeraj-1.png',
                                      width: 120,
                                      height: 192,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'NAVADODDBALLAPURA',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Inter Display',
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFFF97D09),
                                    height: 1.40,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Serving Citizens • Resolving Issues',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                    fontFamily: 'Inter Display',
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFFB95B05),
                                    height: 1.67,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Let's get you Logged in!",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter Display',
                                color: Color(0xFF030100),
                                height: 1.33,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Login with your official credentials to manage, \ntrack, and resolve citizen grievances seamlessly.',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF8C8885),
                                fontFamily: 'Inter Display',
                                fontWeight: FontWeight.w400,
                                height: 1.50,
                              ),
                            ),
                            const SizedBox(height: 30),
                            const Text(
                              'Mobile Number',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF030100),
                                fontFamily: 'Inter Display',
                                fontWeight: FontWeight.w400,
                                height: 1.57,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _mobileController,
                              decoration: InputDecoration(
                                hintText: 'Enter your 10-digit mobile number',
                                hintStyle: const TextStyle(
                                  color: Color(0xFFC4C2C0),
                                  fontSize: 16,
                                  fontFamily: 'Inter Display',
                                  fontWeight: FontWeight.w400,
                                  height: 1.50,
                                ),
                                border: const OutlineInputBorder(),
                                errorText: _errorMessage,
                              ),
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              enabled: !_otpSent,
                            ),
                            const SizedBox(height: 20),
                            if (_otpSent) ...[
                              const Text(
                                'OTP (6 digits)',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF030100),
                                  fontFamily: 'Inter Display',
                                  fontWeight: FontWeight.w400,
                                  height: 1.57,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _otpController,
                                decoration: const InputDecoration(
                                  hintText: 'Enter 6-digit OTP received',
                                  hintStyle: TextStyle(
                                    color: Color(0xFFC4C2C0),
                                    fontSize: 16,
                                    fontFamily: 'Inter Display',
                                    fontWeight: FontWeight.w400,
                                    height: 1.50,
                                  ),
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                maxLength: 6,
                              ),
                              const SizedBox(height: 20),
                            ],
                            const SizedBox(height: 22),
                            const SizedBox(height: 20),
                            const SizedBox(height: 134),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 32,
                    left: 20,
                    right: 20,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          _isLoading
                              ? null
                              : (_otpSent ? _verifyOTP : _sendOTP),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _mobileController.text.length == 10 && !_isLoading
                                ? const Color(0xFFFB8B3B)
                                : const Color(0xFFE1E0DF),
                        disabledBackgroundColor: const Color(0xFFD3D3D3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child:
                          _isLoading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : Text(
                                _otpSent ? 'Verify OTP' : 'Send OTP',
                                style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      _mobileController.text.length == 10
                                          ? Colors.white
                                          : const Color(0xFF8C8885),
                                  fontFamily: 'Inter Display',
                                  fontWeight: FontWeight.w600,
                                  height: 1.50,
                                ),
                              ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
