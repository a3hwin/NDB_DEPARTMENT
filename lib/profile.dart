import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'bottomNavBar.dart';
import 'home_page.dart';
import 'grievancesPage.dart';
import 'notif.dart';
import 'edit.dart';
import 'login_page.dart'; // Add this import for the LoginPage

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isGetInTouchExpanded = false;
  bool _isCallUsExpanded = false;
  bool _isSupportEmailExpanded = false;
  final _storage = const FlutterSecureStorage(); // Initialize secure storage

  // Logout function
  Future<void> _logout() async {
    try {
      // Delete authentication token and other user data
      await _storage.delete(key: 'authToken');
      await _storage.delete(key: 'userPhone'); // Optional
      await _storage.delete(key: 'depUserId'); // Optional
    } catch (e) {
      print('Error deleting from secure storage: $e');
      // Proceed to login page even if deletion fails
    }

    // Navigate to LoginPage and remove all previous routes
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                width: MediaQuery.of(context).size.width,
                height: 196,
                decoration: const BoxDecoration(color: Color(0xFF612C01)),
                child: Stack(
                  children: [
                    const Positioned(
                      left: 20,
                      top: 112,
                      child: Text(
                        'RIHAN',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontFamily: 'Inter Display',
                          fontWeight: FontWeight.w600,
                          height: 1.33,
                          letterSpacing: -0.96,
                        ),
                      ),
                    ),
                    const Positioned(
                      left: 20,
                      top: 148,
                      child: Text(
                        'Department Of Roads • rihan@gmail.com',
                        style: TextStyle(
                          color: Color(0xFFC4C2C0),
                          fontSize: 12,
                          fontFamily: 'Inter Display',
                          fontWeight: FontWeight.w400,
                          height: 1.67,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      left: 270,
                      top: 90,
                      child: Container(
                        width: 50,
                        height: 50,
                        child: SvgPicture.asset(
                          'assets/images/flower.svg',
                          fit: BoxFit.cover,
                          width: 100,
                          height: 53,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Options
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    buildNonExpandableOption(
                      'Edit profile',
                      'Update your information',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfilePage(),
                          ),
                        );
                      },
                    ),
                    buildExpandableOption(
                      'Get in Touch',
                      'Reach us via call or email',
                      _isGetInTouchExpanded,
                      () {
                        setState(() {
                          _isGetInTouchExpanded = !_isGetInTouchExpanded;
                        });
                      },
                    ),
                    if (_isGetInTouchExpanded) ...[
                      buildCallUsSection(),
                      buildSupportEmailSection(),
                    ],
                    buildNonExpandableOption('Logout', 'Sign out securely', () {
                      _logout(); // Call logout function
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 3,
        onItemTapped: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const DashboardPage()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const GrievancesScreen()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationsPage(),
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildNonExpandableOption(
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1, color: Color(0xFFE1E0DF)),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF030100),
                    fontSize: 16,
                    fontFamily: 'Inter Display',
                    fontWeight: FontWeight.w500,
                    height: 1.50,
                    letterSpacing: -0.64,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF8C8885),
                    fontSize: 12,
                    fontFamily: 'Inter Display',
                    fontWeight: FontWeight.w400,
                    height: 1.67,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: SvgPicture.asset(
                'assets/images/arrow_right.svg',
                width: 15.4,
                height: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildExpandableOption(
    String title,
    String subtitle,
    bool isExpanded,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1, color: Color(0xFFE1E0DF)),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF030100),
                    fontSize: 16,
                    fontFamily: 'Inter Display',
                    fontWeight: FontWeight.w500,
                    height: 1.50,
                    letterSpacing: -0.64,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF8C8885),
                    fontSize: 12,
                    fontFamily: 'Inter Display',
                    fontWeight: FontWeight.w400,
                    height: 1.67,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: SvgPicture.asset(
                isExpanded
                    ? 'assets/images/arrow_up.svg'
                    : 'assets/images/arrow_down.svg',
                width: 10.4,
                height: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCallUsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(width: 1, color: Color(0xFFE1E0DF))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isCallUsExpanded = !_isCallUsExpanded;
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/images/phoneg.svg',
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Call Us',
                      style: TextStyle(
                        color: Color(0xFF8C8885),
                        fontSize: 12,
                        fontFamily: 'Inter Display',
                        fontWeight: FontWeight.w500,
                        height: 1.67,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: SvgPicture.asset(
                    _isCallUsExpanded
                        ? 'assets/images/arrow_up.svg'
                        : 'assets/images/arrow_down.svg',
                    width: 10.4,
                    height: 6,
                  ),
                ),
              ],
            ),
          ),
          if (_isCallUsExpanded) ...[
            const SizedBox(height: 8),
            const Text(
              'CALL US ON',
              style: TextStyle(
                color: Color(0xFFD96C07),
                fontSize: 12,
                fontFamily: 'Inter Display',
                fontWeight: FontWeight.w500,
                height: 1.67,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: ShapeDecoration(
                color: const Color(0xFFD96C07),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                '080 23456789',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: 'Inter Display',
                  fontWeight: FontWeight.w500,
                  height: 1.67,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget buildSupportEmailSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(width: 1, color: Color(0xFFE1E0DF))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isSupportEmailExpanded = !_isSupportEmailExpanded;
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/images/email.svg',
                      width: 20,
                      height: 14.09,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Support Email',
                      style: TextStyle(
                        color: Color(0xFF8C8885),
                        fontSize: 12,
                        fontFamily: 'Inter Display',
                        fontWeight: FontWeight.w500,
                        height: 1.67,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: SvgPicture.asset(
                    _isSupportEmailExpanded
                        ? 'assets/images/arrow_up.svg'
                        : 'assets/images/arrow_down.svg',
                    width: 10.4,
                    height: 6,
                  ),
                ),
              ],
            ),
          ),
          if (_isSupportEmailExpanded) ...[
            const SizedBox(height: 8),
            const Text(
              'EMAIL US ON',
              style: TextStyle(
                color: Color(0xFFD96C07),
                fontSize: 12,
                fontFamily: 'Inter Display',
                fontWeight: FontWeight.w500,
                height: 1.67,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: ShapeDecoration(
                color: const Color(0xFFD96C07),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'SEND AN EMAIL',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: 'Inter Display',
                  fontWeight: FontWeight.w500,
                  height: 1.67,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
