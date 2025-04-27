import 'dart:async';
import 'dart:convert';
import 'package:dms/features/task/screens/task_detail/task_detail.dart';
import 'package:dms/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../authentication/controllers/user/user_manager.dart';


class DocumentListSignConfirmPage extends StatefulWidget {
  final int llx;
  final int lly;
  final int urx;
  final int ury;
  final int currentPage;
  final String documentName;
  final String documentId;
  final String size;
  final String createdDate;
  final String taskId;

  const DocumentListSignConfirmPage({
    Key? key,
    required this.documentName,
    required this.documentId,
    required this.size,
    required this.createdDate,
    required this.llx,
    required this.lly,
    required this.urx,
    required this.ury,
    required this.currentPage, required this.taskId,
  }) : super(key: key);

  @override
  _DocumentListSignConfirmPageState createState() => _DocumentListSignConfirmPageState();
}

class _DocumentListSignConfirmPageState extends State<DocumentListSignConfirmPage> {
  late final List<Map<String, dynamic>> documents;
  String? signatureContent; // Biến để lưu giá trị content từ API

  @override
  void initState() {
    super.initState();
    documents = [
      {
        'type': 'PDF',
        'title': widget.documentName,
        'date': formatDate(widget.createdDate),
        'size': widget.size,
        'iconColor': Colors.red[100],
      }
    ];
  }

  String formatDate(String inputDate) {
    try {
      DateTime parsedDate = DateTime.parse(inputDate);
      return DateFormat('dd MM yyyy').format(parsedDate);
    } catch (e) {
      return inputDate; // Nếu lỗi thì trả về như cũ
    }
  }

  Future<void> _callSignInApi(String userName, String password, BuildContext context) async {
    const url = 'http://103.90.227.64:5290/api/SignatureDIgitalApi/create-sign-in-signature-digital';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${UserManager().token}',
    };
    final body = jsonEncode({
      'userName': userName,
      'password': password,
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          signatureContent = responseData['content']; // Lưu giá trị content
        });
        debugPrint('API Success - Content: $signatureContent');
        _showPinDialog(context); // Chuyển sang dialog PIN sau khi gọi API thành công
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đăng nhập thất bại: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi gọi API: $e')),
      );
    }
  }

  Future<void> _callCreateSignatureApi(String otpCode, BuildContext context) async {
    if (signatureContent == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không tìm thấy token. Vui lòng đăng nhập lại.')),
      );
      return;
    }

    const url = 'http://103.90.227.64:5290/api/SignatureDIgitalApi/create-signature-digital';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${UserManager().token}',
    };
    final body = jsonEncode({
      'otpCode': otpCode,
      'token': signatureContent,
      'llx': widget.llx,
      'lly': widget.lly,
      'urx': widget.urx,
      'ury': widget.ury,
      'pageNumber': widget.currentPage,
      'documentId': widget.documentId,
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        debugPrint('Create Signature API Success: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ký tài liệu thành công!')),
        );

        // Gọi API create-handle-task-action sau khi ký tài liệu thành công
        final approveUrl = 'http://103.90.227.64:5290/api/Task/create-handle-task-action?taskId=${widget.taskId}&userId=${UserManager().id}&action=ApproveDocument';
        try {
          final approveResponse = await http.post(
            Uri.parse(approveUrl),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${UserManager().token}',
            },
          );

          if (approveResponse.statusCode == 200) {
            debugPrint('Approve Document API Success: ${approveResponse.body}');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Phê duyệt tài liệu thất bại: ${approveResponse.statusCode}')),
            );
            return; // Dừng lại nếu API phê duyệt thất bại
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi khi gọi API phê duyệt: $e')),
          );
          return; // Dừng lại nếu có lỗi
        }

        // Điều hướng về TaskDetailPage sau khi gọi API phê duyệt thành công
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => TaskDetailPage(taskId: widget.taskId),
          ),
              (route) => false, // Xóa toàn bộ stack và chuyển về TaskDetailPage
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ký tài liệu thất bại: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi gọi API: $e')),
      );
    }
  }
  void _showLoginDialog(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(dialogContext).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Image(
                  height: 200,
                  image: AssetImage(TImages.lightAppLogo),
                ),
                Text(
                  'DMS',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: const Color(0xFF5894FE)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Vui lòng đăng nhập tài khoản ký số',
                  style: TextStyle(
                    fontSize: 16,
                    color: TColors.primary,
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Vui lòng nhập tài khoản',
                    labelText: 'Tài khoản',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Vui lòng nhập mật khẩu',
                    labelText: 'Mật khẩu',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final userName = emailController.text.trim();
                      final password = passwordController.text.trim();
                      if (userName.isEmpty || password.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Vui lòng nhập đầy đủ tài khoản và mật khẩu')),
                        );
                        return;
                      }
                      Navigator.pop(dialogContext);
                      _callSignInApi(userName, password, context);
                    },
                    child: const Text('Đăng nhập'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    ).whenComplete(() {
      emailController.dispose();
      passwordController.dispose();
    });
  }

  void _showPinDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return PinDialog(
          onVerify: (pin) {
            Navigator.pop(dialogContext);
            _callCreateSignatureApi(pin, context);
          },
          onError: (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
          },
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
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Khởi tạo chức năng ký',
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8),
            alignment: Alignment.center,
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final doc = documents[index];
                return DocumentItem(
                  type: doc['type'],
                  title: doc['title'],
                  date: doc['date'],
                  size: doc['size'],
                  iconColor: doc['iconColor'],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showLoginDialog(context);
        },
        label: const Text('Xác nhận'),
        icon: const Icon(Icons.check),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class PinDialog extends StatefulWidget {
  final Function(String) onVerify;
  final Function(String) onError;

  const PinDialog({
    Key? key,
    required this.onVerify,
    required this.onError,
  }) : super(key: key);

  @override
  _PinDialogState createState() => _PinDialogState();
}

