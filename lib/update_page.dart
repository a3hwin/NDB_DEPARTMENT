import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:intl/intl.dart'; // For formatting date and time

class UpdatePage extends StatefulWidget {
  final Map<String, dynamic> data;

  const UpdatePage({super.key, required this.data});

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<  UpdatePage> {
  String dropdownValue = 'Internal only';
  LatLng? _mapCenter;
  bool _isMapLoading = true;
  final _storage = const FlutterSecureStorage();
  final TextEditingController _commentController = TextEditingController();
  List<Map<String, dynamic>> _comments = [];
  String? _headOfDepartment;

  @override
  void initState() {
    super.initState();
    _geocodeLocation();
    _loadComments();
    _fetchDepartmentDetails();
  }

  Future<void> _fetchDepartmentDetails() async {
    if (!await _checkInternetConnection()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No internet connection')));
      setState(() {
        _headOfDepartment = 'Admin';
      });
      return;
    }

    final token = await _storage.read(key: 'authToken');
    if (token == null || token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No authentication token found')),
      );
      setState(() {
        _headOfDepartment = 'Admin';
      });
      return;
    }

    const url =
        'https://ndb-apis-69em6.ondigitalocean.app/api/app/department/get-department-details/';
    try {
      final response = await http.get(
        Uri.parse('$url$token'),
        headers: {'Content-Type': 'application/json'},
      );
      print('Department Details Response Status: ${response.statusCode}');
      print('Department Details Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['errFlag'] == 0 && jsonResponse['data'] != null) {
          setState(() {
            _headOfDepartment =
                jsonResponse['data']['headOfDepartment'] ?? 'Admin';
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                jsonResponse['message'] ?? 'Failed to fetch department details',
              ),
            ),
          );
          setState(() {
            _headOfDepartment = 'Admin';
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to fetch department details: ${response.statusCode}',
            ),
          ),
        );
        setState(() {
          _headOfDepartment = 'Admin';
        });
      }
    } catch (e) {
      print('Error fetching department details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching department details: $e')),
      );
      setState(() {
        _headOfDepartment = 'Admin';
      });
    }
  }

  Future<void> _geocodeLocation() async {
    try {
      String address =
          widget.data['address']?.toString().trim() ?? '783 6th Main Road';
      String query =
          address.contains('Bangalore') ? address : '$address, Bangalore';
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        setState(() {
          _mapCenter = LatLng(
            locations.first.latitude,
            locations.first.longitude,
          );
          _isMapLoading = false;
        });
      } else {
        setState(() {
          _isMapLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isMapLoading = false;
      });
    }
  }

  Future<void> _loadComments() async {
    final String key = 'comments_${widget.data['id']}';
    final String? cachedComments = await _storage.read(key: key);
    if (cachedComments != null) {
      setState(() {
        _comments = List<Map<String, dynamic>>.from(jsonDecode(cachedComments))
          ..sort(
            (a, b) => DateTime.parse(
              b['timestamp'],
            ).compareTo(DateTime.parse(a['timestamp'])),
          );
        _comments = _comments.take(5).toList(); // Limit to latest 5
      });
    }
  }

  Future<void> _saveComment(String description) async {
    final String key = 'comments_${widget.data['id']}';
    final String timestamp =
        DateFormat('MMM dd, yyyy | hh:mm a').format(DateTime.now()) + ' IST';
    final Map<String, dynamic> newComment = {
      'name': _headOfDepartment ?? 'Admin',
      'description': description,
      'timestamp': timestamp,
    };
    setState(() {
      _comments.insert(0, newComment); // Add new comment at the top
      _comments = _comments.take(5).toList(); // Limit to latest 5
    });
    await _storage.write(key: key, value: jsonEncode(_comments));
  }

  Future<void> _addComment() async {
    final String description = _commentController.text.trim();
    if (description.isNotEmpty) {
      await _saveComment(description);
      _commentController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comment added successfully')),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a comment')));
    }
  }

  Future<void> _launchGoogleMaps() async {
    if (_mapCenter == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Location not available')));
      return;
    }
    final url = Uri.parse(
      'google.navigation:q=${_mapCenter!.latitude},${_mapCenter!.longitude}',
    );
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cannot open Google Maps')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error opening Google Maps: $e')));
    }
  }

  Future<bool> _checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  Future<void> _acceptGrievance() async {
  if (!await _checkInternetConnection()) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No internet connection')),
    );
    return;
  }

  final token = await _storage.read(key: 'authToken');
  if (token == null || token.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No authentication token found')),
    );
    return;
  }

  print('ID: ${widget.data['id']}, Token: $token');
  final url =
      'https://ndb-apis-69em6.ondigitalocean.app/api/app/department/update-concern-status/${widget.data['id']}/2/$token';
  print('Request URL: $url');

  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    print('API Response Status: ${response.statusCode}');
    print('API Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['errFlag'] == 0) {
        setState(() {
          widget.data['status'] = 'Accepted';
        });
        // Remove the notification from SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        List<String> notifications = prefs.getStringList('notifications') ?? [];
        notifications = notifications
            .map((n) => Map<String, dynamic>.from(jsonDecode(n)))
            .where((n) => n['concernId'].toString() != widget.data['id'].toString())
            .map((n) => jsonEncode(n))
            .toList();
        await prefs.setStringList('notifications', notifications);
        print('Removed notification for concernId: ${widget.data['id']}');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Status updated successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              jsonResponse['message'] ?? 'Failed to update status',
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update status: ${response.statusCode}'),
        ),
      );
    }
  } catch (e) {
    print('Error: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error updating status: $e')),
    );
  }
}

  Map<String, Color> getStatusBadgeColors(String status) {
    String statusStr = status.toString();

    switch (statusStr) {
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

  void _showImagePreview(String imageUrl) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            backgroundColor: Colors.black,
            child: Stack(
              children: [
                InteractiveViewer(
                  panEnabled: true,
                  scaleEnabled: true,
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: Center(
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder:
                          (context, error, stackTrace) => Image.asset(
                            'assets/images/placeholder.png',
                            fit: BoxFit.contain,
                          ),
                    ),
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(69),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 20,
                    color: Color(0xFF030100),
                  ),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Text(
                    'Back to Grievances',
                    style: TextStyle(
                      color: Color(0xFF030100),
                      fontSize: 16,
                      fontFamily: 'Inter Display',
                      fontWeight: FontWeight.w500,
                      height: 1.50,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  size: 20,
                  color: Color(0xFF030100),
                ),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _isMapLoading = true;
            _mapCenter = null;
            _headOfDepartment = null;
          });
          await _geocodeLocation();
          await _loadComments();
          await _fetchDepartmentDetails();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 0, left: 27, right: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: ShapeDecoration(
                        color:
                            getStatusBadgeColors(
                              widget.data['status']!,
                            )['background'],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        widget.data['status']!,
                        style: TextStyle(
                          color:
                              getStatusBadgeColors(
                                widget.data['status']!,
                              )['text'],
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
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 29,
                  vertical: 8,
                ),
                child: SizedBox(
                  width: 335,
                  child: Text(
                    widget.data['title']!,
                    style: const TextStyle(
                      color: Color(0xFF030100),
                      fontSize: 24,
                      fontFamily: 'Inter Display',
                      fontWeight: FontWeight.w600,
                      height: 1.33,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (widget.data['status'] == 'Assigned') {
                          showDialog(
                            context: context,
                            builder:
                                (context) => AcceptConfirmationDialog(
                                  onConfirm: _acceptGrievance,
                                ),
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder:
                                (context) => UpdateStatusDialog(
                                  data: Map.from(widget.data),
                                ),
                          ).then((updatedData) {
                            if (updatedData != null) {
                              setState(() {
                                widget.data['status'] = updatedData['status'];
                                widget.data['concern_status'] =
                                    updatedData['concern_status'];
                              });
                            }
                          });
                        }
                      },
                      child: Container(
                        width: 160,
                        height: 40,
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          color: const Color(0xFFF97D09),
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.data['status'] == 'Assigned'
                                  ? 'Accept'
                                  : 'Update status',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Inter Display',
                                fontWeight: FontWeight.w600,
                                height: 1.50,
                              ),
                            ),
                            if (widget.data['status'] != 'Assigned') ...[
                              const SizedBox(width: 8),
                              SvgPicture.asset(
                                'assets/images/edit_icon.svg',
                                width: 16,
                                height: 15,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () async {
                        String phoneNumber =
                            widget.data['contact_number']?.toString().trim() ??
                            '';
                        if (phoneNumber.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('No contact number available'),
                            ),
                          );
                          return;
                        }
                        phoneNumber = phoneNumber.replaceAll(
                          RegExp(r'[^0-9]'),
                          '',
                        );
                        if (!RegExp(r'^\d{10}$').hasMatch(phoneNumber)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Invalid phone number format'),
                            ),
                          );
                          return;
                        }
                        List<String> uris = [
                          'tel:+91$phoneNumber',
                          'tel:$phoneNumber',
                          'tel://$phoneNumber',
                          'dialer:+91$phoneNumber',
                        ];
                        bool launched = false;
                        String? lastError;
                        for (String uri in uris) {
                          final url = Uri.parse(uri);
                          try {
                            if (await canLaunchUrl(url)) {
                              await launchUrl(
                                url,
                                mode: LaunchMode.externalApplication,
                              );
                              launched = true;
                              break;
                            } else {
                              lastError = 'No app found to handle $uri';
                            }
                          } catch (e) {
                            lastError = 'Error: $e';
                          }
                        }
                        if (!launched) {
                          try {
                            final intent = Uri.parse(
                              'intent://dial/+91$phoneNumber#Intent;action=android.intent.action.DIAL;end',
                            );
                            if (await canLaunchUrl(intent)) {
                              await launchUrl(
                                intent,
                                mode: LaunchMode.externalApplication,
                              );
                              launched = true;
                            } else {
                              lastError = 'No dialer found for explicit intent';
                            }
                          } catch (e) {
                            lastError = 'Error: $e';
                          }
                        }
                        if (!launched) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                lastError ?? 'Cannot open phone dialer',
                              ),
                            ),
                          );
                        }
                      },
                      child: Container(
                        width: 71,
                        height: 40,
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              width: 1,
                              color: Color(0xFFD96C07),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/images/phone.svg',
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: _launchGoogleMaps,
                      child: Container(
                        width: 72,
                        height: 40,
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              width: 1,
                              color: Color(0xFFD96C07),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/images/arrow.svg',
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: MediaQuery.of(context).size.width - 40,
                  padding: const EdgeInsets.all(16),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Grievance Details',
                        style: TextStyle(
                          color: Color(0xFF030100),
                          fontSize: 16,
                          fontFamily: 'Inter Display',
                          fontWeight: FontWeight.w500,
                          height: 1.50,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: const Color(0xFFFFF3EB),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: SvgPicture.asset(
                              'assets/images/ref.svg',
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Reference ID',
                                  style: TextStyle(
                                    color: Color(0xFF8C8885),
                                    fontSize: 12,
                                    fontFamily: 'Inter Display',
                                    fontWeight: FontWeight.w400,
                                    height: 1.83,
                                  ),
                                ),
                                Text(
                                  widget.data['statusCode']!,
                                  style: const TextStyle(
                                    color: Color(0xFF030100),
                                    fontSize: 16,
                                    fontFamily: 'Inter Display',
                                    fontWeight: FontWeight.w500,
                                    height: 1.38,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Color(0xFFFFF3EB),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: SvgPicture.asset(
                              'assets/images/loc.svg',
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Location',
                                  style: TextStyle(
                                    color: Color(0xFF8C8885),
                                    fontSize: 12,
                                    fontFamily: 'Inter Display',
                                    fontWeight: FontWeight.w400,
                                    height: 1.83,
                                  ),
                                ),
                                Text(
                                  widget.data['address']!,
                                  style: const TextStyle(
                                    color: Color(0xFF030100),
                                    fontSize: 16,
                                    fontFamily: 'Inter Display',
                                    fontWeight: FontWeight.w500,
                                    height: 1.38,
                                  ),
                                  maxLines: null,
                                  overflow: TextOverflow.visible,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Color(0xFFFFF3EB),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: SvgPicture.asset(
                              'assets/images/date.svg',
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Submitted On',
                                  style: TextStyle(
                                    color: Color(0xFF8C8885),
                                    fontSize: 12,
                                    fontFamily: 'Inter Display',
                                    fontWeight: FontWeight.w400,
                                    height: 1.83,
                                  ),
                                ),
                                Text(
                                  widget.data['timestamp']!,
                                  style: const TextStyle(
                                    color: Color(0xFF030100),
                                    fontSize: 16,
                                    fontFamily: 'Inter Display',
                                    fontWeight: FontWeight.w500,
                                    height: 1.38,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Color(0xFFFFF3EB),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: SvgPicture.asset(
                              'assets/images/cont.svg',
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Mobile Number',
                                  style: TextStyle(
                                    color: Color(0xFF8C8885),
                                    fontSize: 12,
                                    fontFamily: 'Inter Display',
                                    fontWeight: FontWeight.w400,
                                    height: 1.83,
                                  ),
                                ),
                                Text(
                                  widget.data['contact_number']!,
                                  style: const TextStyle(
                                    color: Color(0xFF030100),
                                    fontSize: 16,
                                    fontFamily: 'Inter Display',
                                    fontWeight: FontWeight.w500,
                                    height: 1.38,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Color(0xFFFFF3EB),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: SvgPicture.asset(
                              'assets/images/gmail.svg',
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Email Address',
                                  style: TextStyle(
                                    color: Color(0xFF8C8885),
                                    fontSize: 12,
                                    fontFamily: 'Inter Display',
                                    fontWeight: FontWeight.w400,
                                    height: 1.83,
                                  ),
                                ),
                                Text(
                                  widget.data['email']!,
                                  style: const TextStyle(
                                    color: Color(0xFF030100),
                                    fontSize: 16,
                                    fontFamily: 'Inter Display',
                                    fontWeight: FontWeight.w500,
                                    height: 1.38,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Color(0xFFFFF3EB),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: SvgPicture.asset(
                              'assets/images/prof.svg',
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Submitted By',
                                  style: TextStyle(
                                    color: Color(0xFF8C8885),
                                    fontSize: 12,
                                    fontFamily: 'Inter Display',
                                    fontWeight: FontWeight.w400,
                                    height: 1.83,
                                  ),
                                ),
                                Text(
                                  widget.data['reporter']!,
                                  style: const TextStyle(
                                    color: Color(0xFF030100),
                                    fontSize: 16,
                                    fontFamily: 'Inter Display',
                                    fontWeight: FontWeight.w500,
                                    height: 1.38,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 29),
                child: const Text(
                  'Description',
                  style: TextStyle(
                    color: Color(0xFF030100),
                    fontSize: 16,
                    fontFamily: 'Inter Display',
                    fontWeight: FontWeight.w500,
                    height: 1.50,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 29),
                child: SizedBox(
                  width: 335,
                  child: Text(
                    widget.data['description']!,
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
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 29),
                child: const Text(
                  'Images Of the Concern',
                  style: TextStyle(
                    color: Color(0xFF030100),
                    fontSize: 16,
                    fontFamily: 'Inter Display',
                    fontWeight: FontWeight.w500,
                    height: 1.50,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 29),
                child: const SizedBox(
                  width: 335,
                  child: Text(
                    'Photos shared by the citizen for better clarity',
                    style: TextStyle(
                      color: Color(0xFF8C8885),
                      fontSize: 14,
                      fontFamily: 'Inter Display',
                      fontWeight: FontWeight.w400,
                      height: 1.57,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 29),
                child: Builder(
                  builder: (context) {
                    if (widget.data['photos'] == null ||
                        widget.data['photos']!.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    final List<String> images =
                        widget.data['photos']!.split(',').take(4).toList();
                    const double imageWidth =
                        160; // Adjusted to fit two images side by side within 335 width
                    const double imageHeight =
                        200; // Slightly reduced to maintain aspect ratio
                    const double spacing = 15; // Space between images

                    Widget buildImage(String imageUrl) {
                      return GestureDetector(
                        onTap: () => _showImagePreview(imageUrl),
                        child: Container(
                          width: imageWidth,
                          height: imageHeight,
                          clipBehavior: Clip.antiAlias,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
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
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.fill,
                            errorBuilder:
                                (context, error, stackTrace) => Image.asset(
                                  'assets/images/placeholder.png',
                                  fit: BoxFit.fill,
                                ),
                          ),
                        ),
                      );
                    }

                    switch (images.length) {
                      case 1:
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [buildImage(images[0])],
                        );
                      case 2:
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildImage(images[0]),
                            buildImage(images[1]),
                          ],
                        );
                      case 3:
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                buildImage(images[0]),
                                buildImage(images[1]),
                              ],
                            ),
                            const SizedBox(height: spacing),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [buildImage(images[2])],
                            ),
                          ],
                        );
                      case 4:
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                buildImage(images[0]),
                                buildImage(images[1]),
                              ],
                            ),
                            const SizedBox(height: spacing),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                buildImage(images[2]),
                                buildImage(images[3]),
                              ],
                            ),
                          ],
                        );
                      default:
                        return const SizedBox.shrink();
                    }
                  },
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: MediaQuery.of(context).size.width - 40,
                  padding: const EdgeInsets.all(16),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Activity & Comments',
                        style: TextStyle(
                          color: Color(0xFF030100),
                          fontSize: 16,
                          fontFamily: 'Inter Display',
                          fontWeight: FontWeight.w500,
                          height: 1.50,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              width: 1,
                              color: Color(0xFFE1E0DF),
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: Column(
                          children: [
                            TextField(
                              controller: _commentController,
                              maxLines: 5,
                              decoration: const InputDecoration(
                                hintText:
                                    'Add a comment, internal note, update on the concern...',
                                hintStyle: TextStyle(
                                  color: Color(0xFFC4C2C0),
                                  fontSize: 16,
                                  fontFamily: 'Inter Display',
                                  fontWeight: FontWeight.w400,
                                  height: 1.50,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                onPressed: _addComment,
                                style: TextButton.styleFrom(
                                  backgroundColor: const Color(0xFFF97D09),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(double.infinity, 40),
                                ),
                                child: const Text(
                                  'Add Comment',
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
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _comments.length,
                        itemBuilder: (context, index) {
                          final comment = _comments[index];
                          return Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 8),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.only(
                                left: 12,
                                top: 8,
                                bottom: 8,
                              ),
                              decoration: const BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    width: 2,
                                    color: Color(0xFF030100),
                                  ),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: '${comment['name']} ( ',
                                          style: const TextStyle(
                                            color: Color(0xFF030100),
                                            fontSize: 14,
                                            fontFamily: 'Inter Display',
                                            fontWeight: FontWeight.w500,
                                            height: 1.57,
                                          ),
                                        ),
                                        const TextSpan(
                                          text: 'Department of roads )',
                                          style: TextStyle(
                                            color: Color(0xFF030100),
                                            fontSize: 14,
                                            fontFamily: 'Inter Display',
                                            fontWeight: FontWeight.w400,
                                            height: 1.57,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const SizedBox(
                                    height: 4,
                                  ), // Removed comment type
                                  Text(
                                    comment['description'],
                                    style: const TextStyle(
                                      color: Color(0xFF8C8885),
                                      fontSize: 14,
                                      fontFamily: 'Inter Display',
                                      fontWeight: FontWeight.w400,
                                      height: 1.57,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    comment['timestamp'],
                                    style: const TextStyle(
                                      color: Color(0xFF8C8885),
                                      fontSize: 12,
                                      fontFamily: 'Inter Display',
                                      fontWeight: FontWeight.w400,
                                      height: 1.67,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: MediaQuery.of(context).size.width - 40,
                  padding: const EdgeInsets.all(16),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Location',
                        style: TextStyle(
                          color: Color(0xFF030100),
                          fontSize: 16,
                          fontFamily: 'Inter Display',
                          fontWeight: FontWeight.w500,
                          height: 1.50,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        height: 176,
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child:
                            _isMapLoading
                                ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                                : _mapCenter == null
                                ? Image.asset(
                                  'assets/images/map.png',
                                  fit: BoxFit.cover,
                                )
                                : GoogleMap(
                                  initialCameraPosition: CameraPosition(
                                    target: _mapCenter!,
                                    zoom: 14,
                                  ),
                                  markers: {
                                    Marker(
                                      markerId: const MarkerId('location'),
                                      position: _mapCenter!,
                                      infoWindow: InfoWindow(
                                        title:
                                            widget.data['address'] ??
                                            '783 6th Main Road',
                                      ),
                                    ),
                                  },
                                  myLocationEnabled: false,
                                  zoomControlsEnabled: true,
                                  mapToolbarEnabled: false,
                                  scrollGesturesEnabled: false,
                                  rotateGesturesEnabled: false,
                                  tiltGesturesEnabled: false,
                                  zoomGesturesEnabled: true,
                                ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              widget.data['address'] ?? '783 6th Main Road',
                              style: const TextStyle(
                                color: Color(0xFF030100),
                                fontSize: 14,
                                fontFamily: 'Inter Display',
                                fontWeight: FontWeight.w400,
                                height: 1.57,
                              ),
                              maxLines: null,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                          const SizedBox(width: 16),
                          GestureDetector(
                            onTap: _launchGoogleMaps,
                            child: Container(
                              width: 56,
                              height: 40,
                              clipBehavior: Clip.antiAlias,
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    width: 1,
                                    color: Color(0xFFE1E0DF),
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  'assets/images/locB.svg',
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class AcceptConfirmationDialog extends StatelessWidget {
  final Future<void> Function() onConfirm;

  const AcceptConfirmationDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17.0)),
      child: Container(
        width: 370,
        padding: const EdgeInsets.all(9),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Are you sure?',
                style: TextStyle(
                  color: Color(0xFF030100),
                  fontSize: 20,
                  fontFamily: 'Inter Display',
                  fontWeight: FontWeight.w500,
                  height: 1.50,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                const SizedBox(width: 8),
                SizedBox(
                  width: 144,
                  height: 40,
                  child: TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await onConfirm();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFF97D09),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      shadowColor: const Color(0x3F3A2211),
                      elevation: 2,
                    ),
                    child: const Text(
                      'Yes',
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
                const SizedBox(width: 16),
                SizedBox(
                  width: 144,
                  height: 40,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFFFE6D7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Color(0xFFD96C07),
                        fontSize: 16,
                        fontFamily: 'Inter Display',
                        fontWeight: FontWeight.w600,
                        height: 1.50,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class UpdateStatusDialog extends StatefulWidget {
  final Map<String, dynamic> data;

  const UpdateStatusDialog({super.key, required this.data});

  @override
  _UpdateStatusDialogState createState() => _UpdateStatusDialogState();
}

class _UpdateStatusDialogState extends State<UpdateStatusDialog> {
  String? selectedStatus;
  List<String> attachedImages = [];
  bool isInternalNote = false;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    int currentStatus = int.tryParse(widget.data['concern_status'] ?? '1') ?? 1;
    switch (currentStatus) {
      case 2:
        selectedStatus = 'Accepted';
        break;
      case 3:
        selectedStatus = 'Resolved';
        break;
      default:
        selectedStatus = 'Assigned';
    }
  }

  Future<void> _attachImage() async {
    if (attachedImages.length >= 3) return;
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        attachedImages.add(image.path);
      });
    }
  }

  Future<void> _updateStatus() async {
    if (!await _checkInternetConnection()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No internet connection')));
      return;
    }

    final token = await const FlutterSecureStorage().read(key: 'authToken');
    if (token == null || token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No authentication token found')),
      );
      return;
    }

    final concernId = widget.data['id'];
    int newStatus = selectedStatus == 'Resolved' ? 3 : 
                    (selectedStatus == 'Accepted' ? 2 : 1);

    setState(() {
      widget.data['concern_status'] = newStatus.toString();
      widget.data['status'] = selectedStatus;
    });

    // Step 1: Update concern status
    final updateUrl =
        'https://ndb-apis-69em6.ondigitalocean.app/api/app/department/update-concern-status/$concernId/$newStatus/$token';
    try {
      final updateResponse = await http.get(
        Uri.parse(updateUrl),
        headers: {'Content-Type': 'application/json'},
      );
      print('Update Status Response Status: ${updateResponse.statusCode}');
      print('Update Status Response Body: ${updateResponse.body}');

      if (updateResponse.statusCode == 200) {
        final jsonResponse = jsonDecode(updateResponse.body);
        if (jsonResponse['errFlag'] == 0) {
          setState(() {
            widget.data['concern_status'] = newStatus;
            widget.data['status'] = selectedStatus;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                jsonResponse['message'] ?? 'Failed to update status',
              ),
            ),
          );
          return;
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to update status: ${updateResponse.statusCode}',
            ),
          ),
        );
        return;
      }
    } catch (e) {
      print('Update Status Error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error updating status: $e')));
      return;
    }

    // Step 2: Upload work update with multipart request
    final uploadUrl =
        'https://ndb-apis-69em6.ondigitalocean.app/api/app/department/upload-work-update';
    final description =
        _noteController.text.trim().isEmpty ? "" : _noteController.text.trim();

    var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));
    request.fields['token'] = token;
    request.fields['concernId'] = concernId.toString();
    request.fields['description'] = description;

    if (attachedImages.isNotEmpty) {
      for (var imagePath in attachedImages) {
        var file = await http.MultipartFile.fromPath('photos', imagePath);
        request.files.add(file);
      }
    } else {
      request.fields['photos'] = "";
    }

    print('Multipart Request Fields: ${request.fields}');
    print('Multipart Request Files: ${request.files.map((f) => f.filename)}');

    try {
      final uploadResponse = await request.send();
      final responseBody = await uploadResponse.stream.bytesToString();

      print('Upload Work Update Response Status: ${uploadResponse.statusCode}');
      print('Upload Work Update Response Body: $responseBody');

      if (uploadResponse.statusCode == 200) {
        final jsonResponse = jsonDecode(responseBody);
        if (jsonResponse['errFlag'] == 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Work update uploaded successfully')),
          );
          if (jsonResponse['uploaded_photos'] != null) {
            widget.data['photos'] = (jsonResponse['uploaded_photos'] as List)
                .join(',');
          }
          Navigator.pop(context, widget.data);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                jsonResponse['message'] ?? 'Failed to upload work update',
              ),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please upload images and comments before updating status',
            ),
          ),
        );
      }
    } catch (e) {
      print('Upload Work Update Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading work update: $e')),
      );
    }
  }

  Future<bool> _checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17.40)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Update Grievance status',
                    style: TextStyle(
                      color: Color(0xFF030100),
                      fontSize: 16,
                      fontFamily: 'Inter Display',
                      fontWeight: FontWeight.w500,
                      height: 1.50,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const SizedBox(
                width: 303,
                child: Text(
                  'Change the status and add notes or images as needed.',
                  style: TextStyle(
                    color: Color(0xFF8C8885),
                    fontSize: 14,
                    fontFamily: 'Inter Display',
                    fontWeight: FontWeight.w400,
                    height: 1.57,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Status',
                style: TextStyle(
                  color: Color(0xFF030100),
                  fontSize: 14,
                  fontFamily: 'Inter Display',
                  fontWeight: FontWeight.w400,
                  height: 1.57,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 303,
                height: 52,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Color(0xFFE1E0DF)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: DropdownButton<String>(
                  value: selectedStatus,
                  hint: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'Update grievance status',
                      style: TextStyle(
                        color: Color(0xFFC4C2C0),
                        fontSize: 16,
                        fontFamily: 'Inter Display',
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                      ),
                    ),
                  ),
                  items:
                      ['Assigned','Accepted', 'Resolved'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(value),
                          ),
                        );
                      }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedStatus = newValue;
                    });
                  },
                  isExpanded: true,
                  underline: const SizedBox(),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Note',
                style: TextStyle(
                  color: Color(0xFF030100),
                  fontSize: 14,
                  fontFamily: 'Inter Display',
                  fontWeight: FontWeight.w400,
                  height: 1.57,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 303,
                height: 139,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Color(0xFFE1E0DF)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: TextField(
                  controller: _noteController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: 'Add a note...',
                    hintStyle: TextStyle(
                      color: Color(0xFFC4C2C0),
                      fontSize: 16,
                      fontFamily: 'Inter Display',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: _attachImage,
                  child: Container(
                    width: 143,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: ShapeDecoration(
                      color: const Color(0xFFF8F8F8),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 1,
                          color: Color(0xFFE1E0DF),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          'assets/images/cam.svg',
                          width: 16,
                          height: 16,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Attach Images',
                          style: TextStyle(
                            color: Color(0xFF030100),
                            fontSize: 14,
                            fontFamily: 'Inter Display',
                            fontWeight: FontWeight.w500,
                            height: 1.57,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (attachedImages.isNotEmpty) ...[
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  children:
                      attachedImages.map((image) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Stack(
                            children: [
                              Container(
                                width: 95,
                                height: 93,
                                decoration: ShapeDecoration(
                                  image: DecorationImage(
                                    image:
                                        kIsWeb
                                            ? NetworkImage(image)
                                            : FileImage(File(image)),
                                    fit: BoxFit.fill,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                      width: 1,
                                      color: Color(0xFFE1E0DF),
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 4,
                                top: 4,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      attachedImages.remove(image);
                                    });
                                  },
                                  child: Container(
                                    width: 16,
                                    height: 16,
                                    decoration: ShapeDecoration(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: const Icon(Icons.close, size: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                ),
              ],
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 144,
                    height: 40,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFFFE6D7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Color(0xFFD96C07),
                          fontSize: 16,
                          fontFamily: 'Inter Display',
                          fontWeight: FontWeight.w600,
                          height: 1.50,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 143,
                    height: 40,
                    child: TextButton(
                      onPressed: _updateStatus,
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFF97D09),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        shadowColor: const Color(0x3F3A2211),
                        elevation: 2,
                      ),
                      child: const Text(
                        'Update status',
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
