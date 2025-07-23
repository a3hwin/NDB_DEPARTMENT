import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'bottomNavBar.dart';
import 'home_page.dart';
import 'grievancesPage.dart';
import 'profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'update_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './baseUrl.dart';
import 'package:http/http.dart' as http;

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  List<Map<String, dynamic>> notifications = [];
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadNotifications();
  }

  void _onScroll() {
    setState(() {
      _isScrolled = _scrollController.offset > 0;
    });
  }

  Future<void> _loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final storedNotifications = prefs.getStringList('notifications') ?? [];
    setState(() {
      notifications =
          storedNotifications
              .map((n) => Map<String, dynamic>.from(jsonDecode(n)))
              .toList();
    });
  }

  Future<void> _onNotificationTap(Map<String, dynamic> notification) async {
    final concernId = int.tryParse(notification['concernId'] ?? '');
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
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Grievance not found')));
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

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget buildNotificationTile(Map<String, dynamic> data) {
      const double icon3Size = 20.0;
      final double iconSize =
          data['iconPath'] == 'assets/images/icon3.svg' ? icon3Size : 14.0;

      return GestureDetector(
        onTap: () => _onNotificationTap(data),
        child: Container(
          width: 335,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
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
                  data['iconPath'] ?? 'assets/images/icon1.svg',
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
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
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
            const SliverToBoxAdapter(child: SizedBox(height: 48)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    notifications.isEmpty
                        ? const Center(
                          child: Text(
                            'No notifications available',
                            style: TextStyle(
                              color: Color(0xFF8C8885),
                              fontSize: 16,
                              fontFamily: 'Inter Display',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )
                        : ListView.separated(
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
            // Already on NotificationsPage
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
  double get minExtent => 48;

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
          Positioned(
            top: 8,
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
