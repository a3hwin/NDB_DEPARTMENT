import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'bottomNavBar.dart';
import 'home_page.dart';
import 'notif.dart';
import 'profile.dart';

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
  String? selectedCategory;
  String? selectedArea;
  String? selectedDate;
  bool _isSearchBarVisible = false;
  bool _isScrolled = false;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Sample data for grievance tiles
  final List<Map<String, String>> grievanceData = [
    {
      'title': 'Water Supply Interruption',
      'category': 'Water',
      'status': 'New',
      'statusCode': 'SC-2025-2738',
      'reporter': 'Shalini Verma',
      'location': 'East Sector, Doddaballapura',
      'timestamp': 'Jun 10, 2025 | 03:17 PM',
    },
    {
      'title': 'Electricity Outage',
      'category': 'Electricity',
      'status': 'In Progress',
      'statusCode': 'SC-2025-2739',
      'reporter': 'Ravi Kumar',
      'location': 'West Sector, Doddaballapura',
      'timestamp': 'Jun 11, 2025 | 10:00 AM',
    },
    {
      'title': 'Pothole on MG Road',
      'category': 'Infrastructure',
      'status': 'Resolved',
      'statusCode': 'SC-2025-2740',
      'reporter': 'Anita Singh',
      'location': 'North Sector, Doddaballapura',
      'timestamp': 'Jun 12, 2025 | 02:45 PM',
    },
    {
      'title': 'Garbage Collection Delay',
      'category': 'Infrastructure',
      'status': 'Rejected',
      'statusCode': 'SC-2025-2741',
      'reporter': 'Vikram Patel',
      'location': 'South Sector, Doddaballapura',
      'timestamp': 'Jun 13, 2025 | 09:30 AM',
    },
    {
      'title': 'Street lights not working',
      'category': 'Water',
      'status': 'Rejected',
      'statusCode': 'SC-2025-2738',
      'reporter': 'Shalini Verma',
      'location': 'East Sector, Doddaballapura',
      'timestamp': 'May 27, 2025 | 03:17 PM',
    },
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
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
    });
  }

  // Function to get colors for status badge
  Map<String, Color> getStatusBadgeColors(String status) {
    switch (status) {
      case 'New':
        return {
          'background': const Color(0xFFE6F3FF),
          'text': const Color(0xFF007AFF),
        };
      case 'In Progress':
        return {
          'background': const Color(0xFFFFF7E6),
          'text': const Color(0xFFD97706),
        };
      case 'Resolved':
        return {
          'background': const Color(0xFFE6F9E9),
          'text': const Color(0xFF036B1E),
        };
      case 'Rejected':
        return {
          'background': const Color(0xFFFFE6E6),
          'text': const Color(0xFFB91C1C),
        };
      default:
        return {
          'background': const Color(0xFFDBEAFE),
          'text': const Color(0xFF007AFF),
        };
    }
  }

  // Function to get colors for category badge
  Map<String, Color> getCategoryBadgeColors(String category) {
    switch (category) {
      case 'Water':
        return {
          'background': const Color(0xFFE6F0FF),
          'text': const Color(0xFF1E40AF),
        };
      case 'Electricity':
        return {
          'background': const Color(0xFFFFF0E6),
          'text': const Color(0xFFD97706),
        };
      case 'Infrastructure':
        return {
          'background': const Color(0xFFE6E6E6),
          'text': const Color(0xFF374151),
        };
      default:
        return {
          'background': const Color(0xFFFFF3EB),
          'text': const Color(0xFFD96C07),
        };
    }
  }

  // Widget for building grievance tiles
  Widget buildGrievanceTile(Map<String, String> data) {
    final statusColors = getStatusBadgeColors(data['status']!);
    final categoryColors = getCategoryBadgeColors(data['category']!);

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
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: ShapeDecoration(
                    color: categoryColors['background'],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    data['category']!,
                    style: TextStyle(
                      color: categoryColors['text'],
                      fontSize: 12,
                      fontFamily: 'Inter Display',
                      fontWeight: FontWeight.w400,
                      height: 1.67,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
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
              ],
            ),
          ),
          Positioned(
            left: 16,
            top: 88,
            child: SizedBox(
              width: 303,
              child: Text(
                '${data['reporter']} • ${data['location']}',
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
            child: Container(
              width: 303,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    data['timestamp']!,
                    style: const TextStyle(
                      color: Color(0xFF8C8885),
                      fontSize: 12,
                      fontFamily: 'Inter Display',
                      fontWeight: FontWeight.w400,
                      height: 1.67,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (data['title'] == 'Pothole on MG Road') {
                      } else {
                        print('View Details pressed for ${data['title']}');
                      }
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      alignment: Alignment.centerRight,
                    ),
                    child: const Text(
                      'View Details >',
                      style: TextStyle(
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
          ),
        ],
      ),
    );
  }

  void onDropdownChanged(String label, String? value) {
    setState(() {
      if (label == 'Status') {
        selectedStatus = value == 'All' ? null : value;
      } else if (label == 'Category') {
        selectedCategory = value == 'All' ? null : value;
      } else if (label == 'Area') {
        selectedArea = value == 'All' ? null : value;
      } else if (label == 'Date') {
        selectedDate = value == 'All' ? null : value;
      }
    });
  }

  // Build the search bar widget with a TextField
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
          SvgPicture.asset(
            'assets/images/search.svg', // Ensure this path is correct
            width: 20,
            height: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search grievances by ID, Title or area...',
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

  // Build dropdown buttons widget
  Widget buildDropdownButtons(List<DropdownData> dropdowns) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children:
              dropdowns.map((DropdownData dropdown) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 1,
                          color: Color(0xFFA8A5A2),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: DropdownButton<String>(
                      value:
                          dropdown.label == 'Status'
                              ? selectedStatus
                              : dropdown.label == 'Category'
                              ? selectedCategory
                              : dropdown.label == 'Area'
                              ? selectedArea
                              : selectedDate,
                      hint: Text(
                        dropdown.label,
                        style: const TextStyle(
                          color: Color(0xFF030100),
                          fontSize: 14,
                          fontFamily: 'Inter Display',
                          fontWeight: FontWeight.w400,
                          height: 1.57,
                        ),
                      ),
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Color(0xFF8C8885),
                      ),
                      underline: const SizedBox(),
                      isDense: true,
                      items:
                          dropdown.options.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: const TextStyle(
                                  color: Color(0xFF030100),
                                  fontSize: 14,
                                  fontFamily: 'Inter Display',
                                  fontWeight: FontWeight.w400,
                                  height: 1.67,
                                ),
                              ),
                            );
                          }).toList(),
                      onChanged: (value) {
                        onDropdownChanged(
                          dropdown.label,
                          value == 'All' ? null : value,
                        );
                      },
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
        options: ['All', 'New', 'In Progress', 'Resolved', 'Rejected'],
      ),
      DropdownData(
        label: 'Category',
        options: ['All', 'Water', 'Electricity', 'Infrastructure'],
      ),
      DropdownData(label: 'Area', options: ['All', 'Downtown', 'Suburbs']),
      DropdownData(
        label: 'Date',
        options: ['All', 'Today', 'This Week', 'Last Month', 'Long Time Ago'],
      ),
    ];

    // Filter the grievance data based on selected filters
    final filteredGrievanceData =
        grievanceData.where((data) {
          final statusMatch =
              selectedStatus == null || data['status'] == selectedStatus;
          final categoryMatch =
              selectedCategory == null || data['category'] == selectedCategory;
          // Area and Date filters are placeholders for now
          return statusMatch && categoryMatch;
        }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Custom SliverAppBar implementation
            SliverPersistentHeader(
              pinned: true,
              delegate: _GrievancesSliverAppBarDelegate(
                expandedHeight: 290,
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
            // 24px spacing between app bar and first tile
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            // Grievance List
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  filteredGrievanceData
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
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 1,
        onItemTapped: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const DashboardPage()),
            );
          } else if (index == 1) {
            // Already on GrievancesScreen, do nothing
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

// Custom SliverPersistentHeaderDelegate for complex AppBar behavior
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
          // Top row with back and close/search icons
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

                // Close/Search icon
                GestureDetector(
                  onTap:
                      isCollapsed
                          ? toggleSearchBar
                          : () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DashboardPage(),
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
                      isCollapsed ? Icons.search : Icons.close,
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
                    'Grievances',
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
                    'Manage, resolve and respond to citizen concerns',
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

          // Search bar in expanded state - with increased spacing
          Positioned(
            left: 20,
            right: 20,
            top: 164, // Increased spacing from subtitle (112 + 16 + 36)
            child: AnimatedOpacity(
              opacity: visibilityPercentage,
              duration: const Duration(milliseconds: 300),
              child: Visibility(
                visible: visibilityPercentage > 0.1,
                child: searchBarWidget,
              ),
            ),
          ),

          // Search bar in collapsed state (only when toggled)
          if (isSearchBarVisible && isCollapsed)
            Positioned(
              left: 20,
              right: 20,
              top: 66, // Below the app bar top section
              child: searchBarWidget,
            ),

          // Dropdown buttons
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
