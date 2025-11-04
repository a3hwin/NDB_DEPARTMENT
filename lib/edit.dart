import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'profile.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _departmentNameController = TextEditingController(text: 'RIHAN');
  final _departmentCodeController = TextEditingController(text: '');
  final _headOfDepartmentController = TextEditingController(text: '');
  final _emailController = TextEditingController(text: 'rihan@gmail.com');
  final _phoneController = TextEditingController(text: '9876543120');
  final _wardNumberController = TextEditingController(text: '');
  final _headOfDepartmentFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  bool _isHeadOfDepartmentEditable = false;
  bool _isEmailEditable = false;
  bool _isPhoneEditable = false;
  bool _isScrolled = false;
  final ScrollController _scrollController = ScrollController();
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchDepartmentDetails();
  }

  @override
  void dispose() {
    _departmentNameController.dispose();
    _departmentCodeController.dispose();
    _headOfDepartmentController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _wardNumberController.dispose();
    _headOfDepartmentFocusNode.dispose();
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

  Future<void> _fetchDepartmentDetails() async {
    final String? token = await _storage.read(key: 'authToken');
    if (token == null) return;

    final url = Uri.parse(
      'https://ndb-apis-69em6.ondigitalocean.app/api/app/department/get-department-details/$token',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        if (jsonResponse['errFlag'] == 0) {
          final Map<String, dynamic> department = jsonResponse['data'];
          setState(() {
            _departmentNameController.text =
                department['departmentName'] ?? 'RIHAN';
            _departmentCodeController.text = department['departmentCode'] ?? '';
            _headOfDepartmentController.text =
                department['headOfDepartment'] ?? '';
            _emailController.text =
                department['departmentEmail'] ?? 'rihan@gmail.com';
            _phoneController.text =
                department['departmentMobile'] ?? '9876543120';
            _wardNumberController.text = department['wardNumbers'] ?? '';
          });
        }
      } else {
        print(
          'API Error: Status Code ${response.statusCode}, Body: ${response.body}',
        );
      }
    } catch (e) {
      print('API Fetch Error: $e');
      // Retain hardcoded values on failure
    }
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
          RefreshIndicator(
            onRefresh: _fetchDepartmentDetails,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _EditProfileSliverAppBarDelegate(
                    expandedHeight: 160,
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
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                          child: Text(
                            _departmentNameController.text,
                            style: textFieldStyle,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Department Code',
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
                          child: Text(
                            _departmentCodeController.text,
                            style: textFieldStyle,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Head Name',
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
                          controller: _headOfDepartmentController,
                          focusNode: _headOfDepartmentFocusNode,
                          readOnly: !_isHeadOfDepartmentEditable,
                          style: textFieldStyle,
                          onTap: () {
                            if (_isHeadOfDepartmentEditable) {
                              _headOfDepartmentFocusNode.requestFocus();
                            }
                          },
                          textInputAction: TextInputAction.next,
                          onChanged: (value) {
                            if (_isHeadOfDepartmentEditable) {
                              setState(() {});
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter head of department',
                            hintStyle: const TextStyle(
                              color: Color(0xFFC4C2C0),
                              fontSize: 16,
                              fontFamily: 'Inter Display',
                              fontWeight: FontWeight.w400,
                              height: 1.50,
                            ),
                            filled: true,
                            fillColor:
                                _isHeadOfDepartmentEditable
                                    ? Colors.white
                                    : Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    _isHeadOfDepartmentEditable
                                        ? const Color(0xFFD96C07)
                                        : const Color(0xFFE1E0DF),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    _isHeadOfDepartmentEditable
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
                                    _isHeadOfDepartmentEditable =
                                        !_isHeadOfDepartmentEditable;
                                    if (_isHeadOfDepartmentEditable) {
                                      _headOfDepartmentFocusNode.requestFocus();
                                    } else {
                                      _headOfDepartmentFocusNode.unfocus();
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
                        const SizedBox(height: 16),
                        const Text(
                          'Email Address',
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
                        const SizedBox(height: 16),
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
                        const SizedBox(height: 16),
                        const Text(
                          'Ward Number',
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
                          child: Text(
                            _wardNumberController.text,
                            style: textFieldStyle,
                          ),
                        ),
                        const SizedBox(height: 150),
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
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
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

    final double titleFontSize = 16 + (24 - 16) * visibilityPercentage;
    final double titleLeftPosition = 20;
    final double titleTopPosition = 44 + (96 - 44) * visibilityPercentage;
    final FontWeight titleFontWeight =
        visibilityPercentage > 0.5 ? FontWeight.w600 : FontWeight.w500;

    final bool isCollapsed = shrinkOffset > 0;

    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Positioned(
            top: 54,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                          'Edit Account Details',
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
                    'Edit Account Details',
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
          Positioned(
            left: 20,
            top: 136,
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