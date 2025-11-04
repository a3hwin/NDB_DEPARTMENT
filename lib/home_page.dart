import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'bottomNavBar.dart';
import 'grievancesPage.dart';
import 'notif.dart';
import 'profile.dart';
import 'update_page.dart';

// Define DropdownData class for type safety
class DropdownData {
  final String label;
  final List<String> options;

  DropdownData({required this.label, required this.options});
}

// Custom SliverPersistentHeaderDelegate for Dashboard
class _DashboardSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;

  _DashboardSliverAppBarDelegate({required this.expandedHeight});

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
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

    final double titleTopPosition = 20 + (52 - 20) * visibilityPercentage;

    return Container(
      color: Colors.white,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 20,
            top: titleTopPosition,
            child: const Text(
              'Dashboard',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter Display',
                height: 1.33,
                color: Color(0xFF030100),
              ),
            ),
          ),
          Positioned(
            left: 20,
            top: 92,
            child: AnimatedOpacity(
              opacity: visibilityPercentage,
              duration: const Duration(milliseconds: 300),
              child: const Text(
                'Welcome Admin, here is what’s happening today.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Inter Display',
                  color: Color(0xFF8C8885),
                  height: 1.50,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String? selectedStatus;
  String? selectedDate;
  int selectedIndex = 0;
  List<Map<String, dynamic>> grievanceData = [];
  bool isLoading = true;
  String? errorMessage;
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    fetchGrievances();
  }

  Future<void> fetchGrievances() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final token = await _storage.read(key: 'authToken');
      print('Token: $token'); // Debug: Log the token
      if (token == null || token.isEmpty) {
        setState(() {
          errorMessage = 'No authentication token found';
          isLoading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No authentication token found')),
          );
        }
        return;
      }

      final response = await http.get(
        Uri.parse(
          'https://ndb-apis-69em6.ondigitalocean.app/api/app/department/display-all-concerns/$token',
        ),
        headers: {'Content-Type': 'application/json'},
      );

      print('API Response Status: ${response.statusCode}'); // Debug: Log status
      print('API Response Body: ${response.body}'); // Debug: Log response body

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          grievanceData =
              data
                  .where((item) => [1, 2, 3].contains(item['concern_status']))
                  .map((item) {
                    return {
                      'id': item['id']?.toString(),
                      'title': (item['concern_title'] ?? '').toString(),
                      'status': mapStatus(
                        (item['concern_status'] ?? 1).toString(),
                      ),
                      'statusCode': (item['refrence_id'] ?? '').toString(),
                      'reporter':
                          (item['raised_citizen_name'] ?? '').toString(),
                      'location': (item['citizen_locality'] ?? '').toString(),
                      'address': (item['location'] ?? '').toString(),
                      'timestamp': formatTimestamp(
                        (item['created_date'] ?? '').toString(),
                        (item['created_time'] ?? '').toString(),
                      ),
                      'description':
                          (item['concern_description'] ?? '').toString(),
                      'photos': (item['photos'] ?? '').toString(),
                      'contact_number':
                          (item['citizen_mobile'] ?? '').toString(),
                      'email': (item['citizen_email'] ?? '').toString(),
                      'epid_id': (item['citizen_epic_no'] ?? '').toString(),
                      'created_date': (item['created_date'] ?? '').toString(),
                    };
                  })
                  .toList();
          isLoading = false;
        });
        print('Grievance Data: $grievanceData'); // Debug: Log parsed data
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 8),
                  Text('Grievances refreshed successfully'),
                ],
              ),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        setState(() {
          errorMessage = 'Failed to load grievances: ${response.statusCode}';
          isLoading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(errorMessage!)));
        }
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching grievances: $e';
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage!)));
      }
    }
  }

  String mapStatus(String apiStatus) {
    switch (apiStatus) {
      case '1':
        return 'Assigned';
      case '2':
        return 'Accepted';
      case '3':
        return 'Resolved';
      default:
        return 'Assigned';
    }
  }

  String formatTimestamp(String date, String time) {
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
      print('Timestamp Format Error: $e, Date: $date, Time: $time'); // Debug
      return '$date | $time';
    }
  }

  bool _filterByDate(Map<String, dynamic> grievance) {
    final createdDateStr = grievance['created_date'] as String;
    if (createdDateStr.isEmpty) {
      print(
        'Empty created_date for grievance: ${grievance['statusCode']}',
      ); // Debug
      return false;
    }

    try {
      final createdDate = DateTime.parse(createdDateStr);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      print(
        'Filtering: ${grievance['statusCode']}, created_date: $createdDateStr, selectedDate: $selectedDate',
      ); // Debug

      if (selectedDate == null || selectedDate == 'All') {
        return true; // Show all dates when no filter is selected
      }

      switch (selectedDate) {
        case 'Today':
          return createdDate.year == today.year &&
              createdDate.month == today.month &&
              createdDate.day == today.day;
        case 'This Week':
          return now.difference(createdDate).inDays <= 7;
        case 'Last Month':
          return now.difference(createdDate).inDays <= 30;
        case 'Long Time Ago':
          return now.difference(createdDate).inDays > 30;
        default:
          return true;
      }
    } catch (e) {
      print('Date Parse Error for ${grievance['statusCode']}: $e'); // Debug
      return false; // Exclude invalid dates
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    if (index == 0) {
      Navigator.popUntil(context, (route) => route.isFirst);
      return;
    }
    Widget targetPage;
    switch (index) {
      case 1:
        targetPage =
            const GrievancesScreen(); // Fixed: GrievancesScreen to GrievancesPage
        break;
      case 2:
        targetPage = const NotificationsPage();
        break;
      case 3:
        targetPage = const ProfilePage();
        break;
      default:
        return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => targetPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, Color> getStatusBadgeColors(String status) {
      switch (status) {
        case 'Assigned':
          return {
            'background': const Color(0xFFFFE6E6),
            'text': const Color(0xFFB91C1C),
          };
        case 'Accepted':
          return {
            'background': const Color(0xFFFFF7E6),
            'text': const Color(0xFFD97706),
          };
        case 'Resolved':
          return {
            'background': const Color(0xFFDCFCE7),
            'text': const Color(0xFF036B1E),
          };
        default:
          return {
            'background': const Color(0xFFFFE6E6),
            'text': const Color(0xFFB91C1C),
          };
      }
    }

    List<Map<String, dynamic>> filteredGrievances =
        grievanceData.where((grievance) {
          bool statusMatch =
              selectedStatus == null ||
              selectedStatus == 'All' ||
              grievance['status'] == selectedStatus;
          bool dateMatch = _filterByDate(grievance);
          print(
            'Grievance: ${grievance['statusCode']}, Status Match: $statusMatch, Date Match: $dateMatch',
          ); // Debug
          return statusMatch && dateMatch;
        }).toList();

    print('Filtered Grievances: $filteredGrievances'); // Debug

    Widget buildGrievanceTile(Map<String, dynamic> data) {
      final statusColors = getStatusBadgeColors(data['status']!);

      return Container(
        width: 335,
        height: 154,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17.40),
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
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 16,
              top: 56,
              child: Text(
                data['title']!,
                style: const TextStyle(
                  color: Color(0xFF030100),
                  fontSize: 16,
                  fontFamily: 'Inter Display',
                  fontWeight: FontWeight.w500,
                  height: 1.50,
                ),
              ),
            ),
            Positioned(
              left: 16,
              top: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: ShapeDecoration(
                  color: statusColors['background'],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  '${data['status']}: ${data['statusCode']}',
                  style: TextStyle(
                    color: statusColors['text'],
                    fontSize: 12,
                    fontFamily: 'Inter Display',
                    fontWeight: FontWeight.w400,
                    height: 1.67,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 16,
              top: 88,
              child: SizedBox(
                width: 303,
                child: Text(
                  '${data['reporter']?.isEmpty ?? true ? 'N/A' : data['reporter']} • ${data['location']?.isEmpty ?? true ? 'N/A' : data['location']}',
                  style: const TextStyle(
                    color: Color(0xFF8C8885),
                    fontSize: 14,
                    fontFamily: 'Inter Display',
                    fontWeight: FontWeight.w400,
                    height: 1.57,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 16,
              top: 118,
              child: Text(
                data['timestamp']!,
                style: const TextStyle(
                  color: Color(0xFF8C8885),
                  fontSize: 12,
                  fontFamily: 'Inter Display',
                  fontWeight: FontWeight.w400,
                  height: 1.67,
                ),
              ),
            ),
            Positioned(
              left: 240,
              bottom: 16,
              right: 30,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => UpdatePage(
                            data: Map<String, String>.from(
                              data.map(
                                (key, value) => MapEntry(key, value.toString()),
                              ),
                            ),
                          ),
                    ),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'View Details',
                      style: const TextStyle(
                        color: Color(0xFF8C8885),
                        fontSize: 12,
                        fontFamily: 'Inter Display',
                        fontWeight: FontWeight.w400,
                        height: 1.67,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SvgPicture.asset(
                      'assets/images/arrow_right.svg',
                      width: 12,
                      height: 12,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    final dropdowns = [
      DropdownData(
        label: 'Status',
        options: ['All', 'Assigned', 'Accepted', 'Resolved'],
      ),
      DropdownData(
        label: 'Date',
        options: ['All', 'Today', 'This Week', 'Last Month', 'Long Time Ago'],
      ),
    ];

    const dropdownTextStyle = TextStyle(
      color: Color(0xFF030100),
      fontSize: 14,
      fontFamily: 'Inter Display',
      fontWeight: FontWeight.w400,
      height: 1.57,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: fetchGrievances,
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: _DashboardSliverAppBarDelegate(expandedHeight: 120),
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x19000000),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Total Grievances \nRecieved',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Inter Display',
                                        color: Color(0xFF8C8885),
                                        height: 1.67,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      grievanceData.length.toString(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Inter Display',
                                        color: Color(0xFFD97706),
                                        height: 1.2,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 40,
                              color: const Color(0xFFE1E0DF),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Align(
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Total Grievances \nResolved',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Inter Display',
                                        color: Color(0xFF8C8885),
                                        height: 1.67,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      grievanceData
                                          .where(
                                            (g) => g['status'] == 'Resolved',
                                          )
                                          .length
                                          .toString(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Inter Display',
                                        color: Color(0xFF036B1E),
                                        height: 1.2,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Recent Grievances',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter Display',
                              color: Color(0xFF030100),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          GrievancesScreen(), // Fixed: GrievancesScreen to GrievancesPage
                                ),
                              );
                            },
                            child: const Text(
                              'View All',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Inter Display',
                                color: Color(0xFFD96C07),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                              dropdowns.map((DropdownData dropdown) {
                                String? selectedValue;
                                if (dropdown.label == 'Status') {
                                  selectedValue = selectedStatus;
                                } else if (dropdown.label == 'Date') {
                                  selectedValue = selectedDate;
                                }

                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Container(
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                          width: 1,
                                          color: Color(0xFFA8A5A2),
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: PopupMenuButton<String>(
                                      constraints:
                                          const BoxConstraints.tightFor(
                                            width: null,
                                          ),
                                      offset: const Offset(0, 40),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        side: const BorderSide(
                                          color: Color(0xFFA8A5A2),
                                        ),
                                      ),
                                      color: Colors.white.withOpacity(0.95),
                                      elevation: 2,
                                      itemBuilder:
                                          (context) =>
                                              dropdown.options.map((
                                                String value,
                                              ) {
                                                return PopupMenuItem<String>(
                                                  value: value,
                                                  height: 48,
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 4,
                                                      ),
                                                  child: Text(
                                                    value,
                                                    style: dropdownTextStyle,
                                                  ),
                                                );
                                              }).toList(),
                                      onSelected: (value) {
                                        setState(() {
                                          if (dropdown.label == 'Status') {
                                            selectedStatus =
                                                value == 'All' ? null : value;
                                          } else if (dropdown.label == 'Date') {
                                            selectedDate =
                                                value == 'All' ? null : value;
                                          }
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              selectedValue ?? dropdown.label,
                                              style: dropdownTextStyle,
                                            ),
                                            const SizedBox(width: 8),
                                            SvgPicture.asset(
                                              'assets/images/arrow_down.svg',
                                              width: 12,
                                              height: 6.89,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child:
                          isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : errorMessage != null
                              ? Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                ),
                                child: Text(
                                  errorMessage!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Inter Display',
                                    color: Color(0xFF8C8885),
                                  ),
                                ),
                              )
                              : filteredGrievances.isEmpty
                              ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Text(
                                  'No grievances match the selected filters',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Inter Display',
                                    color: Color(0xFF8C8885),
                                  ),
                                ),
                              )
                              : ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: filteredGrievances.length,
                                separatorBuilder:
                                    (context, index) =>
                                        const SizedBox(height: 16),
                                itemBuilder:
                                    (context, index) => buildGrievanceTile(
                                      filteredGrievances[index],
                                    ),
                              ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
