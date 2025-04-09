import 'package:dms/features/document/screens/update_user_detail/update_user_detail.dart';
import 'package:dms/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';


class UserDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Phần thông tin người dùng
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              '2209',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              'Văn bản',
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          'https://lh3.googleusercontent.com/a/ACg8ocI6cVpQdHFNblzJUq_5RBKcYxIbXDeGwP4ETCbiJLDslfMDek8J=s576-c-no',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),

                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              '80',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              'Văn bản đang xử lý',
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),
                  // Tên và vai trò
                  Text(
                    'Nam Lê',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Lãnh đạo',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  SizedBox(height: 16),
                  // Nút "Edit profile" và biểu tượng ba chấm
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => Get.to(() => UpdateUserDetailPage()),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF4B7BE5),
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Edit profile',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 16),
                      IconButton(
                        icon: Icon(Icons.more_vert, color: Color(0xFF4B7BE5)),
                        onPressed: () {
                          // Xử lý khi nhấn nút ba chấm
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Phần thông tin chi tiết
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Vai trò
                  InfoItem(
                    icon: Iconsax.user,
                    title: 'Role',
                    value: 'Leader',
                    iconColor: Colors.black,
                  ),
                  SizedBox(height: 16),
                  // Vị trí
                  InfoItem(
                    icon: Iconsax.location,
                    title: 'Location',
                    value: 'Bến Nghé, Quận 1, TP.HCM',
                    iconColor: Color(0xFFFBCB0A),
                  ),
                  SizedBox(height: 16),
                  // Ngày sinh
                  InfoItem(
                    icon: Iconsax.clock,
                    title: 'Ngày sinh',
                    value: 'May 18 2003',
                    iconColor: Color(0xFF37E2D5),
                  ),
                  SizedBox(height: 16),
                  // Email
                  InfoItem(
                    icon: Icons.email_outlined,
                    title: 'Email',
                    value: 'namlee180503@gmail.com',
                    iconColor: Color(0xFFF73D93),
                  ),
                  SizedBox(height: 16),
                  // Số điện thoại
                  InfoItem(
                    icon: Iconsax.call,
                    title: 'Phone',
                    value: '+01 1234542856',
                    iconColor: Color(0xFFEE5007),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget cho mỗi mục thông tin
class InfoItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color iconColor; // mới thêm

  InfoItem({
    required this.icon,
    required this.title,
    required this.value,
    this.iconColor = Colors.grey, // default
  });

  @override
  Widget build(BuildContext context) {
    return
      Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TColors.darkerGrey_1,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 24),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 14, color: TColors.black, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
