import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'change_password.dart';
import 'profile.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nameController = TextEditingController(text: 'RIHAN');
  final _emailController = TextEditingController(text: 'rihan@gmail.com');
  final _phoneController = TextEditingController(text: '9876543120');
  final _nameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  bool _isNameEditable = false;
  bool _isEmailEditable = false;
  bool _isPhoneEditable = false;
  String _selectedRole = 'Officer'; // Default dropdown value
  bool _isScrolled = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      _isScrolled = _scrollController.offset > 0;
    });
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
      body: Stack(
        children: [
          SafeArea(
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                // Custom SliverAppBar implementation
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _EditProfileSliverAppBarDelegate(
                    expandedHeight: 150, // Adjusted for title and subtitle
                    isScrolled: _isScrolled,
                    onBackPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfilePage(),
                        ),
                      );
                    },
                  ),
                ),
                // 24px spacing between app bar and first input field
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
                // Form content
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // IP-1: Name
                        const Text(
                          'Name',
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
                          controller: _nameController,
                          focusNode: _nameFocusNode,
                          readOnly: !_isNameEditable,
                          style: textFieldStyle,
                          onTap: () {
                            if (_isNameEditable) {
                              _nameFocusNode.requestFocus();
                            }
                          },
                          textInputAction: TextInputAction.next,
                          onChanged: (value) {
                            if (_isNameEditable) {
                              setState(() {});
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter your name',
                            hintStyle: const TextStyle(
                              color: Color(0xFFC4C2C0),
                              fontSize: 16,
                              fontFamily: 'Inter Display',
                              fontWeight: FontWeight.w400,
                              height: 1.50,
                            ),
                            filled: true,
                            fillColor:
                                _isNameEditable ? Colors.white : Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    _isNameEditable
                                        ? const Color(0xFFD96C07)
                                        : const Color(0xFFE1E0DF),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    _isNameEditable
                                        ? const Color(0xFFD96C07)
                                        : const Color(0xFFE1E0DF),
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFD96C07)),
                            ),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isNameEditable = !_isNameEditable;
                                    if (_isNameEditable) {
                                      _nameFocusNode.requestFocus();
                                    } else {
                                      _nameFocusNode.unfocus();
                                    }
                                  });
                                },
                                child: Text(
                                  'EDIT',
                                  style: TextStyle(
                                    color: const Color(0xFFD96C07),
                                    fontSize: 12,
                                    fontFamily: 'Inter Display',
                                    fontWeight: FontWeight.w600,
                                    height: 1.67,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16), // 16px spacing
                        // IP-2: Employee ID (Non-editable)
                        const Text(
                          'Employee ID',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF030100),
                            fontFamily: 'Inter Display',
                            fontWeight: FontWeight.w400,
                            height: 1.57,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFE1E0DF)),
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.white,
                          ),
                          child: Text('EMP-7845', style: textFieldStyle),
                        ),
                        const SizedBox(height: 16), // 16px spacing
                        // IP-3: Email
                        const Text(
                          'Email Adress',
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
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          readOnly: !_isEmailEditable,
                          style: textFieldStyle,
                          onTap: () {
                            if (_isEmailEditable) {
                              _emailFocusNode.requestFocus();
                            }
                          },
                          textInputAction: TextInputAction.next,
                          onChanged: (value) {
                            if (_isEmailEditable) {
                              setState(() {});
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter your email address',
                            hintStyle: const TextStyle(
                              color: Color(0xFFC4C2C0),
                              fontSize: 16,
                              fontFamily: 'Inter Display',
                              fontWeight: FontWeight.w400,
                              height: 1.50,
                            ),
                            filled: true,
                            fillColor:
                                _isEmailEditable ? Colors.white : Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    _isEmailEditable
                                        ? const Color(0xFFD96C07)
                                        : const Color(0xFFE1E0DF),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    _isEmailEditable
                                        ? const Color(0xFFD96C07)
                                        : const Color(0xFFE1E0DF),
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFD96C07)),
                            ),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isEmailEditable = !_isEmailEditable;
                                    if (_isEmailEditable) {
                                      _emailFocusNode.requestFocus();
                                    } else {
                                      _emailFocusNode.unfocus();
                                    }
                                  });
                                },
                                child: Text(
                                  'EDIT',
                                  style: TextStyle(
                                    color: const Color(0xFFD96C07),
                                    fontSize: 12,
                                    fontFamily: 'Inter Display',
                                    fontWeight: FontWeight.w600,
                                    height: 1.67,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16), // 16px spacing
                        // IP-4: Phone
                        const Text(
                          'Phone Number',
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
                          controller: _phoneController,
                          focusNode: _phoneFocusNode,
                          readOnly: !_isPhoneEditable,
                          style: textFieldStyle,
                          onTap: () {
                            if (_isPhoneEditable) {
                              _phoneFocusNode.requestFocus();
                            }
                          },
                          textInputAction: TextInputAction.next,
                          onChanged: (value) {
                            if (_isPhoneEditable) {
                              setState(() {});
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter your phone number',
                            hintStyle: const TextStyle(
                              color: Color(0xFFC4C2C0),
                              fontSize: 16,
                              fontFamily: 'Inter Display',
                              fontWeight: FontWeight.w400,
                              height: 1.50,
                            ),
                            filled: true,
                            fillColor:
                                _isPhoneEditable ? Colors.white : Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    _isPhoneEditable
                                        ? const Color(0xFFD96C07)
                                        : const Color(0xFFE1E0DF),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    _isPhoneEditable
                                        ? const Color(0xFFD96C07)
                                        : const Color(0xFFE1E0DF),
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFD96C07)),
                            ),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isPhoneEditable = !_isPhoneEditable;
                                    if (_isPhoneEditable) {
                                      _phoneFocusNode.requestFocus();
                                    } else {
                                      _phoneFocusNode.unfocus();
                                    }
                                  });
                                },
                                child: Text(
                                  'EDIT',
                                  style: TextStyle(
                                    color: const Color(0xFFD96C07),
                                    fontSize: 12,
                                    fontFamily: 'Inter Display',
                                    fontWeight: FontWeight.w600,
                                    height: 1.67,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 16), // 16px spacing
                        // IP-5: Designation (Dropdown)
                        const Text(
                          'Designation',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF030100),
                            fontFamily: 'Inter Display',
                            fontWeight: FontWeight.w400,
                            height: 1.57,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _selectedRole,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFE1E0DF)),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFE1E0DF)),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFD96C07)),
                            ),
                          ),
                          icon: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: SvgPicture.asset(
                              'assets/images/arrow_down.svg',
                              width: 10.4,
                              height: 6,
                            ),
                          ),
                          items:
                              ['Officer', 'Admin'].map((String role) {
                                return DropdownMenuItem<String>(
                                  value: role,
                                  child: Text(role, style: textFieldStyle),
                                );
                              }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedRole = newValue!;
                            });
                          },
                        ),
                        const SizedBox(height: 16), // 16px spacing
                        // IP-6: Password (Non-editable)
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
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFE1E0DF)),
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.white,
                          ),
                          child: Text('9876543120', style: textFieldStyle),
                        ),
                        const SizedBox(height: 16), // 16px spacing
                        // IP-7: Change Password
                        const Text(
                          'Change Password',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF030100),
                            fontFamily: 'Inter Display',
                            fontWeight: FontWeight.w400,
                            height: 1.57,
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => const ChangePasswordPage(),
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            height: 52,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  width: 1,
                                  color: Color(0xFFE1E0DF),
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Stack(
                              children: [
                                const Positioned(
                                  left: 12,
                                  top: 14,
                                  child: Text(
                                    'Change password',
                                    style: TextStyle(
                                      color: Color(0xFF8C8885),
                                      fontSize: 16,
                                      fontFamily: 'Inter Display',
                                      fontWeight: FontWeight.w400,
                                      height: 1.50,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 12,
                                  top: 23,
                                  child: SvgPicture.asset(
                                    'assets/images/arrow_right.svg',
                                    width: 10.4,
                                    height: 6,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 150,
                        ), // Extra padding to avoid overlap with sticky button
                      ],
                    ),
                  ),
                ),
              ],
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
                      builder: (context) => const ProfilePage(),
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
                      'Save',
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

