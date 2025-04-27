import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../data/repositories/task_repository.dart';
import '../../models/task_model.dart';
import '../task_detail/task_detail.dart';


class TaskListPage extends StatefulWidget {
  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<Task> allTasks = [];

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    fetchTaskData();
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
    }
  }

  @override
  // Widget build(BuildContext context) {
  //   final filteredTasks = allTasks.where((task) {
  //     return isSameDay(task.startDate, _selectedDay);
  //   }).toList();
  //
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Lịch trình'),
  //       centerTitle: true,
  //     ),
  //     body: Column(
  //       children: [
  //         TableCalendar(
  //           firstDay: DateTime(2020),
  //           lastDay: DateTime(2030),
  //           focusedDay: _focusedDay,
  //           selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
  //           onDaySelected: (selected, focused) {
  //             setState(() {
  //               _selectedDay = selected;
  //               _focusedDay = focused;
  //             });
  //           },
  //           calendarFormat: CalendarFormat.week,
  //         ),
  //         Expanded(
  //           child: filteredTasks.isEmpty
  //               ? Center(child: Text("Không có nhiệm vụ"))
  //               : ListView.builder(
  //             padding: EdgeInsets.all(16),
  //             itemCount: filteredTasks.length,
  //             itemBuilder: (context, index) {
  //               final task = filteredTasks[index];
  //               final startTime = task.startDate.hour.toString().padLeft(2, '0') + ':' + task.startDate.minute.toString().padLeft(2, '0');
  //               final timeRange = '${task.startDate.hour}:${task.startDate.minute.toString().padLeft(2, '0')} - ${task.endDate.hour}:${task.endDate.minute.toString().padLeft(2, '0')}';
  //               return TaskItem(
  //                 time: startTime,
  //                 title: task.title,
  //                 timeRange: timeRange,
  //                 isHighlighted: task.taskStatus == 'Completed', taskId: task.taskId,
  //               );
  //             },
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // Lọc các task theo ngày được chọn
    final filteredTasks = allTasks.where((task) {
      return isSameDay(task.startDate, _selectedDay);
    }).toList();

    // Sắp xếp các task theo thời gian bắt đầu (startDate) từ thấp đến cao
    filteredTasks.sort((a, b) => a.startDate.compareTo(b.startDate));

    return Scaffold(
      appBar: AppBar(
        title: Text('Lịch trình'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2020),
            lastDay: DateTime(2030),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selected, focused) {
              setState(() {
                _selectedDay = selected;
                _focusedDay = focused;
              });
            },
            calendarFormat: CalendarFormat.week,
          ),
          Expanded(
            child: filteredTasks.isEmpty
                ? Center(child: Text("Không có nhiệm vụ"))
                : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                final task = filteredTasks[index];
                final startTime = task.startDate.hour.toString().padLeft(2, '0') +
                    ':' +
                    task.startDate.minute.toString().padLeft(2, '0');
                final timeRange =
                    '${task.startDate.hour}:${task.startDate.minute.toString().padLeft(2, '0')} - '
                    '${task.endDate.hour}:${task.endDate.minute.toString().padLeft(2, '0')}';
                return TaskItem(
                  time: startTime,
                  title: task.title,
                  timeRange: timeRange,
                  isHighlighted: task.taskStatus == 'Completed',
                  taskId: task.taskId,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


class TaskItem extends StatelessWidget {
  final String time;
  final String title;
  final String timeRange;
  final bool isHighlighted;
  final String taskId;

  const TaskItem({
    required this.time,
    required this.title,
    required this.timeRange,
    required this.isHighlighted,
    required this.taskId,
  });

  @override
  Widget build(BuildContext context) {
        return GestureDetector(
        // onTap: () {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => TaskDetailPage(
        //       ),
        //     ),
        //   );
        // },
            onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskDetailPage(taskId: taskId),
            ),
          );
        },


    child:  Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Text(
                time,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              SizedBox(height: 4),
              Container(width: 2, height: 60, color: Colors.grey[300]),
            ],
          ),
          SizedBox(width: 16),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isHighlighted ? Colors.blue : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isHighlighted ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    timeRange,
                    style: TextStyle(
                      fontSize: 14,
                      color: isHighlighted ? Colors.white70 : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}