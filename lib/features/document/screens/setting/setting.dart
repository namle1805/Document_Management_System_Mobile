import 'package:dms/features/authentication/controllers/user/user_manager.dart';
import 'package:dms/features/authentication/screens/login/login.dart';
import 'package:dms/features/authentication/screens/otp/otp_verification.dart';
import 'package:dms/features/document/screens/user_detail/user_detail.dart';
import 'package:dms/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../data/services/auth_services.dart';
import '../../../../utils/constants/colors.dart';
import '../help_center/help_center.dart';


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
                    backgroundImage: (UserManager().avatar != null && UserManager().avatar!.isNotEmpty)
                        ? NetworkImage(UserManager().avatar!)
                        : AssetImage('assets/images/home_screen/user.png'),
                  ),


                  SizedBox(height: 16),
                  Text(
                    UserManager().name,
                    // 'Nam Le',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    // 'namlee180503@gmail.com',
                    UserManager().email,
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
                    'Tài khoản của tôi',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  SettingItem(
                    icon: Iconsax.user,
                    title: 'Thông tin cá nhân',
                    onTap: () => Get.to(() => UserDetailPage(userId: UserManager().id,)),
                  ),
                  // SettingItem(
                  //   icon: Iconsax.global,
                  //   title: 'Language',
                  //   trailing: Text(
                  //     'English (US)',
                  //     style: TextStyle(color: Colors.grey),
                  //   ),
                  //   onTap: () {
                  //     // Xử lý chọn ngôn ngữ
                  //   },
                  // ),
                  SettingItem(
                    icon: Iconsax.password_check,
                    title: 'Thay đổi mật khẩu',
                    // onTap: () => Get.to(() => OtpVerificationScreen())
                    onTap: () async {

                      try {
                        await AuthService.sendOtp(email: UserManager().email);
                        Get.to(() => OtpVerificationScreen(), arguments: {'email': UserManager().email});
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString())),
                        );
                      }
                    },
                  ),
                  // SettingItem(
                  //   icon: Iconsax.setting,
                  //   title: 'Setting',
                  //   onTap: () {
                  //     // Điều hướng đến trang cài đặt
                  //   },
                  // ),
                ],
              ),
            ),
            // Notifications
            // Container(
            //   margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            //   padding: EdgeInsets.all(16),
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(12),
            //   ),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text(
            //         'Thông báo',
            //         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            //       ),
            //       SizedBox(height: 16),
            //       SettingItem(
            //         icon: Iconsax.notification,
            //         title: 'Thông báo đẩy',
            //         trailing: Switch(
            //           value: _pushNotifications,
            //           onChanged: (value) {
            //             setState(() {
            //               _pushNotifications = value;
            //             });
            //           },
            //         ),
            //         onTap: () {
            //           setState(() {
            //             _pushNotifications = !_pushNotifications;
            //           });
            //         },
            //       ),
            //       SettingItem(
            //         icon: Iconsax.notification,
            //         title: 'Promotional Notifications',
            //         trailing: Switch(
            //           value: _promotionalNotifications,
            //           onChanged: (value) {
            //             setState(() {
            //               _promotionalNotifications = value;
            //             });
            //           },
            //         ),
            //         onTap: () {
            //           setState(() {
            //             _promotionalNotifications = !_promotionalNotifications;
            //           });
            //         },
            //       ),
            //     ],
            //   ),
            // ),
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
                    'Hệ thống',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  SettingItem(
                    icon: Iconsax.info_circle,
                    title: 'Hướng dẫn sử dụng',
                    onTap: () =>
                        Get.to(() => HelpCenterPage()
                        ),),
                  //   onTap: () {
                  //     // Điều hướng đến trang cài đặt
                  //   },
                  // ),
                  SizedBox(height: 8),
                  SettingItem(
                    icon: Iconsax.logout,
                    title: 'Đăng xuất',
                    titleColor: Colors.red,
                    onTap: logout,
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
Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('isLoggedIn');
  await prefs.remove('token');
  await prefs.remove('user');
  UserManager().clear();
  // Điều hướng về màn hình đăng nhập
  Get.offAll(() => LoginScreen());
}

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
    return Material(
      color: Colors.transparent, // Đảm bảo ripple effect hiển thị đúng
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8), // Làm mượt hiệu ứng ripple
        splashColor: Colors.grey.withOpacity(0.2), // Màu hiệu ứng
        highlightColor: Colors.grey.withOpacity(0.1), // Màu nhấn giữ
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
      ),
    );
  }
}
