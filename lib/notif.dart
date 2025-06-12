import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'bottomNavBar.dart';
import 'home_page.dart';
import 'grievancesPage.dart';
import 'profile.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
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
    // Sample notification data with placeholder icon paths
    final List<Map<String, dynamic>> notifications = [
      {
        'title': 'New Grievance assigned',
        'description':
            'You have been assigned a new water supply grievance in east sector',
        'timestamp': '2 hours ago',
        'iconPath': 'assets/images/icon1.svg',
      },
      {
        'title': 'Status Updated',
        'description':
            'Officer Sharma updated the status of a sewage issue to “In progress”.',
        'timestamp': '3 hours ago',
        'iconPath': 'assets/images/icon2.svg',
      },
      {
        'title': 'Grievance Resolved',
        'description': 'Pothole at MG road has been as resolved.',
        'timestamp': '1 day ago',
        'iconPath': 'assets/images/icon3.svg',
      },
      {
        'title': 'Grievance Rejected',
        'description': 'Pothole at MG road has been as resolved.',
        'timestamp': '1 day ago',
        'iconPath': 'assets/images/icon4.svg',
      },
      {
        'title': 'System notification',
        'description':
            'Scheduled maintenance this weekend. The system will be down from 10 PM to 2 AM.',
        'timestamp': '2 day ago',
        'iconPath': 'assets/images/icon5.svg',
      },
    ];

    // Widget to build a notification tile
    Widget buildNotificationTile(Map<String, dynamic> data) {
      const double icon3Size = 20.0;
      final double iconSize =
          data['iconPath'] == 'assets/images/icon3.svg' ? icon3Size : 14.0;

      return Container(
        width: 335,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          shadows: const [
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 20,
              offset: Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: const Color(0xFFF8F8F8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(204.08),
                ),
              ),
              child: SvgPicture.asset(
                data['iconPath'],
                width: iconSize,
                height: iconSize,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 279,
                    child: Text(
                      data['title'],
                      style: const TextStyle(
                        color: Color(0xFF030100),
                        fontSize: 14,
                        fontFamily: 'Inter Display',
                        fontWeight: FontWeight.w400,
                        height: 1.57,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: 279,
                    child: Text(
                      data['description'],
                      style: const TextStyle(
                        color: Color(0xFF8C8885),
                        fontSize: 14,
                        fontFamily: 'Inter Display',
                        fontWeight: FontWeight.w400,
                        height: 1.57,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: 279,
                    child: Text(
                      data['timestamp'],
                      style: const TextStyle(
                        color: Color(0xFF8C8885),
                        fontSize: 12,
                        fontFamily: 'Inter Display',
                        fontWeight: FontWeight.w400,
                        height: 1.67,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Custom SliverPersistentHeader for the header
            SliverPersistentHeader(
              pinned: true,
              delegate: _NotificationsSliverAppBarDelegate(
                expandedHeight: 184,
                isScrolled: _isScrolled,
                onBackPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DashboardPage(),
                    ),
                  );
                },
              ),
            ),
            // Increased spacing to match minExtent and prevent clipping
            const SliverToBoxAdapter(child: SizedBox(height: 48)),
            // Notification Tiles
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: notifications.length,
                      separatorBuilder:
                          (context, index) => const SizedBox(height: 16),
                      itemBuilder:
                          (context, index) =>
                              buildNotificationTile(notifications[index]),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 2,
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
            // Already on NotificationsPage, do nothing
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
          }
        },
      ),
    );
  }
}

// Custom SliverPersistentHeaderDelegate for Notifications header
class _NotificationsSliverAppBarDelegate
    extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final bool isScrolled;
  final VoidCallback onBackPressed;

  _NotificationsSliverAppBarDelegate({
    required this.expandedHeight,
    required this.isScrolled,
    required this.onBackPressed,
  });

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => 48; // Minimum height when collapsed

  @override
  bool shouldRebuild(covariant _NotificationsSliverAppBarDelegate oldDelegate) {
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

    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          // Top row with back button and collapsed title
          Positioned(
            top: 8,
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
                // Title in collapsed state
                AnimatedOpacity(
                  opacity: 1 - visibilityPercentage,
                  duration: const Duration(milliseconds: 300),
                  child: Offstage(
                    offstage: 1 - visibilityPercentage <= 0.0,
                    child: const Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Notifications',
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
              ],
            ),
          ),
          // Title in expanded state
          Positioned(
            left: 20,
            top: 72,
            child: Offstage(
              offstage: visibilityPercentage <= 0.0,
              child: const SizedBox(
                width: 335,
                child: Text(
                  'Notifications',
                  style: TextStyle(
                    color: Color(0xFF030100),
                    fontSize: 24,
                    fontFamily: 'Inter Display',
                    fontWeight: FontWeight.w600,
                    height: 1.33,
                  ),
                ),
              ),
            ),
          ),
          // Subtitle
          Positioned(
            left: 20,
            top: 112,
            child: Offstage(
              offstage: visibilityPercentage <= 0.0,
              child: const SizedBox(
                width: 335,
                child: Text(
                  'Stay updated with your assigned grievances and system alerts',
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
        ],
      ),
    );
  }
}
