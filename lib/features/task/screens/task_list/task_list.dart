import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:table_calendar/table_calendar.dart';
import '../task_detail/task_detail.dart';

class TaskListPage extends StatefulWidget {
  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final List<Map<String, dynamic>> tasks = [
    {
      'date': DateTime(2025, 4, 8),
      'time': '08 AM',
      'title': 'Hoàn thành dự án',
      'timeRange': '08:00 AM - 11:00 AM',
      'isHighlighted': true,
    },
    {
      'date': DateTime(2025, 4, 8),
      'time': '09 AM',
      'title': 'Soạn thảo nội dung cho công...',
      'timeRange': '09:00 AM - 11:00 AM',
    },
    {
      'date': DateTime(2025, 4, 8),
      'time': '12 PM',
      'title': 'Phê duyệt văn bản hành chính...',
      'timeRange': '12:00 PM - 13:30 PM',
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = tasks.where((task) {
      return isSameDay(task['date'], _selectedDay);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Lịch trình',
          style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
        ),
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
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: filteredTasks.isEmpty
                ? Center(child: Text("Không có nhiệm vụ"))
                : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                final task = filteredTasks[index];
                return TaskItem(
                  time: task['time'],
                  title: task['title'],
                  timeRange: task['timeRange'],
                  isHighlighted: task['isHighlighted'] ?? false,
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

  TaskItem({
    required this.time,
    required this.title,
    required this.timeRange,
    required this.isHighlighted,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskDetailPage(
              ),
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