// Custom SliverPersistentHeaderDelegate for complex AppBar behavior
class _EditProfileSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final bool isScrolled;
  final VoidCallback onBackPressed;

  _EditProfileSliverAppBarDelegate({
    required this.expandedHeight,
    required this.isScrolled,
    required this.onBackPressed,
  });

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => 120;

  @override
  bool shouldRebuild(covariant _EditProfileSliverAppBarDelegate oldDelegate) {
    return expandedHeight != oldDelegate.expandedHeight ||
        isScrolled != oldDelegate.isScrolled;
  }

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final double visibilityFactor =
        1.0 - shrinkOffset / (maxExtent - minExtent);
    final double visibilityPercentage = visibilityFactor.clamp(0.0, 1.0);

    // Calculate the transition values for title
    final double titleFontSize = 16 + (24 - 16) * visibilityPercentage;
    final double titleLeftPosition = 20; // Fixed 20px from left edge
    final double titleTopPosition =
        20 +
        (72 - 20) * visibilityPercentage; // 72 = position in expanded state
    final FontWeight titleFontWeight =
        visibilityPercentage > 0.5 ? FontWeight.w600 : FontWeight.w500;

    // Whether we're in collapsed state
    final bool isCollapsed = shrinkOffset > 0;

    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          // Top row with back and close icons
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back button
                GestureDetector(
                  onTap: onBackPressed,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      size: 20,
                      color: Color(0xFF030100),
                    ),
                  ),
                ),
                // Title in collapsed state - positioned to the right of back button
                AnimatedOpacity(
                  opacity: 1 - visibilityPercentage,
                  duration: const Duration(milliseconds: 300),
                  child: Visibility(
                    visible: 1 - visibilityPercentage > 0.1,
                    child: const Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Edit account details',
                          style: TextStyle(
                            color: Color(0xFF030100),
                            fontSize: 16,
                            fontFamily: 'Inter Display',
                            fontWeight: FontWeight.w500,
                            height: 1.50,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                // Close icon
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfilePage(),
                      ),
                    );
                  },
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.close,
                      size: 20,
                      color: const Color(0xFF030100),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Title in expanded state
          Positioned(
            left: titleLeftPosition,
            top: titleTopPosition,
            child: AnimatedOpacity(
              opacity: visibilityPercentage,
              duration: const Duration(milliseconds: 300),
              child: Visibility(
                visible: visibilityPercentage > 0.1,
                child: SizedBox(
                  width: 335,
                  child: Text(
                    'Edit account details',
                    style: TextStyle(
                      color: const Color(0xFF030100),
                      fontSize: titleFontSize,
                      fontFamily: 'Inter Display',
                      fontWeight: titleFontWeight,
                      height: 1.33,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Subtitle - with consistent 20px left margin
          Positioned(
            left: 20,
            top: 112, // 72 (title top) + 24 (title height) + 16 (spacing)
            child: AnimatedOpacity(
              opacity: visibilityPercentage,
              duration: const Duration(milliseconds: 300),
              child: Visibility(
                visible: visibilityPercentage > 0.1,
                child: const SizedBox(
                  width: 335,
                  child: Text(
                    'Update your information',
                    style: TextStyle(
                      color: Color(0xFF8C8885),
                      fontSize: 16,
                      fontFamily: 'Inter Display',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
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
