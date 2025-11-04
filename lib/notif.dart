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
    final token = await _storage.read(key: 'authToken');

    print('Loading notifications from storage: ${storedNotifications.length}');
    print('Stored notifications raw: $storedNotifications');

    if (token == null) {
      print('No auth token found');
      setState(() => notifications = []);
      return;
    }

    try {
      List<Map<String, dynamic>> loadedNotifications =
          storedNotifications
              .map((n) => Map<String, dynamic>.from(jsonDecode(n)))
              .toList();

      final url = '$baseUrl/api/app/department/display-all-concerns/$token';
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> concerns = jsonDecode(response.body);
        print('Fetched ${concerns.length} concerns');

        loadedNotifications =
            loadedNotifications.where((notification) {
              final matchingConcern = concerns.firstWhere(
                (c) =>
                    c['id'].toString() == notification['concernId'].toString(),
                orElse: () => null,
              );

              if (matchingConcern == null) {
                print(
                  'No matching concern found for notification concernId: ${notification['concernId']}',
                );
                return false;
              }

              final status = matchingConcern['concern_status'].toString();
              print('Concern ${notification['concernId']} status: $status');
              if (status == '1') {
                notification['status'] = _mapStatus(
                  matchingConcern['concern_status'],
                );
                notification['concernDetails'] = matchingConcern;
                return true;
              }
              print(
                'Filtered out concern ${notification['concernId']} with status: $status',
              );
              return false;
            }).toList();

        loadedNotifications.sort(
          (a, b) => DateTime.parse(
            b['timestamp'],
          ).compareTo(DateTime.parse(a['timestamp'])),
        );

        print('Filtered notifications count: ${loadedNotifications.length}');
        print('Filtered notifications: $loadedNotifications');

        setState(() {
          notifications = loadedNotifications;
        });

        await prefs.setStringList(
          'notifications',
          loadedNotifications.map((n) => jsonEncode(n)).toList(),
        );
      } else {
        print('Failed to fetch concerns: ${response.statusCode}');
        setState(() => notifications = []);
      }
    } catch (e) {
      print('Error loading notifications: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading notifications: $e')),
        );
      }
      setState(() => notifications = []);
    }
  }

  Future<void> _clearNotifications() async {
    setState(() {
      notifications = [];
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('notifications', []);
  }

  String _formatTimeDifference(String timestamp) {
    try {
      final notificationTime = DateTime.parse(timestamp);
      final now = DateTime.now();
      final difference = now.difference(notificationTime);

      if (difference.inDays >= 1) {
        return '${difference.inDays} days ago';
      } else {
        final hours = difference.inHours;
        return hours > 0 ? '$hours hours ago' : 'Just now';
      }
    } catch (e) {
      return 'Unknown time';
    }
  }

  Future<void> _onNotificationTap(Map<String, dynamic> notification) async {
    if (notification['concernId'] == null) return;

    final token = await _storage.read(key: 'authToken');
    if (token == null) return;

    try {
      final url = '$baseUrl/api/app/department/display-all-concerns/$token';
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 && mounted) {
        final List<dynamic> concerns = jsonDecode(response.body);
        final concern = concerns.firstWhere(
          (c) => c['id'].toString() == notification['concernId'].toString(),
          orElse: () => null,
        );

        if (concern != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => UpdatePage(
                    data: {
                      'id': concern['id'].toString(),
                      'title': concern['concern_title']?.toString() ?? '',
                      'description':
                          concern['concern_description']?.toString() ?? '',
                      'photos': concern['photos']?.toString() ?? '',
                      'address': concern['location']?.toString() ?? '',
                      'status': _mapStatus(concern['concern_status']),
                      'statusCode': concern['refrence_id']?.toString() ?? '',
                      'reporter':
                          concern['raised_citizen_name']?.toString() ?? '',
                      'contact_number':
                          concern['citizen_mobile']?.toString() ?? '',
                      'email': concern['citizen_email']?.toString() ?? '',
                      'concern_status': concern['concern_status'].toString(),
                      'timestamp': _formatTimestamp(
                        concern['created_date']?.toString() ?? '',
                        concern['created_time']?.toString() ?? '',
                      ),
                    },
                  ),
            ),
          );
        }
      }
    } catch (e) {
      print('Error handling notification tap: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading concern details: $e')),
        );
      }
    }
  }

  String _mapStatus(dynamic status) {
    switch (status?.toString()) {
      case '1':
        return 'On Hold';
      case '2':
        return 'Accepted';
      case '3':
        return 'Resolved';
      default:
        return 'On Hold';
    }
  }

  String _formatTimestamp(String date, String time) {
    if (date.isEmpty || time.isEmpty) return '';
    try {
      final dateTime = DateTime.parse('$date $time');
      final month =
          [
            'Jan',
            'Feb',
            'Mar',
            'Apr',
            'May',
            'Jun',
            'Jul',
            'Aug',
            'Sep',
            'Oct',
            'Nov',
            'Dec',
          ][dateTime.month - 1];
      final day = dateTime.day.toString().padLeft(2, '0');
      final year = dateTime.year;
      final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
      final minute = dateTime.minute.toString().padLeft(2, '0');
      final period = dateTime.hour >= 12 ? 'PM' : 'AM';
      return '$month $day, $year | $hour:$minute $period';
    } catch (e) {
      return '$date | $time';
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
    Widget buildNotificationTile(Map<String, dynamic> notification) {
      return GestureDetector(
        onTap: () => _onNotificationTap(notification),
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
                  'assets/images/icon1.svg',
                  width: 14.0,
                  height: 14.0,
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
                        notification['title']?.toString() ?? 'No Title',
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
                        notification['description']?.toString() ??
                            'No Description',
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
                        _formatTimeDifference(
                          notification['timestamp']?.toString() ?? '',
                        ),
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
      body: Stack(
        children: [
          SafeArea(
            child: RefreshIndicator(
              onRefresh: _loadNotifications,
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
                                    (context, index) =>
                                        const SizedBox(height: 16),
                                itemBuilder:
                                    (context, index) => buildNotificationTile(
                                      notifications[index],
                                    ),
                              ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: _clearNotifications,
              backgroundColor: Colors.white,
              child: SvgPicture.asset(
                'assets/images/Dustbin.svg',
                width: 24,
                height: 24,
              ),
            ),
          ),
        ],
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
                          'ಅಧಿಸೂಚನೆಗಳು',
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
                  'Stay update with your assigned grievances\nand system alerts',
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
