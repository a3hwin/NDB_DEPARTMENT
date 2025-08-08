import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'bottomNavBar.dart';
import 'home_page.dart';
import 'grievancesPage.dart';
import 'notif.dart';
import 'edit.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isGetInTouchExpanded = false;
  bool _isCallUsExpanded = false;
  bool _isSupportEmailExpanded = false;
  final _storage = const FlutterSecureStorage();
  String headOfDepartment = 'RIHAN'; // Default value
  String departmentName = 'Department Of Roads'; // Default value
  String departmentEmail = 'rihan@gmail.com'; // Default value
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchDepartmentDetails();
  }

  Future<void> _fetchDepartmentDetails() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final String? token = await _storage.read(key: 'authToken');
      if (token == null || token.isEmpty) {
        setState(() {
          errorMessage = 'No authentication token found';
          isLoading = false;
        });
        return;
      }

      final url = Uri.parse(
        'https://ndb-apis-69em6.ondigitalocean.app/api/app/department/get-department-details/$token',
      );
      final response = await http.get(url, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        if (jsonResponse['errFlag'] == 0) {
          final Map<String, dynamic> department = jsonResponse['data'];
          setState(() {
            headOfDepartment = department['headOfDepartment'] ?? 'RIHAN';
            departmentName = department['departmentName'] ?? 'Department Of Roads';
            departmentEmail = department['departmentEmail'] ?? 'rihan@gmail.com';
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = 'Failed to load department details: ${jsonResponse['message']}';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'API Error: Status Code ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching department details: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    try {
      await _storage.delete(key: 'authToken');
      await _storage.delete(key: 'userPhone');
      await _storage.delete(key: 'depUserId');
    } catch (e) {
      print('Error deleting from secure storage: $e');
    }

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
              Container(
                width: MediaQuery.of(context).size.width,
                height: 196,
                decoration: const BoxDecoration(color: Color(0xFF612C01)),
                child: Stack(
                  children: [
                    Positioned(
                      left: 20,
                      top: 112,
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              headOfDepartment,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontFamily: 'Inter Display',
                                fontWeight: FontWeight.w600,
                                height: 1.33,
                                letterSpacing: -0.96,
                              ),
                            ),
                    ),
                    Positioned(
                      left: 20,
                      top: 148,
                      child: isLoading
                          ? const SizedBox.shrink()
                          : Text(
                              '$departmentName • $departmentEmail',
                              style: const TextStyle(
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
                    if (errorMessage != null)
                      Positioned(
                        left: 20,
                        top: 170,
                        child: Text(
                          errorMessage!,
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 12,
                            fontFamily: 'Inter Display',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    buildNonExpandableOption(
                      'ಪ್ರೋಫೈಲ್‌ ತಿದ್ದುಪಡಿ',
                      'ನಿಮ್ಮ ಮಾಹಿತಿಯನ್ನು ನವೀಕರಿಸಿ',
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
                      'ನಮ್ಮೊಂದಿಗೆ ಸಂಪರ್ಕದಲ್ಲಿರಿ',
                      'ಕರೆ ಅಥವಾ ಇಮೇಲ್‌ ಮೂಲಕ ನಮ್ಮನ್ನು ಸಂಪರ್ಕಿಸಿ',
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
                    buildNonExpandableOption('ಲಾಗೌಟ್‌', 'ಸುರಕ್ಷಿತವಾಗಿ ಸೈನ್‌ ಔಟ್‌ ಆಗಿ', () {
                      _logout();
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
    return GestureDetector(
      onTap: () {
        setState(() {
          _isCallUsExpanded = !_isCallUsExpanded;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1, color: Color(0xFFE1E0DF)),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
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
      ),
    );
  }

  Widget buildSupportEmailSection() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSupportEmailExpanded = !_isSupportEmailExpanded;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1, color: Color(0xFFE1E0DF)),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
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
      ),
    );
  }
}
