import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'bottomNavBar.dart';
import 'home_page.dart';
import 'notif.dart';
import 'profile.dart';
import 'update_page.dart';

// Define DropdownData class for type safety
class DropdownData {
  final String label;
  final List<String> options;

  DropdownData({required this.label, required this.options});
}

class GrievancesScreen extends StatefulWidget {
  const GrievancesScreen({super.key});

  @override
  _GrievancesScreenState createState() => _GrievancesScreenState();
}

class _GrievancesScreenState extends State<GrievancesScreen> {
  String? selectedStatus;
  String? selectedDate;
  bool _isSearchBarVisible = false;
  bool _isScrolled = false;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> grievanceData = [];
  bool isLoading = true;
  String? errorMessage;
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    fetchGrievances();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      _isScrolled = _scrollController.offset > 0;
    });
  }

  void _toggleSearchBar() {
    setState(() {
      _isSearchBarVisible = !_isSearchBarVisible;
      if (!_isSearchBarVisible) {
        _searchController.clear();
      }
    });
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
        print('Raw API Data: $data'); // Debug: Log unfiltered data
        setState(() {
          grievanceData =
              data
                  .where((item) => [1, 2, 3].contains(item['concern_status']))
                  .map((item) {
                    print('Processing item: $item'); // Debug: Log each item
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
        return 'On Hold';
      case '2':
        return 'Accepted';
      case '3':
        return 'Resolved';
      default:
        return 'On Hold';
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
        return true; // Show all dates when no filter or 'All' is selected
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

  bool _filterBySearch(Map<String, dynamic> grievance) {
    final searchQuery = _searchController.text.toLowerCase();
    if (searchQuery.isEmpty) return true;
    return (grievance['statusCode']?.toLowerCase().contains(searchQuery) ??
            false) ||
        (grievance['title']?.toLowerCase().contains(searchQuery) ?? false) ||
        (grievance['location']?.toLowerCase().contains(searchQuery) ?? false);
  }

  Map<String, Color> getStatusBadgeColors(String status) {
    switch (status) {
      case 'On Hold':
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                        (context) =>
                            UpdatePage(data: Map<String, String>.from(data)),
                  ),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'View Details',
                    style: TextStyle(
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

  void onDropdownChanged(String label, String? value) {
    setState(() {
      if (label == 'Status') {
        selectedStatus = value == 'All' ? null : value;
      } else if (label == 'Date') {
        selectedDate = value == 'All' ? null : value;
      }
    });
  }

  Widget buildSearchBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFE1E0DF)),
          borderRadius: BorderRadius.circular(8),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x0C101828),
            blurRadius: 2,
            offset: Offset(0, 1),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/images/search.svg', width: 20, height: 20),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() {}),
              decoration: const InputDecoration(
                hintText: 'Search Grievances by ID, Title, area...',
                hintStyle: TextStyle(
                  color: Color(0xFFC4C2C0),
                  fontSize: 16,
                  fontFamily: 'Inter Display',
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                ),
                border: InputBorder.none,
              ),
              style: const TextStyle(
                color: Color(0xFF030100),
                fontSize: 16,
                fontFamily: 'Inter Display',
                fontWeight: FontWeight.w400,
                height: 1.50,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDropdownButtons(List<DropdownData> dropdowns) {
    const dropdownTextStyle = TextStyle(
      color: Color(0xFF030100),
      fontSize: 14,
      fontFamily: 'Inter Display',
      fontWeight: FontWeight.w400,
      height: 1.57,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 24),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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
                      constraints: const BoxConstraints.tightFor(width: null),
                      offset: const Offset(0, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: Color(0xFFA8A5A2)),
                      ),
                      color: Colors.white.withOpacity(0.95),
                      elevation: 2,
                      itemBuilder:
                          (context) =>
                              dropdown.options.map((String value) {
                                return PopupMenuItem<String>(
                                  value: value,
                                  height: 48,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  child: Text(value, style: dropdownTextStyle),
                                );
                              }).toList(),
                      onSelected:
                          (value) => onDropdownChanged(dropdown.label, value),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final dropdowns = [
      DropdownData(
        label: 'Status',
        options: ['All', 'On Hold', 'Accepted', 'Resolved'],
      ),
      DropdownData(
        label: 'Date',
        options: ['All', 'Today', 'This Week', 'Last Month', 'Long Time Ago'],
      ),
    ];

    final filteredGrievanceData =
        grievanceData.where((data) {
          final statusMatch =
              selectedStatus == null ||
              selectedStatus == 'All' ||
              data['status'] == selectedStatus;
          final dateMatch = _filterByDate(data);
          final searchMatch = _filterBySearch(data);
          print(
            'Grievance: ${data['statusCode']}, Status Match: $statusMatch, Date Match: $dateMatch, Search Match: $searchMatch',
          ); // Debug
          return statusMatch && dateMatch && searchMatch;
        }).toList();

    print('Filtered Grievances: $filteredGrievanceData'); // Debug

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: fetchGrievances,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: _GrievancesSliverAppBarDelegate(
                  expandedHeight: 310,
                  isScrolled: _isScrolled,
                  isSearchBarVisible: _isSearchBarVisible,
                  toggleSearchBar: _toggleSearchBar,
                  searchBarWidget: buildSearchBar(),
                  dropdownButtonsWidget: buildDropdownButtons(dropdowns),
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
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    isLoading
                        ? [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        ]
                        : errorMessage != null
                        ? [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Column(
                              children: [
                                Text(
                                  errorMessage!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Inter Display',
                                    color: Color(0xFF8C8885),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: fetchGrievances,
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          ),
                        ]
                        : filteredGrievanceData.isEmpty
                        ? [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              'No grievances match the selected filters',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Inter Display',
                                color: Color(0xFF8C8885),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ]
                        : filteredGrievanceData
                            .map(
                              (data) => Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: buildGrievanceTile(data),
                              ),
                            )
                            .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 1,
        onItemTapped: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const DashboardPage()),
            );
          } else if (index == 1) {
            // Already on GrievancesScreen
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationsPage(),
              ),
            );
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

class _GrievancesSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final bool isScrolled;
  final bool isSearchBarVisible;
  final VoidCallback toggleSearchBar;
  final Widget searchBarWidget;
  final Widget dropdownButtonsWidget;
  final VoidCallback onBackPressed;

  _GrievancesSliverAppBarDelegate({
    required this.expandedHeight,
    required this.isScrolled,
    required this.isSearchBarVisible,
    required this.toggleSearchBar,
    required this.searchBarWidget,
    required this.dropdownButtonsWidget,
    required this.onBackPressed,
  });

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => isSearchBarVisible ? 200 : 120;

  @override
  bool shouldRebuild(covariant _GrievancesSliverAppBarDelegate oldDelegate) {
    return expandedHeight != oldDelegate.expandedHeight ||
        isScrolled != oldDelegate.isScrolled ||
        isSearchBarVisible != oldDelegate.isSearchBarVisible;
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
    final double titleTopPosition = 20 + (72 - 20) * visibilityPercentage;
    final FontWeight titleFontWeight =
        visibilityPercentage > 0.5 ? FontWeight.w600 : FontWeight.w500;

    final bool isCollapsed = shrinkOffset > 0;

    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Positioned(
            top: 20,
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
                          'Grievances',
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
                  onTap: isCollapsed ? toggleSearchBar : onBackPressed,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      isCollapsed ? Icons.search : Icons.close,
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
                child: const SizedBox(
                  width: 335,
                  child: Text(
                    'Grievances',
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
          ),
          Positioned(
            left: 20,
            top: 112,
            child: AnimatedOpacity(
              opacity: visibilityPercentage,
              duration: const Duration(milliseconds: 300),
              child: Visibility(
                visible: visibilityPercentage > 0.1,
                child: const SizedBox(
                  width: 335,
                  child: Text(
                    'Manage, Resolve an respond to citizen\nconcerns',
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
          Positioned(
            left: 20,
            right: 20,
            top: 188,
            child: AnimatedOpacity(
              opacity: visibilityPercentage,
              duration: const Duration(milliseconds: 300),
              child: Visibility(
                visible: visibilityPercentage > 0.1,
                child: searchBarWidget,
              ),
            ),
          ),
          if (isSearchBarVisible && isCollapsed)
            Positioned(left: 20, right: 20, top: 70, child: searchBarWidget),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: dropdownButtonsWidget,
          ),
        ],
      ),
    );
  }
}
