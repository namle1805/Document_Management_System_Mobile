import 'package:dms/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';


class TaskDetailPage extends StatelessWidget {
  final List<Map<String, dynamic>> departments = [
    {'name': 'Nhân sự', 'color': Colors.pink[50]!},
    {'name': 'Hành Chính', 'color': Colors.yellow[50]!},
    {'name': 'Đào tạo', 'color': Colors.green[50]!},
    {'name': 'Công nghệ thông tin', 'color': Colors.blue[50]!},
    {'name': 'Lãnh đạo', 'color': Colors.orange[50]!},
    {'name': 'Thiết kế', 'color': Colors.purple[50]!},
    {'name': 'Nguồn lực', 'color': Colors.red[50]!},
    {'name': 'Truyền thông', 'color': Colors.teal[50]!},
  ];


  final List<Map<String, dynamic>> viewers = [
    {
      'name': 'Maria Morgan',
      'role': 'Nhân viên văn thư',
      'avatar': 'https://via.placeholder.com/150',
      'isOnline': true,
    },
    {
      'name': 'Piter Walberg',
      'role': 'Nhân viên phòng - CNTT',
      'avatar': 'https://via.placeholder.com/150',
      'isOnline': false,
    },
    {
      'name': 'Jessica Gold',
      'role': 'Trưởng phòng CNTT',
      'avatar': 'https://via.placeholder.com/150',
      'isOnline': false,
    },
    {
      'name': 'Michael Word',
      'role': 'Lãnh đạo',
      'avatar': 'https://via.placeholder.com/150',
      'isOnline': true,
    },
    {
      'name': 'Sara Parker',
      'role': 'Chánh văn phòng',
      'avatar': 'https://via.placeholder.com/150',
      'isOnline': false,
    },
  ];

  // Hàm hiển thị bottom sheet
  void _showViewersList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Tiêu đề
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Danh sách người xem',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context); // Đóng bottom sheet
                    },
                  ),
                ],
              ),
              SizedBox(height: 8),
              // Danh sách người xem
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: viewers.length,
                  itemBuilder: (context, index) {
                    final viewer = viewers[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          // Avatar
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundImage: NetworkImage(viewer['avatar']),
                              ),
                              if (viewer['isOnline'])
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 2),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(width: 16),
                          // Tên và vai trò
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                viewer['name'],
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4),
                              Text(
                                viewer['role'],
                                style: TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Iconsax.arrow_left_24),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Chi tiết',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              'Tiêu đề',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: TColors.grey_1),
            ),
            SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: TColors.darkerGrey_1,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child:  Text(
                'Soạn thảo nội dung cho công văn của...',
                style: TextStyle(fontSize: 16, color: TColors.black, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 16),

            const Text(
              'Ngày',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
            SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: TColors.darkerGrey_1,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Saturday, Feb 22 2025',
                    style: TextStyle(fontSize: 16, color: TColors.black, fontWeight: FontWeight.w600),
                  ),
                  Icon(Icons.calendar_today, color: Colors.black),
                ],
              ),
            ),
            SizedBox(height: 16),

            Text(
              'Lý do xử lý',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
            SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: TColors.darkerGrey_1,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Text(
                'Văn bản ra',
                style: TextStyle(fontSize: 16, color: TColors.black, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 16),

            // Thời gian bắt đầu và kết thúc
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bắt đầu',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                    ),
                    SizedBox(height: 8),
                    Container(
                      width: 120,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: TColors.darkerGrey_1,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Text(
                        '09 : 00',
                        style: TextStyle(fontSize: 16, color: TColors.black, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24),
                    Container(
                      width: 50,
                      padding: EdgeInsets.all(12),
                      child: const Text(
                        'PM',
                        style: TextStyle(fontSize: 16, color: TColors.black, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kết thúc',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                    ),
                    SizedBox(height: 8),
                    Container(
                      width: 120,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: TColors.darkerGrey_1,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: const Text(
                        '11 : 00',
                        style: TextStyle(fontSize: 16, color: TColors.black, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24),
                    Container(
                      width: 50,
                      padding: EdgeInsets.all(12),
                      child: const Text(
                        'PM',
                        style: TextStyle(fontSize: 16, color: TColors.black, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),

            // Mô tả
            const Text(
              'Mô tả',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
            SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: TColors.darkerGrey_1,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: const Text(
                'Công văn của phòng hành chính cần soạn thảo nội dung chi tiết',
                style: TextStyle(fontSize: 16, color: TColors.black, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 16),

            // Bước thực hiện hiện tại
            Text(
              'Bước thực hiện hiện tại',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
            SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: TColors.darkerGrey_1,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Step 7: Lãnh đạo soạn thảo văn bản',
                    style: TextStyle(fontSize: 16, color: TColors.black, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            Text(
              'Người tham gia',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
            SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                _showViewersList(context); // Hiển thị danh sách người xem
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: TColors.darkerGrey_1,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Xem chi tiết',
                      style: TextStyle(fontSize: 16, color: TColors.black, fontWeight: FontWeight.w600),
                    ),
                    Icon(Iconsax.arrow_right_3, color: Colors.grey),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            // Phòng ban
            Text(
              'Phòng ban',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
            SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: TColors.darkerGrey_1,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: departments.map((dept) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: dept['color'],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      dept['name'],
                      style: TextStyle(fontSize: 14),
                    ),
                  );
                }).toList(),
              ),
            ),

            SizedBox(height: 24),


            // Nút "Xem chi tiết văn bản"
            ElevatedButton(
              onPressed: () {
                // Xử lý khi nhấn nút
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Xem chi tiết văn bản',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}