import 'package:dms/features/document/screens/document_list/document_list.dart';
import 'package:dms/features/task/screens/task_list/task_list.dart';
import 'package:dms/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';


class HomePage extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final formattedDate = DateFormat('dd MMMM, yyyy', 'vi').format(today);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Icon(Icons.menu, color: Colors.black),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage(TImages.avatar), // Thay bằng ảnh của bạn
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Text(
                'Xin chào Nam',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              // const Text(
              //   'Feb 12, 2025',
              //   style: TextStyle(fontSize: 16, color: Colors.grey),
              // ),

            Text(
              formattedDate,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),

              SizedBox(height: 16),

              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm văn bản',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Colors.black),
                  suffixIcon: Icon(Iconsax.filter_search, color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 16),

              // Loại văn bản
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Loại văn bản',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () => Get.to(() => DocumentListPage()),
                    child: const Text(
                      "Xem thêm",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Color(0xFF363942),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),

              const SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    DocumentTypeCard(
                      title: 'Quyết định',
                      count: 12,
                      progress: 0.1,
                      members: 6,
                    ),
                    SizedBox(width: 12),
                    DocumentTypeCard(
                      title: 'Quy chế',
                      count: 24,
                      progress: 0.2,
                      members: 12,
                    ),
                    SizedBox(width: 12),
                    DocumentTypeCard(
                      title: 'Thông báo',
                      count: 8,
                      progress: 0.5,
                      members: 3,
                    ),
                    // Thêm bao nhiêu card tùy thích
                  ],
                ),
              ),

              SizedBox(height: 16),

              // Nhiệm vụ hôm nay
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Nhiệm vụ hôm nay',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () => Get.to(() => TaskListPage()),
                    child: const Text(
                      "Xem thêm",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Color(0xFF363942),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              TaskCard(
                title: 'LANDING PAGE AGENCY CREATIVE',
                category: 'WEB DESIGN',
                time: '10:00 - 12:30 am',
                status: 'Đang xử lý',
              ),
              TaskCard(
                title: 'REACT JS FOR E-COMMERCE WEB',
                category: 'WEB DESIGN',
                time: '08:00 - 10:00 am',
                status: 'Chờ xác nhận',
              ),
              SizedBox(height: 16),

              // Văn bản xử lý
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Văn bản xử lý',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () => Get.to(() => TaskListPage()),
                    child: const Text(
                      "Xem thêm",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Color(0xFF363942),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              DocumentCard(
                title: 'Soạn thảo nội dung cho công ...',
                time: '9:00 PM - 11:00 PM',
                progress: 0.46,
                members: 6,
              ),
              DocumentCard(
                title: 'Đánh số & ký chỉ ký số cho văn ...',
                time: '4:00 PM - 5:00 PM',
                progress: 0.46,
                members: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget cho thẻ Loại văn bản
class DocumentTypeCard extends StatelessWidget {
  final String title;
  final int count;
  final double progress;
  final int members;

  const DocumentTypeCard({
    required this.title,
    required this.count,
    required this.progress,
    required this.members,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2DB4F4), Color(0xFFB2EBF2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            spreadRadius: 2,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 4),
          Text(
            '$count văn bản',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
          SizedBox(height: 20),
          // Progress Bar + Percentage
          Row(
            children: [
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 5,
                    backgroundColor: Colors.white24,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          // Members Avatar
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundImage: AssetImage(TImages.avatar),
                  ),
                  Positioned(
                    left: 16,
                    child: CircleAvatar(
                      radius: 12,
                      backgroundImage: AssetImage(TImages.avatar),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '+$members',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF2DB4F4),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}


// Widget cho thẻ Nhiệm vụ
class TaskCard extends StatelessWidget {
  final String title;
  final String category;
  final String time;
  final String status;

  const TaskCard({
    required this.title,
    required this.category,
    required this.time,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 4),
          // Category
          Text(
            category,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),

          // Divider
          Container(
            height: 1,
            color: Colors.grey.shade200,
          ),

          const SizedBox(height: 12),
          // Time & Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.access_time, size: 16, color: Colors.blue),
                  const SizedBox(width: 4),
                  Text(
                    time,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(0xFFE3EDFF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF3F72AF),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}


// Widget cho thẻ Văn bản xử lý
class DocumentCard extends StatelessWidget {
  final String title;
  final String time;
  final double progress;
  final int members;

  const DocumentCard({
    required this.title,
    required this.time,
    required this.progress,
    required this.members,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFE7F0EF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // Main content
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left content
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  SizedBox(
                    width: 180,
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // "Thành viên" label
                  const Text(
                    'Thành viên',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 6),

                  // Avatars
                  Row(
                    children: List.generate(
                      3,
                          (index) => Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: CircleAvatar(
                          radius: 12,
                          backgroundImage: AssetImage('assets/images/avatar${index + 1}.png'),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Time
                  Row(
                    children: [
                      const Icon(Icons.access_time_filled, size: 16, color: Colors.redAccent),
                      const SizedBox(width: 4),
                      Text(
                        time,
                        style: const TextStyle(fontSize: 13, color: Colors.black54),
                      ),
                    ],
                  ),
                ],
              ),

              // Right: Progress circle
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 52,
                    height: 52,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 5,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.black87),
                    ),
                  ),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),

          // Top-right badge
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '6d',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