class _PinDialogState extends State<PinDialog> {
  final List<TextEditingController> pinControllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());
  int remainingSeconds = 180; // 3 phút = 180 giây
  Timer? timer;
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isMounted) {
        timer.cancel();
        return;
      }
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void nextField(int index, String value) {
    if (!_isMounted) return;
    if (value.isNotEmpty) {
      if (index < pinControllers.length - 1) {
        FocusScope.of(context).requestFocus(focusNodes[index + 1]);
      } else {
        FocusScope.of(context).unfocus(); // Ẩn bàn phím khi nhập ô cuối
      }
    } else if (index > 0) {
      FocusScope.of(context).requestFocus(focusNodes[index - 1]);
    }
  }

  @override
  void dispose() {
    _isMounted = false;
    timer?.cancel();
    pinControllers.forEach((controller) => controller.dispose());
    focusNodes.forEach((focusNode) => focusNode.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String seconds = remainingSeconds.toString().padLeft(2, '0');
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final otpFieldWidth = (screenWidth * 0.9 - TSizes.md * 2 - 5 * 8) / 6; // Tính chiều rộng mỗi ô OTP

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: screenWidth * 0.9, // Giới hạn chiều rộng tối đa là 90% màn hình
          maxHeight: screenHeight * 0.7, // Giới hạn chiều cao tối đa là 70% màn hình
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + TSizes.md,
            left: TSizes.md,
            right: TSizes.md,
            top: TSizes.md,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Image(
                height: 150,
                image: AssetImage(TImages.lightAppLogo),
              ),
              Text(
                'DMS',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: const Color(0xFF5894FE),
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
                child: Text(
                  TTexts.otpVerificationSubTitle,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(6, (index) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: SizedBox(
                    height: 50,
                    child: TextField(
                      controller: pinControllers[index],
                      focusNode: focusNodes[index],
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        counterText: "",
                      ),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        nextField(index, value);
                      },
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                ),
              );
            }),),
              const SizedBox(height: TSizes.spaceBtwItems),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: TSizes.md),
                    child: Text(
                      'Còn lại 00:$seconds',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                  TextButton(
                    onPressed: remainingSeconds > 0
                        ? null
                        : () {
                      if (!_isMounted) return;
                      setState(() {
                        remainingSeconds = 180;
                        timer?.cancel();
                        startTimer();
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Đã gửi lại mã PIN')),
                      );
                    },
                    child: const Text(
                      TTexts.resendOTP,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              GestureDetector(
                onTap: () {
                  if (!_isMounted) return;
                  final pin = pinControllers.map((controller) => controller.text).join();
                  if (pin.length == 6) {
                    widget.onVerify(pin);
                  } else {
                    widget.onError('Vui lòng nhập mã PIN 6 số');
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.blueAccent,
                  ),
                  child: Center(
                    child: Text(
                      TTexts.verificationButton,
                      style: GoogleFonts.getFont(
                        "Roboto Condensed",
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: TSizes.md),
            ],
          ),
        ),
      ),
    );
  }
}

class TabItem extends StatelessWidget {
  final String title;

  const TabItem({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}

class DocumentItem extends StatelessWidget {
  final String type;
  final String title;
  final String date;
  final String size;
  final Color iconColor;

  const DocumentItem({
    super.key,
    required this.type,
    required this.title,
    required this.date,
    required this.size,
    required this.iconColor,
  });

  String _getIconAsset() {
    switch (type.toUpperCase()) {
      case 'PDF':
        return TImages.pdf;
      case 'DOCX':
        return TImages.docx;
      case 'XLS':
        return TImages.xls;
      case 'SVG':
        return TImages.svg;
      case 'JPG':
        return TImages.jpg;
      default:
        return TImages.defaultFile;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 👉 Chuyển đến trang chi tiết
        // Get.to(() => DocumentDetailPage());
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFECECEC),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset(
                _getIconAsset(),
                width: 32,
                height: 32,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$date | $size',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Icon(Icons.more_vert, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}