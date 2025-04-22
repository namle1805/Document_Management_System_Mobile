import 'package:dms/features/authentication/controllers/user/user_manager.dart';
import 'package:dms/features/document/screens/setting/setting.dart';
import 'package:dms/features/task/screens/task_detail/task_detail.dart';
import 'package:dms/features/task/screens/task_list/task_list.dart';
import 'package:dms/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../../../data/repositories/document_type_repository.dart';
import '../../../../data/repositories/task_repository.dart';
import '../../../task/models/task_model.dart';
import '../../models/document_type.dart';
import '../document_list/document_belong_type_list.dart';
import '../document_list/document_list.dart';
import '../search_document/search_document.dart';


class HomePage extends StatefulWidget {

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<Task> allTasks = [];
  List<DocumentType> _documentTypes = [];
  bool isLoading = true;



  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    fetchTaskData();
    fetchDocumentTypes();
  }


  Future<void> fetchTaskData() async {
    try {
      final repo = TaskRepository();
      final tasks = await repo.fetchTasks();
      setState(() {
        allTasks = tasks;
      });
    } catch (e) {
      print("Error fetching tasks: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchDocumentTypes() async {
    try {
      final repo = DocumentTypeRepository();
      final data = await repo.fetchDocumentTypes();
      setState(() {
        _documentTypes = data;
      });
    } catch (e) {
      print("Lỗi khi lấy danh sách document types: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  Future<void> _refreshData() async {
    // Gọi API hoặc reload dữ liệu ở đây
    await fetchDocumentTypes(); // Ví dụ: gọi lại API lấy loại văn bản
    await fetchTaskData();         // Ví dụ: gọi lại danh sách nhiệm vụ

    setState(() {}); // Cập nhật giao diện sau khi load lại
  }


  String convertTaskStatus(String status) {
    switch (status) {
      case 'Pending':
        return 'Đang chờ xác nhận';
      case 'Revised':
        return 'Cần chỉnh sửa';
      case 'InProgress':
        return 'Đang trong quá trình xử lý';
      case 'Completed':
        return 'Đã hoàn thành';
      default:
        return 'Không xác định';
    }
  }





  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final formattedDate = DateFormat('dd MMMM, yyyy', 'vi').format(today);
    final TextEditingController _searchController = TextEditingController();
    final completedTasks = allTasks
        .where((task) => task.taskStatus == 'Completed')
        .toList();

    final pendingTasks = allTasks.where((task) =>
    task.taskStatus == 'Pending' ||
        task.taskStatus == 'Revised' ||
        task.taskStatus == 'InProgress').toList();

    final processingTasks = allTasks.where((task) =>
    task.taskStatus == 'Pending' ||
        task.taskStatus == 'Revised' ||
        task.taskStatus == 'InProgress').toList();
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Icon(Icons.menu, color: Colors.black),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:
            GestureDetector(
              onTap: () {
                Get.to(() => UpdateSettingsPage());
              },
              child:
              CircleAvatar(
                // radius: 40,
                backgroundImage: (UserManager().avatar != null && UserManager().avatar!.isNotEmpty)
                    ? NetworkImage(UserManager().avatar!)
                    : AssetImage('assets/images/home_screen/user.png'),
              ),
            ),
          ),
        ],
      ),
    body: RefreshIndicator(
    onRefresh: _refreshData,
    child: SingleChildScrollView(

        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Xin chào ${UserManager().name.isNotEmpty ? UserManager().name : "bạn"}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                formattedDate,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _searchController,
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchDocumentPage(searchQuery: value.trim()),
                      ),
                    );
                  }
                },
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
              Text('Loại văn bản', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _documentTypes.map((doc) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: DocumentTypeCard(
                        title: doc.name,
                        count: 10,          // hoặc đếm thực tế nếu có
                        progress: doc.percent,      // gán tạm
                        members: 1, avatar: UserManager().avatar.toString(), documentTypeId: doc.id, workFlowId: '092abc80-61e9-46c3-84c4-91f8d4d19554', typeName: doc.name,         // tạm gán
                      ),
                    );
                  }).toList(),
                ),
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
              //
              // ...allTasks
              //     .where((task) =>
              // task.taskStatus == 'Pending' ||
              //     task.taskStatus == 'Revised' ||
              //     task.taskStatus == 'InProgress')
              // .take(2)
              //     .map((task) {
              //   double progress = 0;
              //   if (task.taskStatus == 'InProgress') {
              //     progress = 0.5;
              //   }
              //
              //   return DocumentCard(
              //     title: task.title ?? '',
              //     time: '${task.startDate.hour}:${task.startDate.minute.toString().padLeft(2, '0')} - ${task.endDate.hour}:${task.endDate.minute.toString().padLeft(2, '0')}',
              //     progress: progress,
              //     members: 1,
              //     taskId: task.taskId, status: convertTaskStatus(task.taskStatus ?? ''), workflow: task.workflowName,
              //   );
              // }).toList(),

              pendingTasks.isEmpty
                  ? const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'Không có văn bản xử lý',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              )
                  : Column(
                children: pendingTasks.take(2).map((task) {
                  double progress = 0;
                  if (task.taskStatus == 'InProgress') {
                    progress = 0.5;
                  }

                  return DocumentCard(
                    title: task.title ?? '',
                    time:
                    '${task.startDate.hour}:${task.startDate.minute.toString().padLeft(2, '0')} - ${task.endDate.hour}:${task.endDate.minute.toString().padLeft(2, '0')}',
                    progress: progress,
                    members: 1,
                    taskId: task.taskId,
                    status: convertTaskStatus(task.taskStatus ?? ''),
                    workflow: task.workflowName,
                  );
                }).toList(),
              ),


              // Nhiệm vụ đã hoàn thành
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Nhiệm vụ đã hoàn thành',
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
              // ...allTasks
              //     .where((task) => task.taskStatus == 'Completed')
              //     .take(2)
              //     .map((task) => TaskCard(
              //   title: task.title ?? '',
              //   category: task.taskType ?? '',
              //   time: '${task.startDate.hour}:${task.startDate.minute.toString().padLeft(2, '0')} - ${task.endDate.hour}:${task.endDate.minute.toString().padLeft(2, '0')}',
              //   status: convertTaskStatus(task.taskStatus ?? ''),
              //   taskId: task.taskId,
              // )),

              completedTasks.isEmpty
                  ? const Center(
                child: Text(
                  'Không có nhiệm vụ hoàn thành',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
                  : Column(
                children: completedTasks.take(2).map((task) => TaskCard(
                  title: task.title ?? '',
                  category: task.taskType ?? '',
                  time: '${task.startDate.hour}:${task.startDate.minute.toString().padLeft(2, '0')} - ${task.endDate.hour}:${task.endDate.minute.toString().padLeft(2, '0')}',
                  status: convertTaskStatus(task.taskStatus ?? ''),
                  taskId: task.taskId,
                )).toList(),
              ),


              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    ));
  }
}

