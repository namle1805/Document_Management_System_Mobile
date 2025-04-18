import 'package:dms/features/document/screens/update_user_detail/update_user_detail.dart';
import 'package:dms/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../data/services/user_service.dart';
import '../../../authentication/models/user_model.dart';

class UserDetailPage extends StatefulWidget {
  final String userId;

  const UserDetailPage({required this.userId, super.key});

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  late Future<UserModel> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = UserApi.fetchUserDetails(widget.userId);
  }

  Future<void> _refreshUserData() async {
    setState(() {
      _userFuture = UserApi.fetchUserDetails(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Thông tin cá nhân',
          style: TextStyle(
              color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<UserModel>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi tải dữ liệu: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Không có dữ liệu người dùng'));
          } else {
            UserModel user = snapshot.data!;
            print('Avatar URL: ${user.avatar}');
            return RefreshIndicator(
              onRefresh: _refreshUserData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    const Text(
                                      '2209',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const Text(
                                      'Văn bản',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  user.avatar.isNotEmpty
                                      ? user.avatar
                                      : 'https://cdn-icons-png.flaticon.com/128/3177/3177440.png',
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: const [
                                    Text(
                                      '80',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      '  Văn bản\n đang xử lý',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            user.fullName ?? 'Chưa có tên',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.roleName ?? 'Chưa có vai trò',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.grey),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () =>
                                    Get.to(() => UpdateUserDetailPage()),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4B7BE5),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Edit profile',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ),
                              const SizedBox(width: 16),
                              // IconButton(
                              //   icon: const Icon(Icons.more_vert, color: Color(0xFF4B7BE5)),
                              //   onPressed: () {},
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          InfoItem(
                            icon: Iconsax.user,
                            title: 'Họ và tên',
                            value: user.fullName,
                            iconColor: Colors.black,
                          ),
                          SizedBox(height: 16),
                          InfoItem(
                            icon: Iconsax.user_tag,
                            title: 'Username',
                            value: user.userName,
                            iconColor: Colors.black,
                          ),
                          SizedBox(height: 16),
                          InfoItem(
                            icon: Iconsax.profile_2user,
                            title: 'Giới tính',
                            value: user.gender,
                            iconColor: Colors.black,
                          ),
                          SizedBox(height: 16),
                          InfoItem(
                            icon: Icons.perm_identity,
                            title: 'CCCD',
                            value: user.identityCard,
                            iconColor: Colors.black,
                          ),
                          SizedBox(height: 16),
                          InfoItem(
                            icon: Iconsax.security_user,
                            title: 'Vị trí',
                            value: user.position,
                            iconColor: Colors.black,
                          ),
                          SizedBox(height: 16),
                          InfoItem(
                            icon: LucideIcons.building,
                            title: 'Phòng ban',
                            value: user.divisionName,
                            iconColor: Colors.black,
                          ),
                          SizedBox(height: 16),
                          InfoItem(
                            icon: Iconsax.location,
                            title: 'Địa chỉ',
                            value: user.address,
                            iconColor: Colors.black,
                          ),
                          SizedBox(height: 16),
                          InfoItem(
                            icon: Iconsax.clock,
                            title: 'Ngày sinh',
                            value: user.dateOfBirth,
                            iconColor: Colors.black,
                          ),
                          SizedBox(height: 16),
                          InfoItem(
                            icon: Icons.email_outlined,
                            title: 'Email',
                            value: user.email,
                            iconColor: Colors.black,
                          ),
                          SizedBox(height: 16),
                          InfoItem(
                            icon: Iconsax.call,
                            title: 'Số điện thoại',
                            value: user.phoneNumber,
                            iconColor: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class InfoItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color iconColor;

  InfoItem({
    required this.icon,
    required this.title,
    required this.value,
    this.iconColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        crossAxisAlignment:
            CrossAxisAlignment.start, // Đảm bảo nội dung không bị lệch
        children: [
          Icon(icon, color: iconColor, size: 24),
          SizedBox(width: 16),
          Expanded(
            // Cho phép nội dung chiếm không gian còn lại
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: TColors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey[800],
                  ),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
