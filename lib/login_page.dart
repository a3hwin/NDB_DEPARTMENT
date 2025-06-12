import 'package:flutter/material.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _mobileController = TextEditingController();
  final _otpController = TextEditingController();
  bool _isLoading = false;
  bool _showResend = false;

  @override
  void initState() {
    super.initState();
    _mobileController.addListener(_checkInput);
    _otpController.addListener(_checkInput);
  }

  void _checkInput() {
    setState(() {
      _showResend = _mobileController.text.isNotEmpty;
    });
  }

  void _handleLogin() {
    setState(() => _isLoading = true);
    if (_mobileController.text.isNotEmpty && _otpController.text == '1234') {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Login Successful!')));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardPage()),
      );
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardPage()),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid mobile number or OTP')),
      );
    }
    setState(() => _isLoading = false);
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
                              'Email ID',
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
                              decoration: const InputDecoration(
                                hintText: 'Enter your email address',
                                hintStyle: TextStyle(
                                  color: Color(0xFFC4C2C0),
                                  fontSize: 16,
                                  fontFamily: 'Inter Display',
                                  fontWeight: FontWeight.w400,
                                  height: 1.50,
                                ),
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Password',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF030100),
                                fontFamily: 'Inter Display',
                                fontWeight: FontWeight.w400,
                                height: 1.57,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  controller: _otpController,
                                  decoration: const InputDecoration(
                                    hintText: 'Enter OTP received',
                                    hintStyle: TextStyle(
                                      color: Color(0xFFC4C2C0),
                                      fontSize: 16,
                                      fontFamily: 'Inter Display',
                                      fontWeight: FontWeight.w400,
                                      height: 1.50,
                                    ),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                if (_showResend)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            // Add reset password logic here
                                          },
                                          child: const Text(
                                            'Reset Password',
                                            style: TextStyle(
                                              color: Color(0xFFF97D09),
                                              fontSize: 14,
                                              fontFamily: 'Inter Display',
                                              fontWeight: FontWeight.w400,
                                              height: 1.43,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
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
                          (_mobileController.text.isNotEmpty &&
                                  _otpController.text.isNotEmpty &&
                                  !_isLoading)
                              ? _handleLogin
                              : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _mobileController.text.isNotEmpty &&
                                    _otpController.text.isNotEmpty
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
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      (_mobileController.text.isNotEmpty &&
                                              _otpController.text.isNotEmpty &&
                                              !_isLoading)
                                          ? Colors.white
                                          : Color(0xFF8C8885),
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
