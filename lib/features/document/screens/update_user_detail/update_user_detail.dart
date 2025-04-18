import 'dart:io';
import 'package:dms/data/services/user_service.dart';
import 'package:dms/features/authentication/controllers/user/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class UpdateUserDetailPage extends StatefulWidget {
  @override
  _UpdateUserDetailPageState createState() => _UpdateUserDetailPageState();
}

class _UpdateUserDetailPageState extends State<UpdateUserDetailPage> {

  bool _isLoading = false;

  Future<void> _handleUpdateUser() async {
    final userId = UserManager().id;

    if (_avatarImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Vui lòng chọn ảnh đại diện")));
      return;
    }

    setState(() => _isLoading = true);

    final avatarUrl = await UserApi.uploadAvatar(_avatarImage!, userId);

    if (avatarUrl == null) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Lỗi tải ảnh")));
      return;
    }

    final gender = _selectedGender == 'Nam' ? 'MALE' : 'FEMALE';
    final address = _addressController.text;
    final dob = DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateFormat('dd/MM/yyyy').parse(_dobController.text));

    final success = await UserApi.updateUser(
      userId: userId,
      address: address,
      dateOfBirth: dob,
      gender: gender,
      avatarUrl: avatarUrl,
    );

    setState(() => _isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Cập nhật thành công")));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Cập nhật thất bại")));
    }
  }



  // String _selectedGender = 'Sir';
  // String _selectedGender = UserManager().gender;
  String _selectedGender = UserManager().gender == 'MALE' ? 'Nam' : 'Nữ';

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController(text: 'namlee180503@gmail.com');
  final TextEditingController _addressController = TextEditingController(text: UserManager().address);
  final TextEditingController _phoneController = TextEditingController(text: '+01 1234542856');
  final TextEditingController _dobController = TextEditingController(text: UserManager().dateOfBirth);




  File? _avatarImage;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _avatarImage = File(pickedFile.path);
      });
    }
  }



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
            Navigator.pop(context);
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
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child:
              Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: _avatarImage != null
                            ? FileImage(_avatarImage!)
                            : NetworkImage(
                          UserManager().avatar.toString(),
                        ) as ImageProvider,
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: _pickImage,
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
                      ),
                    ],
                  ),
                  SizedBox(width: 16),
                  // Giới hạn chiều rộng văn bản ở đây
                  Container(
                    width: 200, // bạn có thể điều chỉnh kích thước này
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ảnh đại diện',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Cập nhật hình ảnh đại diện của bạn để cá nhân hóa thông tin.',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
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

            // Ngày sinh
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

            // ElevatedButton(
            //   onPressed: () {
            //     // Xử lý khi nhấn "Save"
            //   },
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.black,
            //     minimumSize: Size(double.infinity, 50),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(12),
            //     ),
            //   ),
            //   child: Text(
            //     'Save',
            //     style: TextStyle(fontSize: 16, color: Colors.white),
            //   ),
            // ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleUpdateUser,
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Cập nhật thông tin'),
              ),
            ),

          ],
        ),
      ),
    );
  }
}