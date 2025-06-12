import 'package:flutter/material.dart';

class UpdatePage extends StatefulWidget {
  final Map<String, String> data;

  const UpdatePage({super.key, required this.data});

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 20,
            color: Color(0xFF030100),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Back to Grievances',
          style: TextStyle(
            color: Color(0xFF030100),
            fontSize: 16,
            fontFamily: 'Inter Display',
            fontWeight: FontWeight.w500,
            height: 1.50,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              // Badges Row
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: ShapeDecoration(
                      color: const Color(0xFFFFF3EB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Roads',
                      style: TextStyle(
                        color: Color(0xFFD96C07),
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
                      color: const Color(0xFFDBEAFE),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'New',
                      style: TextStyle(
                        color: Color(0xFF007AFF),
                        fontSize: 12,
                        fontFamily: 'Inter Display',
                        fontWeight: FontWeight.w400,
                        height: 1.67,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Heading
              const SizedBox(
                width: 335,
                child: Text(
                  'Pothole on MG Road needs urgent repair',
                  style: TextStyle(
                    color: Color(0xFF030100),
                    fontSize: 24,
                    fontFamily: 'Inter Display',
                    fontWeight: FontWeight.w600,
                    height: 1.33,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Buttons Row
              Row(
                children: [
                  // Update Status Button
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => const UpdateStatusDialog(),
                      );
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
                        shadows: [
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
                          'Update status',
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
                  const SizedBox(width: 16),
                  // First Additional Button
                  Container(
                    width: 71,
                    height: 40,
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          color: const Color(0xFFD96C07),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Button 1', // Placeholder text
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
                  const SizedBox(width: 16),
                  // Second Additional Button
                  Container(
                    width: 72,
                    height: 40,
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          color: const Color(0xFFD96C07),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Button 2', // Placeholder text
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
              const SizedBox(
                height: 16,
              ), // Spacing between buttons and grievance details
              // Grievance Details Tile
              Container(
                width: 335,
                height: 536,
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17.40),
                  ),
                  shadows: [
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
                      top: 16,
                      child: Text(
                        'Grievance Details',
                        style: TextStyle(
                          color: const Color(0xFF030100),
                          fontSize: 16,
                          fontFamily: 'Inter Display',
                          fontWeight: FontWeight.w500,
                          height: 1.50,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      top: 56,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
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
                                borderRadius: BorderRadius.circular(204.08),
                              ),
                            ),
                            child: Image.asset(
                              'assets/icons/category_icon.png', // Placeholder path
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            width: 49,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 49,
                                  child: Text(
                                    'Category',
                                    style: TextStyle(
                                      color: const Color(0xFF8C8885),
                                      fontSize: 12,
                                      fontFamily: 'Inter Display',
                                      fontWeight: FontWeight.w400,
                                      height: 1.83,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 49,
                                  child: Text(
                                    'Roads',
                                    style: TextStyle(
                                      color: const Color(0xFF030100),
                                      fontSize: 16,
                                      fontFamily: 'Inter Display',
                                      fontWeight: FontWeight.w500,
                                      height: 1.38,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 16,
                      top: 116,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
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
                                borderRadius: BorderRadius.circular(204.08),
                              ),
                            ),
                            child: Image.asset(
                              'assets/icons/reference_id_icon.png', // Placeholder path
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            width: 201,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 201,
                                  child: Text(
                                    'Reference ID',
                                    style: TextStyle(
                                      color: const Color(0xFF8C8885),
                                      fontSize: 12,
                                      fontFamily: 'Inter Display',
                                      fontWeight: FontWeight.w400,
                                      height: 1.83,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 201,
                                  child: Text(
                                    'SC-2025-2738',
                                    style: TextStyle(
                                      color: const Color(0xFF030100),
                                      fontSize: 16,
                                      fontFamily: 'Inter Display',
                                      fontWeight: FontWeight.w500,
                                      height: 1.38,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 16,
                      top: 176,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
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
                                borderRadius: BorderRadius.circular(204.08),
                              ),
                            ),
                            child: Image.asset(
                              'assets/icons/location_icon.png', // Placeholder path
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            width: 201,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 201,
                                  child: Text(
                                    'Location',
                                    style: TextStyle(
                                      color: const Color(0xFF8C8885),
                                      fontSize: 12,
                                      fontFamily: 'Inter Display',
                                      fontWeight: FontWeight.w400,
                                      height: 1.83,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 201,
                                  child: Text(
                                    'East Sector, Doddaballapura',
                                    style: TextStyle(
                                      color: const Color(0xFF030100),
                                      fontSize: 16,
                                      fontFamily: 'Inter Display',
                                      fontWeight: FontWeight.w500,
                                      height: 1.38,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 16,
                      top: 236,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
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
                                borderRadius: BorderRadius.circular(204.08),
                              ),
                            ),
                            child: Image.asset(
                              'assets/icons/submitted_on_icon.png', // Placeholder path
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            width: 201,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 201,
                                  child: Text(
                                    'Submitted on',
                                    style: TextStyle(
                                      color: const Color(0xFF8C8885),
                                      fontSize: 12,
                                      fontFamily: 'Inter Display',
                                      fontWeight: FontWeight.w400,
                                      height: 1.83,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 201,
                                  child: Text(
                                    'Apr 03, 2025 | 02:35 PM',
                                    style: TextStyle(
                                      color: const Color(0xFF030100),
                                      fontSize: 16,
                                      fontFamily: 'Inter Display',
                                      fontWeight: FontWeight.w500,
                                      height: 1.38,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 16,
                      top: 296,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
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
                                borderRadius: BorderRadius.circular(204.08),
                              ),
                            ),
                            child: Image.asset(
                              'assets/icons/contact_number_icon.png', // Placeholder path
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            width: 201,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 201,
                                  child: Text(
                                    'Contact Number',
                                    style: TextStyle(
                                      color: const Color(0xFF8C8885),
                                      fontSize: 12,
                                      fontFamily: 'Inter Display',
                                      fontWeight: FontWeight.w400,
                                      height: 1.83,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 201,
                                  child: Text(
                                    '+91 9876543210',
                                    style: TextStyle(
                                      color: const Color(0xFF030100),
                                      fontSize: 16,
                                      fontFamily: 'Inter Display',
                                      fontWeight: FontWeight.w500,
                                      height: 1.38,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 16,
                      top: 356,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
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
                                borderRadius: BorderRadius.circular(204.08),
                              ),
                            ),
                            child: Image.asset(
                              'assets/icons/email_icon.png', // Placeholder path
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            width: 201,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 201,
                                  child: Text(
                                    'Email ID',
                                    style: TextStyle(
                                      color: const Color(0xFF8C8885),
                                      fontSize: 12,
                                      fontFamily: 'Inter Display',
                                      fontWeight: FontWeight.w400,
                                      height: 1.83,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 201,
                                  child: Text(
                                    'rihan@gmail.com',
                                    style: TextStyle(
                                      color: const Color(0xFF030100),
                                      fontSize: 16,
                                      fontFamily: 'Inter Display',
                                      fontWeight: FontWeight.w500,
                                      height: 1.38,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 16,
                      top: 416,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
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
                                borderRadius: BorderRadius.circular(204.08),
                              ),
                            ),
                            child: Image.asset(
                              'assets/icons/epid_icon.png', // Placeholder path
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            width: 201,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 201,
                                  child: Text(
                                    'EPID ID',
                                    style: TextStyle(
                                      color: const Color(0xFF8C8885),
                                      fontSize: 12,
                                      fontFamily: 'Inter Display',
                                      fontWeight: FontWeight.w400,
                                      height: 1.83,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 201,
                                  child: Text(
                                    'XYZ1234567',
                                    style: TextStyle(
                                      color: const Color(0xFF030100),
                                      fontSize: 16,
                                      fontFamily: 'Inter Display',
                                      fontWeight: FontWeight.w500,
                                      height: 1.38,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 16,
                      top: 476,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
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
                                borderRadius: BorderRadius.circular(204.08),
                              ),
                            ),
                            child: Image.asset(
                              'assets/icons/submitted_by_icon.png', // Placeholder path
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            width: 201,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 201,
                                  child: Text(
                                    'Submitted by',
                                    style: TextStyle(
                                      color: const Color(0xFF8C8885),
                                      fontSize: 12,
                                      fontFamily: 'Inter Display',
                                      fontWeight: FontWeight.w400,
                                      height: 1.83,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 201,
                                  child: Text(
                                    'Rihan Kumar',
                                    style: TextStyle(
                                      color: const Color(0xFF030100),
                                      fontSize: 16,
                                      fontFamily: 'Inter Display',
                                      fontWeight: FontWeight.w500,
                                      height: 1.38,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16), // Bottom spacing for scroll view
            ],
          ),
        ),
      ),
    );
  }
}

class UpdateStatusDialog extends StatefulWidget {
  const UpdateStatusDialog({super.key});

  @override
  _UpdateStatusDialogState createState() => _UpdateStatusDialogState();
}

class _UpdateStatusDialogState extends State<UpdateStatusDialog> {
  String? selectedStatus;
  List<String> attachedImages = [];
  bool isInternalNote = false;

  void _attachImage() {
    if (attachedImages.length < 3) {
      setState(() {
        attachedImages.add("https://placehold.co/95x93");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17.40)),
      child: SizedBox(
        width: 335,
        height: 551,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
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
                  const SizedBox(height: 4),
                  const SizedBox(
                    width: 305,
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
                        side: const BorderSide(
                          width: 1,
                          color: Color(0xFFE1E0DF),
                        ),
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
                          ['New', 'In Progress', 'Resolved', 'Rejected'].map((
                            String value,
                          ) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
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
                    'Add Comment',
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
                        side: const BorderSide(
                          width: 1,
                          color: Color(0xFFE1E0DF),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const TextField(
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Add details about this status update...',
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
                  GestureDetector(
                    onTap: _attachImage,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
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
                      child: const Text(
                        'Attach Images',
                        style: TextStyle(
                          color: Color(0xFF030100),
                          fontSize: 14,
                          fontFamily: 'Inter Display',
                          fontWeight: FontWeight.w500,
                          height: 1.57,
                        ),
                      ),
                    ),
                  ),
                  if (attachedImages.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Row(
                      children:
                          attachedImages.map((image) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Stack(
                                children: [
                                  Container(
                                    width: 95,
                                    height: 93,
                                    decoration: ShapeDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(image),
                                        fit: BoxFit.cover,
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
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          size: 12,
                                        ),
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
                    children: [
                      Checkbox(
                        value: isInternalNote,
                        onChanged: (value) {
                          setState(() {
                            isInternalNote = value!;
                          });
                        },
                        activeColor: const Color(0xFFF97D09),
                        side: const BorderSide(color: Color(0xFFFFC199)),
                      ),
                      const Text(
                        'Mark as internal note (not visible to citizen)',
                        style: TextStyle(
                          color: Color(0xFF8C8885),
                          fontSize: 12,
                          fontFamily: 'Inter Display',
                          fontWeight: FontWeight.w400,
                          height: 1.83,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
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
                          onPressed: () {
                            // Logic to update status can be added here
                            Navigator.pop(context);
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
            Positioned(
              right: 8,
              top: 8,
              child: IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
