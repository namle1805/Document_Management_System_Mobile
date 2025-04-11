import 'package:dms/features/authentication/screens/change_password/change_password.dart';
import 'package:dms/features/authentication/screens/login/login.dart';
import 'package:dms/features/authentication/screens/otp/otp_verification.dart';
import 'package:dms/features/document/screens/user_detail/user_detail.dart';
import 'package:dms/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/colors.dart';




class UpdateSettingsPage extends StatefulWidget {
  @override
  _UpdateSettingsPageState createState() => _UpdateSettingsPageState();
}

class _UpdateSettingsPageState extends State<UpdateSettingsPage> {
  bool _pushNotifications = false; // Trạng thái switch "Push Notifications"
  bool _promotionalNotifications = false; // Trạng thái switch "Promotional Notifications"

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Tài khoản', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white), textAlign: TextAlign.center),
        centerTitle: true,
        backgroundColor: TColors.primary,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Iconsax.arrow_left_24),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => NavigationMenu()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Thông tin người dùng (background trắng, fit chiều ngang)
            Container(
              width: double.infinity, // Đảm bảo chiều ngang fit toàn bộ màn hình
              color: Colors.white,
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Căn giữa theo chiều dọc
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                      'https://lh3.googleusercontent.com/a/ACg8ocI6cVpQdHFNblzJUq_5RBKcYxIbXDeGwP4ETCbiJLDslfMDek8J=s576-c-no', // Thay bằng URL ảnh thực tế
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Nam Le',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'namlee180503@gmail.com',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            // My Account
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Account',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  SettingItem(
                    icon: Iconsax.user,
                    title: 'Personal Information',
                    onTap: () => Get.to(() => UserDetailPage()),
                  ),
                  SettingItem(
                    icon: Iconsax.global,
                    title: 'Language',
                    trailing: Text(
                      'English (US)',
                      style: TextStyle(color: Colors.grey),
                    ),
                    onTap: () {
                      // Xử lý chọn ngôn ngữ
                    },
                  ),
                  SettingItem(
                    icon: Iconsax.password_check,
                    title: 'Thay đổi mật khẩu',
                    onTap: () => Get.to(() => OtpVerificationScreen()),
                  ),
                  SettingItem(
                    icon: Iconsax.setting,
                    title: 'Setting',
                    onTap: () {
                      // Điều hướng đến trang cài đặt
                    },
                  ),
                ],
              ),
            ),
            // Notifications
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Notifications',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  SettingItem(
                    icon: Iconsax.notification,
                    title: 'Push Notifications',
                    trailing: Switch(
                      value: _pushNotifications,
                      onChanged: (value) {
                        setState(() {
                          _pushNotifications = value;
                        });
                      },
                    ),
                    onTap: () {
                      setState(() {
                        _pushNotifications = !_pushNotifications;
                      });
                    },
                  ),
                  SettingItem(
                    icon: Iconsax.notification,
                    title: 'Promotional Notifications',
                    trailing: Switch(
                      value: _promotionalNotifications,
                      onChanged: (value) {
                        setState(() {
                          _promotionalNotifications = value;
                        });
                      },
                    ),
                    onTap: () {
                      setState(() {
                        _promotionalNotifications = !_promotionalNotifications;
                      });
                    },
                  ),
                ],
              ),
            ),
            // More
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'More',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  SettingItem(
                    icon: Iconsax.info_circle,
                    title: 'Help Center',
                    onTap: () {
                      // Điều hướng đến trang trung tâm trợ giúp
                    },
                  ),
                  SettingItem(
                    icon: Iconsax.logout,
                    title: 'Log Out',
                    titleColor: Colors.red,
                    onTap: () => Get.to(() => LoginScreen()),
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

// Widget cho mỗi mục cài đặt
class SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? titleColor;
  final Widget? trailing;
  final VoidCallback? onTap;

  SettingItem({
    required this.icon,
    required this.title,
    this.titleColor,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey, size: 24),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: titleColor ?? Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}