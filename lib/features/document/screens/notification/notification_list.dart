import 'package:dms/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class NotificationListPage extends StatelessWidget {
  // Danh sách thông báo (dữ liệu mẫu)
  final List<Map<String, dynamic>> notifications = [
    {
      'section': 'Hôm nay',
      'items': [
        {
          'avatar': 'https://lh3.googleusercontent.com/a/ACg8ocI6cVpQdHFNblzJUq_5RBKcYxIbXDeGwP4ETCbiJLDslfMDek8J=s576-c-no',
          'title': 'Hà Công Hiệu vừa gửi văn bản đi của công văn tới cho bạn',
          'content': '9:01am',
          'isRead': false,
        },
        {
          'avatar': 'https://lh3.googleusercontent.com/a/ACg8ocI6cVpQdHFNblzJUq_5RBKcYxIbXDeGwP4ETCbiJLDslfMDek8J=s576-c-no',
          'title': 'Hà Công Hiệu vừa gửi văn bản đi của công văn tới cho bạn',
          'content': '9:01am',
          'isRead': false,
        },
        {
          'avatar': 'https://lh3.googleusercontent.com/a/ACg8ocI6cVpQdHFNblzJUq_5RBKcYxIbXDeGwP4ETCbiJLDslfMDek8J=s576-c-no',
          'title': 'Nhật Minh đã gửi văn bản nghị định và đối bạn duyệt văn bản',
          'content': '9:01am',
          'isRead': false,
        },
      ],
    },
    {
      'section': 'Hôm qua',
      'items': [
        {
          'avatar': 'https://lh3.googleusercontent.com/a/ACg8ocI6cVpQdHFNblzJUq_5RBKcYxIbXDeGwP4ETCbiJLDslfMDek8J=s576-c-no',
          'title': 'Nam Lê đã gửi đến thời gian phải duyệt xong văn bản...',
          'content': '9:01am',
          'isRead': true,
        },
        {
          'avatar': 'https://lh3.googleusercontent.com/a/ACg8ocI6cVpQdHFNblzJUq_5RBKcYxIbXDeGwP4ETCbiJLDslfMDek8J=s576-c-no',
          'title': 'Hà Công Hiệu vừa gửi văn bản đi của công văn tới cho bạn',
          'content': '9:01am',
          'isRead': true,
        },
      ],
    },
    {
      'section': 'Tuần này',
      'items': [
        {
          'avatar': 'https://lh3.googleusercontent.com/a/ACg8ocI6cVpQdHFNblzJUq_5RBKcYxIbXDeGwP4ETCbiJLDslfMDek8J=s576-c-no',
          'title': 'Nam Lê đã gửi đến thời gian phải duyệt xong văn bản...',
          'content': '9:01am',
          'isRead': true,
        },
        {
          'avatar': 'https://lh3.googleusercontent.com/a/ACg8ocI6cVpQdHFNblzJUq_5RBKcYxIbXDeGwP4ETCbiJLDslfMDek8J=s576-c-no',
          'title': 'Hà Công Hiệu vừa gửi văn bản đi của công văn tới cho bạn',
          'content': '9:01am',
          'isRead': true,
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.to(() => NavigationMenu()),
        ),
        title: const Text(
          'Thông báo',
          style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 8),
        itemCount: notifications.length,
        itemBuilder: (context, sectionIndex) {
          final section = notifications[sectionIndex];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tiêu đề phần (Hôm nay, Hôm qua, Tuần này)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                child: Text(
                  section['section'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              // Danh sách thông báo trong phần
              ...section['items'].asMap().entries.map<Widget>((entry) {
                final item = entry.value;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Ảnh đại diện
                      CircleAvatar(
                        radius: 28,
                        backgroundImage: NetworkImage(item['avatar']),
                      ),
                      SizedBox(width: 12),
                      // Nội dung thông báo
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title'],
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: item['isRead'] ? Colors.grey : Colors.black,
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item['content'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10), // chỉnh tùy ý
                              child: Divider(),
                            ),

                          ],
                        ),
                      ),
                    ],

                  ),
                );
              }).toList(),
            ],
          );
        },
      ),
    );
  }
}