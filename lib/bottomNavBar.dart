import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375,
      height: 100,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 15,
            offset: Offset(0, -4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 13, // Padding: 13 from left
            top: 12, // Padding: 12 from top
            right: 13,
            bottom: 34,
            child: Container(
              width: 349, // 375 - 13 (left) - 13 (right)
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Home
                  Container(
                    width: 55,
                    height: 50,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          top: 0,
                          child: Center(
                            child: GestureDetector(
                              onTap: () => onItemTapped(0),
                              child: SvgPicture.asset(
                                'assets/images/home.svg', // Placeholder: replace with your icon path
                                width: 20,
                                height: 20,
                                color:
                                    selectedIndex == 0
                                        ? const Color(0xFFD96C07)
                                        : null,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 24,
                          child: Container(
                            width: 55,
                            child: Text(
                              'Home',
                              style: TextStyle(
                                fontSize: 10, // Reduced to fit
                                fontFamily: 'Inter Display',
                                fontWeight:
                                    selectedIndex == 0
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                height: 1.80,
                                color:
                                    selectedIndex == 0
                                        ? const Color(0xFFD96C07)
                                        : const Color(0xFF8C8885),
                              ),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 43), // Spacing: 43 between containers
                  // Grievances
                  Container(
                    width: 55,
                    height: 50,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          top: 0,
                          child: Center(
                            child: GestureDetector(
                              onTap: () => onItemTapped(1),
                              child: SvgPicture.asset(
                                'assets/images/grievances.svg', // Placeholder: replace with your icon path
                                width: 20,
                                height: 20,
                                color:
                                    selectedIndex == 1
                                        ? const Color(0xFFD96C07)
                                        : null,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 24,
                          child: Container(
                            width: 55,
                            child: Text(
                              'Grievances',
                              style: TextStyle(
                                fontSize: 10, // Reduced to fit
                                fontFamily: 'Inter Display',
                                fontWeight:
                                    selectedIndex == 1
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                height: 1.80,
                                color:
                                    selectedIndex == 1
                                        ? const Color(0xFFD96C07)
                                        : const Color(0xFF8C8885),
                              ),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 43), // Spacing: 43 between containers
                  // Notifications
                  Container(
                    width: 55,
                    height: 50,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          top: 0,
                          child: Center(
                            child: GestureDetector(
                              onTap: () => onItemTapped(2),
                              child: SvgPicture.asset(
                                'assets/images/notifications.svg', // Placeholder: replace with your icon path
                                width: 20,
                                height: 20,
                                color:
                                    selectedIndex == 2
                                        ? const Color(0xFFD96C07)
                                        : null,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 24,
                          child: Container(
                            width: 65,
                            child: Text(
                              'Notifications',
                              style: TextStyle(
                                fontSize: 10, // Reduced to fit
                                fontFamily: 'Inter Display',
                                fontWeight:
                                    selectedIndex == 2
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                height: 1.80,
                                color:
                                    selectedIndex == 2
                                        ? const Color(0xFFD96C07)
                                        : const Color(0xFF8C8885),
                              ),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 43), // Spacing: 43 between containers
                  // Profile
                  Container(
                    width: 55,
                    height: 50,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          top: 0,
                          child: Center(
                            child: GestureDetector(
                              onTap: () => onItemTapped(3),
                              child: SvgPicture.asset(
                                'assets/images/profile.svg', // Placeholder: replace with your icon path
                                width: 20,
                                height: 20,
                                color:
                                    selectedIndex == 3
                                        ? const Color(0xFFD96C07)
                                        : null,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 24,
                          child: Container(
                            width: 55,
                            child: Text(
                              'Profile',
                              style: TextStyle(
                                fontSize: 10, // Reduced to fit
                                fontFamily: 'Inter Display',
                                fontWeight:
                                    selectedIndex == 3
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                height: 1.80,
                                color:
                                    selectedIndex == 3
                                        ? const Color(0xFFD96C07)
                                        : const Color(0xFF8C8885),
                              ),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
