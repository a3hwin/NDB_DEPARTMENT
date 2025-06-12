import 'package:flutter/material.dart';
import 'bottomNavBar.dart'; // Import BottomNavBar
import 'grievancesPage.dart';
import 'notif.dart';
import 'profile.dart';

// Placeholder pages for navigation (move to separate files as needed)
class GrievancesPage extends StatelessWidget {
  const GrievancesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Grievances')),
      body: const Center(child: Text('Grievances Page')),
    );
  }
}

// Define DropdownData class for type safety
class DropdownData {
  final String label;
  final List<String> options;

  DropdownData({required this.label, required this.options});
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String? selectedStatus;
  String? selectedCategory;
  String? selectedArea;
  String? selectedDate;
  int selectedIndex = 0; // Track the selected navigation item (0 for Home)

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    if (index == 0) {
      // Already on DashboardPage (Home), pop to first route if not already
      Navigator.popUntil(context, (route) => route.isFirst);
      return;
    }
    // Navigate to other pages
    Widget targetPage;
    switch (index) {
      case 1:
        targetPage = const GrievancesScreen();
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
    // Use pushReplacement to replace the current screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => targetPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Sample data for Recent Grievances tiles with category and status
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
        'title': 'Pothole on Main Road',
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
    ];

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

    // Filter grievances based on Status and Category
    List<Map<String, String>> filteredGrievances =
        grievanceData.where((grievance) {
          bool statusMatch =
              selectedStatus == null || grievance['status'] == selectedStatus;
          bool categoryMatch =
              selectedCategory == null ||
              grievance['category'] == selectedCategory;
          return statusMatch && categoryMatch;
        }).toList();

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
            // Title
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
            // Badges
            Positioned(
              left: 16,
              top: 16,
              child: Row(
                children: [
                  // Category Badge
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
                  const SizedBox(width: 8), // 8-pixel spacing between badges
                  // Status Badge
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
            // Reporter and Location
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
            // Timestamp and View Details
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
                        // TODO: Implement navigation or action for viewing details
                        print('View Details pressed for ${data['title']}');
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

    // Define dropdowns using DropdownData
    final dropdowns = [
      DropdownData(
        label: 'Status',
        options: ['All', 'New', 'In Progress', 'Resolved', 'Rejected'],
      ),
      DropdownData(
        label: 'Category',
        options: ['All', 'Water', 'Electricity', 'Infrastructure'],
      ),
      DropdownData(label: 'Area', options: ['Downtown', 'Suburbs']),
      DropdownData(
        label: 'Date',
        options: ['Today', 'This Week', 'Last Month', 'Long Time Ago'],
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 48, top: 52),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Dashboard',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter Display',
                        height: 1.33,
                        color: Color(0xFF030100),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Welcome Admin. Here’s what’s happening today',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Inter Display',
                        color: Color(0xFF8C8885),
                        height: 1.50,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Recent Activities Section (Heading Only)

              // New Card for Total Grievances Received and Resolved
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
                            children: const [
                              Text(
                                'TOTAL GRIEVANCES RECEIVED',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Inter Display',
                                  color: Color(0xFF8C8885),
                                  height: 1.67,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 4),
                              Text(
                                '65',
                                style: TextStyle(
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
                            children: const [
                              Text(
                                'TOTAL GRIEVANCES RESOLVED',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Inter Display',
                                  color: Color(0xFF8C8885),
                                  height: 1.67,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 4),
                              Text(
                                '65',
                                style: TextStyle(
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
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Recent Grievances Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recent Activities',
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
                            builder: (context) => const GrievancesScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'View All',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Inter Display',
                          color: Color(0xFF8C8885),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Dropdown Buttons
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children:
                        dropdowns.map((DropdownData dropdown) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
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
                                  setState(() {
                                    if (dropdown.label == 'Status') {
                                      selectedStatus =
                                          value == 'All' ? null : value;
                                    } else if (dropdown.label == 'Category') {
                                      selectedCategory =
                                          value == 'All' ? null : value;
                                    } else if (dropdown.label == 'Area') {
                                      selectedArea = value;
                                    } else if (dropdown.label == 'Date') {
                                      selectedDate = value;
                                    }
                                  });
                                },
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Grievances Tiles
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child:
                    filteredGrievances.isEmpty
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
                              (context, index) => const SizedBox(height: 16),
                          itemBuilder:
                              (context, index) =>
                                  buildGrievanceTile(filteredGrievances[index]),
                        ),
              ),
              const SizedBox(height: 32),
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
