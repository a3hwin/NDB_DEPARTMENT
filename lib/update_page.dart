import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UpdatePage extends StatefulWidget {
  final Map<String, String> data;

  const UpdatePage({super.key, required this.data});

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  String dropdownValue = 'Internal only';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(69),
        child: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Badges Row
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
            ),
            // Main Heading
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 29, vertical: 8),
              child: SizedBox(
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
            ),
            // Buttons Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Row(
                children: [
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
                          const Text(
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
                          const SizedBox(width: 8),
                          SvgPicture.asset(
                            'assets/images/edit_icon.svg',
                            width: 16,
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
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
                      child: SvgPicture.asset(
                        'assets/images/phone.svg',
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
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
                      child: SvgPicture.asset(
                        'assets/images/arrow.svg',
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Grievance Details Tile
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: MediaQuery.of(context).size.width - 40,
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
                            child: SvgPicture.asset(
                              'assets/images/cat.svg',
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            width: MediaQuery.of(context).size.width - 112,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 112,
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
                                  width:
                                      MediaQuery.of(context).size.width - 112,
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
                            child: SvgPicture.asset(
                              'assets/images/ref.svg',
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            width: MediaQuery.of(context).size.width - 112,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 112,
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
                                  width:
                                      MediaQuery.of(context).size.width - 112,
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
                            child: SvgPicture.asset(
                              'assets/images/loc.svg',
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            width: MediaQuery.of(context).size.width - 112,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 112,
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
                                  width:
                                      MediaQuery.of(context).size.width - 112,
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
                            child: SvgPicture.asset(
                              'assets/images/date.svg',
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            width: MediaQuery.of(context).size.width - 112,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 112,
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
                                  width:
                                      MediaQuery.of(context).size.width - 112,
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
                            child: SvgPicture.asset(
                              'assets/images/cont.svg',
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            width: MediaQuery.of(context).size.width - 112,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 112,
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
                                  width:
                                      MediaQuery.of(context).size.width - 112,
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
                            child: SvgPicture.asset(
                              'assets/images/gmail.svg',
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            width: MediaQuery.of(context).size.width - 112,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 112,
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
                                  width:
                                      MediaQuery.of(context).size.width - 112,
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
                            child: SvgPicture.asset(
                              'assets/images/epid.svg',
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            width: MediaQuery.of(context).size.width - 112,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 112,
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
                                  width:
                                      MediaQuery.of(context).size.width - 112,
                                  child: Text(
                                    'XYZ1234567',
                                    style: TextStyle(
                                      color: const Color(0xFF030100),
                                      fontSize: 16,
                                      fontFamily: 'Inter Display',
                                      fontWeight: FontWeight.w600,
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
                            child: SvgPicture.asset(
                              'assets/images/prof.svg',
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            width: MediaQuery.of(context).size.width - 112,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 112,
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
                                  width:
                                      MediaQuery.of(context).size.width - 112,
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
            ),
            const SizedBox(height: 24),
            // Description Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 29),
              child: Text(
                'Description',
                style: TextStyle(
                  color: const Color(0xFF030100),
                  fontSize: 16,
                  fontFamily: 'Inter Display',
                  fontWeight: FontWeight.w500,
                  height: 1.50,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Issue Type Badge
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 29),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: const Color(0xFFF97D09)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Pothole issue',
                      style: TextStyle(
                        color: const Color(0xFFD96C07),
                        fontSize: 12,
                        fontFamily: 'Inter Display',
                        fontWeight: FontWeight.w400,
                        height: 1.67,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Description Text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 29),
              child: SizedBox(
                width: 335,
                child: Text(
                  'There’s a deep pothole on MG Road that’s been causing major traffic disruptions for the past 2 days\nTwo-wheelers are finding it especially difficult to navigate, and there’s a risk of accidents. Residents\nand shopkeepers nearby are facing daily inconvenience due to the damaged road.',
                  style: TextStyle(
                    color: const Color(0xFF8C8885),
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
              child: Text(
                'Images of the concern',
                style: TextStyle(
                  color: const Color(0xFF030100),
                  fontSize: 16,
                  fontFamily: 'Inter Display',
                  fontWeight: FontWeight.w500,
                  height: 1.50,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 29),
              child: SizedBox(
                width: 335,
                child: Text(
                  'Photos shared by the citizen for better clarity',
                  style: TextStyle(
                    color: const Color(0xFF8C8885),
                    fontSize: 14,
                    fontFamily: 'Inter Display',
                    fontWeight: FontWeight.w400,
                    height: 1.57,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Images Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 200,
                        height: 250,
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
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
                        child: Image.asset(
                          'assets/images/image.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                      Container(
                        width: 200,
                        height: 250,
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
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
                        child: Image.asset(
                          'assets/images/image2.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 200,
                        height: 250,
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
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
                        child: Image.asset(
                          'assets/images/image3.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                      Container(
                        width: 200,
                        height: 250,
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
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
                        child: Image.asset(
                          'assets/images/image4.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Activity & Comments Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: MediaQuery.of(context).size.width - 40,
                height: 710,
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
                        'Activity & Comments',
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
                      right: 16,
                      top: 16,
                      child: Container(
                        height: 30,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              color: const Color(0xFFA8A5A2),
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: dropdownValue,
                            icon: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: SvgPicture.asset(
                                'assets/images/arrow_down.svg',
                                width: 10,
                                height: 6,
                              ),
                            ),
                            items:
                                ['Internal only', 'External'].map((
                                  String value,
                                ) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: const TextStyle(
                                        color: Color(0xFF030100),
                                        fontSize: 12,
                                        fontFamily: 'Inter Display',
                                        fontWeight: FontWeight.w400,
                                        height: 1.67,
                                      ),
                                    ),
                                  );
                                }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                dropdownValue = newValue!;
                              });
                            },
                            isDense: true,
                            dropdownColor: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            menuMaxHeight: 120,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      right: 16,
                      top: 62,
                      child: Container(
                        width: 303,
                        height: 160,
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              color: const Color(0xFFE1E0DF),
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: Stack(
                          children: [
                            TextField(
                              maxLines: 5,
                              decoration: InputDecoration(
                                hintText:
                                    'Add a comment, internal note, update \non the concern...',
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
                            Positioned(
                              left: 16,
                              bottom: 16,
                              child: Container(
                                width: 307,
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
                                child: TextButton(
                                  onPressed: () {
                                    // Handle comment submission
                                  },
                                  child: Text(
                                    'Add comment',
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
                          ],
                        ),
                      ),
                    ),
                    // First Activity/Comment Container
                    Positioned(
                      left: 16,
                      top: 246,
                      child: Container(
                        width: 303,
                        padding: const EdgeInsets.only(
                          left: 12,
                          top: 8,
                          bottom: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              width: 2,
                              color: const Color(0xFF030100),
                            ),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Officer Rinku ( ',
                                    style: TextStyle(
                                      color: const Color(0xFF030100),
                                      fontSize: 14,
                                      fontFamily: 'Inter Display',
                                      fontWeight: FontWeight.w500,
                                      height: 1.57,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Department of roads )',
                                    style: TextStyle(
                                      color: const Color(0xFF030100),
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
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: ShapeDecoration(
                                color: const Color(0xFFE1E0DF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Internal',
                                    style: TextStyle(
                                      color: const Color(0xFF030100),
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
                            SizedBox(
                              width: 291,
                              child: Text(
                                'Dispatched a team to assess the damage. Will update soon.',
                                style: TextStyle(
                                  color: const Color(0xFF8C8885),
                                  fontSize: 14,
                                  fontFamily: 'Inter Display',
                                  fontWeight: FontWeight.w400,
                                  height: 1.57,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            SizedBox(
                              width: 291,
                              child: Text(
                                'Apr 04, 2025 | 10:15 AM',
                                style: TextStyle(
                                  color: const Color(0xFF8C8885),
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
                    // Second Activity/Comment Container
                    Positioned(
                      left: 16,
                      top: 400,
                      child: Container(
                        width: 303,
                        padding: const EdgeInsets.only(
                          left: 12,
                          top: 8,
                          bottom: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              width: 2,
                              color: const Color(0xFFD96C07),
                            ),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Officer Rinku ( ',
                                    style: TextStyle(
                                      color: const Color(0xFF030100),
                                      fontSize: 14,
                                      fontFamily: 'Inter Display',
                                      fontWeight: FontWeight.w500,
                                      height: 1.57,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Department of roads )',
                                    style: TextStyle(
                                      color: const Color(0xFF030100),
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
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: ShapeDecoration(
                                color: const Color(0xFFE1E0DF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Public comment',
                                    style: TextStyle(
                                      color: const Color(0xFF030100),
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
                            SizedBox(
                              width: 291,
                              child: Text(
                                'Inspection completed. We need to procure materials for the repair.',
                                style: TextStyle(
                                  color: const Color(0xFF8C8885),
                                  fontSize: 14,
                                  fontFamily: 'Inter Display',
                                  fontWeight: FontWeight.w400,
                                  height: 1.57,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            SizedBox(
                              width: 291,
                              child: Text(
                                'Apr 05, 2025 | 09:30 AM',
                                style: TextStyle(
                                  color: const Color(0xFF8C8885),
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
                    // Third Activity/Comment Container
                    Positioned(
                      left: 16,
                      top: 555,
                      child: Container(
                        width: 303,
                        padding: const EdgeInsets.only(
                          left: 12,
                          top: 8,
                          bottom: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              width: 2,
                              color: const Color(0xFFD96C07),
                            ),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Officer Rinku ( ',
                                    style: TextStyle(
                                      color: const Color(0xFF030100),
                                      fontSize: 14,
                                      fontFamily: 'Inter Display',
                                      fontWeight: FontWeight.w500,
                                      height: 1.57,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Department of roads )',
                                    style: TextStyle(
                                      color: const Color(0xFF030100),
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
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: ShapeDecoration(
                                color: const Color(0xFFE1E0DF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Public comment',
                                    style: TextStyle(
                                      color: const Color(0xFF030100),
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
                            SizedBox(
                              width: 291,
                              child: Text(
                                'Grievance solved and attached 2 resolution images.',
                                style: TextStyle(
                                  color: const Color(0xFF8C8885),
                                  fontSize: 14,
                                  fontFamily: 'Inter Display',
                                  fontWeight: FontWeight.w400,
                                  height: 1.57,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            SizedBox(
                              width: 291,
                              child: Text(
                                'Apr 06, 2025 | 12:30 PM',
                                style: TextStyle(
                                  color: const Color(0xFF8C8885),
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
              ),
            ),
            const SizedBox(height: 24),
            // Location Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: MediaQuery.of(context).size.width - 40,
                height: 300,
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
                        'Location',
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
                      right: 16,
                      top: 56,
                      child: Container(
                        width: 303,
                        height: 176,
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          color: const Color(0xFF716060),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              left: -58,
                              top: -122,
                              child: Container(
                                width: 420,
                                height: 420,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/images/map.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      top: 248,
                      child: SizedBox(
                        width: 231,
                        child: Text(
                          'MG Road, near 5th Cross, central district, Doddabalapura, 560006',
                          style: TextStyle(
                            color: const Color(0xFF030100),
                            fontSize: 14,
                            fontFamily: 'Inter Display',
                            fontWeight: FontWeight.w400,
                            height: 1.57,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 16,
                      top: 248,
                      child: Container(
                        width: 56,
                        height: 40,
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              color: const Color(0xFFE1E0DF),
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/images/locB.svg',
                              width: 20,
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
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
      backgroundColor: Colors.white,
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
