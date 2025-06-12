import 'package:flutter/material.dart';
import 'edit.dart'; // Import EditProfilePage for navigation

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _currentPasswordFocusNode = FocusNode();
  final _newPasswordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _currentPasswordFocusNode.dispose();
    _newPasswordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const textFieldStyle = TextStyle(
      color: Color(0xFF030100),
      fontSize: 16,
      fontFamily: 'Inter Display',
      fontWeight: FontWeight.w400,
      height: 1.50,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('')),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 37), // 37px below AppBar
                  SizedBox(
                    width: 335,
                    child: Text(
                      'Change password',
                      style: TextStyle(
                        color: const Color(0xFF030100),
                        fontSize: 24,
                        fontFamily: 'Inter Display',
                        fontWeight: FontWeight.w600,
                        height: 1.33,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8), // Spacing between headings
                  SizedBox(
                    width: 335,
                    child: Text(
                      'Your password must be at least 6 characters and should include a combination of numbers, letters and special characters (!@\$%)',
                      style: TextStyle(
                        color: const Color(0xFF8C8885),
                        fontSize: 16,
                        fontFamily: 'Inter Display',
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30), // Spacing before input fields
                  // Current Password
                  const Text(
                    'Current Password',
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
                    controller: _currentPasswordController,
                    focusNode: _currentPasswordFocusNode,
                    obscureText: true,
                    style: textFieldStyle,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) {
                      _newPasswordFocusNode.requestFocus();
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter your current password',
                      hintStyle: const TextStyle(
                        color: Color(0xFFC4C2C0),
                        fontSize: 16,
                        fontFamily: 'Inter Display',
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.fromLTRB(12, 18, 12, 18),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 1,
                          color: Color(0xFFE1E0DF),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 1,
                          color: Color(0xFFE1E0DF),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 1,
                          color: Color(0xFFD96C07),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16), // 16px spacing
                  // New Password
                  const Text(
                    'New Password',
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
                    controller: _newPasswordController,
                    focusNode: _newPasswordFocusNode,
                    obscureText: true,
                    style: textFieldStyle,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) {
                      _confirmPasswordFocusNode.requestFocus();
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter your new password',
                      hintStyle: const TextStyle(
                        color: Color(0xFFC4C2C0),
                        fontSize: 16,
                        fontFamily: 'Inter Display',
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.fromLTRB(12, 18, 12, 18),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 1,
                          color: Color(0xFFE1E0DF),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 1,
                          color: Color(0xFFE1E0DF),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 1,
                          color: Color(0xFFD96C07),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16), // 16px spacing
                  // Confirm New Password
                  const Text(
                    'Confirm New Password',
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
                    controller: _confirmPasswordController,
                    focusNode: _confirmPasswordFocusNode,
                    obscureText: true,
                    style: textFieldStyle,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText: 'Confirm your new password',
                      hintStyle: const TextStyle(
                        color: Color(0xFFC4C2C0),
                        fontSize: 16,
                        fontFamily: 'Inter Display',
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.fromLTRB(12, 18, 12, 18),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 1,
                          color: Color(0xFFE1E0DF),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 1,
                          color: Color(0xFFE1E0DF),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 1,
                          color: Color(0xFFD96C07),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32), // 32px before button
                  const SizedBox(
                    height: 90,
                  ), // Extra padding to avoid overlap with sticky button
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                0,
                20,
                32,
              ), // 32px from bottom, 20px sides
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfilePage(),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: ShapeDecoration(
                    color: const Color(0xFFFB8B3B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x3F3A2211),
                        blurRadius: 2,
                        offset: Offset(0, 1),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Save password',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Inter Display',
                        fontWeight: FontWeight.w600,
                        height: 1.50,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
