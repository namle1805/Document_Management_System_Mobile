import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class UpdateUserDetailPage extends StatefulWidget {
  @override
  _UpdateUserDetailPageState createState() => _UpdateUserDetailPageState();
}

class _UpdateUserDetailPageState extends State<UpdateUserDetailPage> {
  String _selectedGender = 'Sir'; // Giá trị mặc định cho giới tính
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController(text: 'namlee180503@gmail.com');
  final TextEditingController _addressController = TextEditingController(text: 'Bến Nghé, Quận 1, TP.HCM');
  final TextEditingController _phoneController = TextEditingController(text: '+01 1234542856');
  final TextEditingController _dobController = TextEditingController();


  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Quay lại màn hình trước
          },
        ),
        title: Text(
          'Trở lại',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thông tin tài khoản',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            // Ảnh đại diện với biểu tượng "add"
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!, width: 1), // Thêm stroke (đường viền)
                borderRadius: BorderRadius.circular(12), // Bo góc
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start, // Căn giữa nội dung
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                          'https://lh3.googleusercontent.com/a/ACg8ocI6cVpQdHFNblzJUq_5RBKcYxIbXDeGwP4ETCbiJLDslfMDek8J=s576-c-no', // Thay bằng URL ảnh thực tế
                        ),
                      ),
                      // Biểu tượng "add" ở góc dưới bên phải
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ảnh đại diện',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Cập nhật hình ảnh đại diện \ncủa bạn để cá nhân hóa thông tin.',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            // Giới tính
            Text(
              'Gender',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Radio<String>(
                  value: 'Nam',
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value!;
                    });
                  },
                ),
                Text('Nam'),
                SizedBox(width: 24),
                Radio<String>(
                  value: 'Nữ',
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value!;
                    });
                  },
                ),
                Text('Nữ'),
              ],
            ),
            SizedBox(height: 24),

            // Tên
            Text(
              'Ngày sinh & Địa chi',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );

                if (pickedDate != null) {
                  String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
                  _dobController.text = formattedDate;
                }
              },
              child: AbsorbPointer(
                child: TextField(
                  controller: _dobController,
                  decoration: InputDecoration(
                    labelText: 'Ngày sinh',
                    suffixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 16),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Địa chỉ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 24),

            // Nút "Save"
            ElevatedButton(
              onPressed: () {
                // Xử lý khi nhấn nút "Save"
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Save',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}