// Widget cho thẻ Loại văn bản
class DocumentTypeCard extends StatelessWidget {
  final String title;
  final String avatar;
  final String documentTypeId;
  final String workFlowId;
  final String typeName;
  final int count;
  final double progress;
  final int members;

  const DocumentTypeCard({
    required this.title,
    required this.count,
    required this.progress,
    required this.members, required this.avatar, required this.documentTypeId, required this.workFlowId, required this.typeName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DocumentsListPage(workFlowId:'092abc80-61e9-46c3-84c4-91f8d4d19554' , documentTypeId: documentTypeId, typeName: typeName,
            ),
          ),
        );
      },
      child: Container(
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
                      backgroundImage: NetworkImage(avatar),
                    ),
                  ],
                ),
                SizedBox(width: 8),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// Widget cho thẻ Văn bản xử lý
class DocumentCard extends StatelessWidget {
  final String title;
  final String time;
  final String status;
  final String workflow;
  final String taskId;
  final double progress;
  final int members;

  const DocumentCard({
    required this.title,
    required this.time,
    required this.progress,
    required this.members, required this.taskId, required this.status, required this.workflow,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => TaskDetailPage(taskId: taskId,
            ),));
      },
      child: Container(
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

                    // "workflow" label
                    Text(
                      workflow,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 6),

                    // Avatars
                    Row(
                      children: List.generate(
                        1,
                            (index) => Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: CircleAvatar(
                            radius: 12,
                            backgroundImage: NetworkImage(UserManager().avatar.toString()),
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
                Column(
                  children: [
                    const SizedBox(height: 16), // <-- Add spacing here
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
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
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
  final String taskId;


  const TaskCard({
    super.key,
    required this.title,
    required this.category,
    required this.time,
    required this.status, required this.taskId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TaskDetailPage(taskId: taskId,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
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
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              category,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            Container(height: 1, color: Colors.grey.shade200),
            const SizedBox(height: 12),
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
                    color: const Color(0xFFE3EDFF),
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
      ),
    );
  }
}


