import 'package:dms/features/authentication/controllers/user/user_manager.dart';
import 'package:dms/features/document/screens/document_detail/document_detail.dart';
import 'package:dms/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../../data/services/task_service.dart';
import '../../models/task_detail.dart';

class TaskDetailPage extends StatefulWidget {
  final String taskId;
  const TaskDetailPage({Key? key, required this.taskId}) : super(key: key);

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {


  TaskDetail? taskDetail;
  String? scope;
  String? workflow;
  String? step;
  String? documentType;
  String? documentId;
  String? workflowId;
  String? createdBy;
  bool isLoading = true;
  bool? isUsb;

  @override
  void initState() {
    super.initState();
    fetchDetail();
  }


  void fetchDetail() async {
    final taskContent = await TaskService.fetchTaskDetail(widget.taskId);
    setState(() {
      taskDetail = taskContent?.taskDetail;
      scope = taskContent?.scope;
      workflow = taskContent?.workflowName;
      step = taskContent?.stepAction;
      workflowId = taskContent?.workflowId;
      documentId = taskContent?.documentId;
      documentType = taskContent?.documentTypeName;
      createdBy = taskContent?.userNameCreateTask;
      isUsb = taskContent?.isUsb;
      isLoading = false;
    });
  }


  String formatDateTime(String isoString) {
    final dateTime = DateTime.parse(isoString);
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  final List<Map<String, dynamic>> departments = [
    // {'name': 'Nhân sự', 'color': Colors.pink[50]!},
    // {'name': 'Hành Chính', 'color': Colors.yellow[50]!},
    // {'name': 'Đào tạo', 'color': Colors.green[50]!},
    {'name': '', 'color': Colors.blue[50]!},
    // {'name': '', 'color': Colors.orange[50]!},
    // {'name': 'Thiết kế', 'color': Colors.purple[50]!},
    // {'name': 'Nguồn lực', 'color': Colors.red[50]!},
    // {'name': 'Truyền thông', 'color': Colors.teal[50]!},
  ];


  final List<Map<String, dynamic>> viewers = [
    {
      'name': '',
      'role': '',
      'avatar': '',
      'isOnline': true,
    },
  ];

  String convertTaskType(String? taskType) {
    switch (taskType) {
      case 'Create':
        return 'Khởi tạo văn bản';
      case 'Browse':
        return 'Duyệt văn bản';
      case 'Sign':
        return 'Ký điện tử';
      case 'View':
        return 'Xem văn bản';
      case 'Upload':
        return 'Tải văn bản lên';
      case 'CreateUpload':
        return 'Khởi tạo và tải văn bản lên';
      default:
        return 'Không xác định';
    }
  }

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
                  const Expanded(
                    child: Text(
                      'Danh sách người xem',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      maxLines: 2,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.black, size: 30),
                    onPressed: () {
                      Navigator.pop(context);
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
                                backgroundImage: NetworkImage(UserManager().avatar.toString()),
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
                                UserManager().name,
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4),
                              Text(
                                UserManager().position,
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
      body:isLoading
          ? const Center(child: CircularProgressIndicator())
          : taskDetail == null
          ? const Center(child: Text('Không có dữ liệu')): SingleChildScrollView(
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
                // 'Soạn thảo nội dung cho công văn của thủ tướng chính phủ phù hợp với kế hoạch công văn',
                '${taskDetail!.title}',
                style: TextStyle(fontSize: 18, color: TColors.black, fontWeight: FontWeight.w600),
              ),
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
              child: Text(
                '${taskDetail!.description}',
                style: TextStyle(fontSize: 18, color: TColors.black, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 16),

            // Nhiệm vụ chính
            const Text(
              'Nhiệm vụ chính',
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
                '${convertTaskType(taskDetail!.taskType)}',
                style: TextStyle(fontSize: 18, color: TColors.black, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 16),


            // Loại văn bản
            const Text(
              'Loại văn bản',
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
                '${documentType}',
                style: TextStyle(fontSize: 18, color: TColors.black, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 16),



            // Thời gian bắt đầu
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Bắt đầu
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bắt đầu',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: TColors.darkerGrey_1,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: Text(
                                '${DateTime.parse(taskDetail!.startDate).hour.toString().padLeft(2, '0')}:${DateTime.parse(taskDetail!.startDate).minute.toString().padLeft(2, '0')}',
                                style: TextStyle(fontSize: 20, color: TColors.black, fontWeight: FontWeight.w600), textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ],
                  ),
                ),
                // Kết thúc
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: TColors.darkerGrey_1,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: Text(
                                '${formatDateTime(taskDetail!.startDate)}',
                                style: TextStyle(fontSize: 20, color: TColors.black, fontWeight: FontWeight.w600), textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Thời gian kết thúc
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Thời gian
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Kết thúc',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: TColors.darkerGrey_1,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: Text(
                                '${DateTime.parse(taskDetail!.endDate).hour.toString().padLeft(2, '0')}:${DateTime.parse(taskDetail!.endDate).minute.toString().padLeft(2, '0')}',
                                style: TextStyle(fontSize: 20, color: TColors.black, fontWeight: FontWeight.w600), textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ],
                  ),
                ),
                // Kết thúc
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: TColors.darkerGrey_1,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: Text(
                                '${formatDateTime(taskDetail!.endDate)}',
                                style: TextStyle(fontSize: 20, color: TColors.black, fontWeight: FontWeight.w600), textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            Text(
              'Phạm vi',
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
                scope!,
                style: TextStyle(fontSize: 18, color: TColors.black, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Luồng xử lý',
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
                workflow!,
                style: TextStyle(fontSize: 18, color: TColors.black, fontWeight: FontWeight.w600),
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
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    step!,
                    style: TextStyle(fontSize: 18, color: TColors.black, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),


            // Người tạo
            Text(
              'Người tạo',
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
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    createdBy!,
                    style: TextStyle(fontSize: 18, color: TColors.black, fontWeight: FontWeight.w600),
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
                      style: TextStyle(fontSize: 18, color: TColors.black, fontWeight: FontWeight.w500),
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
                      UserManager().divisionName,
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }).toList(),
              ),
            ),

            SizedBox(height: 24),


            // Nút "Xem chi tiết văn bản"
            ElevatedButton(
              onPressed: () => Get.to(() => DocumentDetailPage(workFlowId: workflowId!, documentId: documentId!, sizes: [], size: '', date: '', taskId: taskDetail!.taskId, isUsb: isUsb!, taskType: taskDetail!.taskType,)),
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



