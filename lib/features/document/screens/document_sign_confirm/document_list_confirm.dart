// import 'dart:async';
// import 'dart:convert';
// import 'package:dms/features/task/screens/task_detail/task_detail.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import 'package:http/http.dart' as http;
// import 'package:get/get.dart';
// import '../../../../utils/constants/colors.dart';
// import '../../../../utils/constants/image_strings.dart';
// import '../../../../utils/constants/sizes.dart';
// import '../../../../utils/constants/text_strings.dart';
// import '../../../authentication/controllers/user/user_manager.dart';
//
// class DocumentListSignConfirmPage extends StatefulWidget {
//   final int llx;
//   final int lly;
//   final int urx;
//   final int ury;
//   final int currentPage;
//   final String documentName;
//   final String documentId;
//   final String size;
//   final String createdDate;
//   final String taskId;
//
//   const DocumentListSignConfirmPage({
//     Key? key,
//     required this.documentName,
//     required this.documentId,
//     required this.size,
//     required this.createdDate,
//     required this.llx,
//     required this.lly,
//     required this.urx,
//     required this.ury,
//     required this.currentPage,
//     required this.taskId,
//   }) : super(key: key);
//
//   @override
//   _DocumentListSignConfirmPageState createState() => _DocumentListSignConfirmPageState();
// }
//
// class _DocumentListSignConfirmPageState extends State<DocumentListSignConfirmPage> {
//   late final List<Map<String, dynamic>> documents;
//   String? signatureContent;
//
//   @override
//   void initState() {
//     super.initState();
//     documents = [
//       {
//         'type': 'PDF',
//         'title': widget.documentName,
//         'date': formatDate(widget.createdDate),
//         'size': widget.size,
//         'iconColor': Colors.red[100],
//       }
//     ];
//   }
//
//   String formatDate(String inputDate) {
//     try {
//       DateTime parsedDate = DateTime.parse(inputDate);
//       return DateFormat('dd MM yyyy').format(parsedDate);
//     } catch (e) {
//       return inputDate;
//     }
//   }
//
//   Future<void> _callSignInApi(String userName, String password, BuildContext context) async {
//     const url = 'http://103.90.227.64:5290/api/SignatureDIgitalApi/create-sign-in-signature-digital';
//     final headers = {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer ${UserManager().token}',
//     };
//     final body = jsonEncode({
//       'userName': userName,
//       'password': password,
//     });
//
//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: headers,
//         body: body,
//       );
//
//       debugPrint('Phản hồi API đăng nhập - Status: ${response.statusCode}, Body: ${response.body}');
//
//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         if (responseData['content'] != null) {
//           final content = responseData['content'];
//           if (content.contains('Không lấy được token') || content.isEmpty) {
//             debugPrint('Đăng nhập thất bại - Content: $content');
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text('Đăng nhập thất bại: $content')),
//             );
//             if (mounted) {
//               Get.dialog(_buildLoginDialog(context), barrierDismissible: false);
//             }
//             return;
//           }
//           setState(() {
//             signatureContent = content;
//           });
//           debugPrint('Đăng nhập API thành công - Content: $signatureContent');
//           if (mounted) {
//             Get.dialog(_buildPinDialog(context), barrierDismissible: false);
//           }
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Không tìm thấy content trong phản hồi API')),
//           );
//           if (mounted) {
//             Get.dialog(_buildLoginDialog(context), barrierDismissible: false);
//           }
//         }
//       } else {
//         final errorData = jsonDecode(response.body);
//         final errorMessage = errorData['message'] ?? 'Đăng nhập không thành công: ${response.statusCode}';
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(errorMessage)),
//         );
//         if (mounted) {
//           Get.dialog(_buildLoginDialog(context), barrierDismissible: false);
//         }
//       }
//     } catch (e) {
//       debugPrint('Lỗi API đăng nhập: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Lỗi khi gọi API đăng nhập')),
//       );
//       if (mounted) {
//         Get.dialog(_buildLoginDialog(context), barrierDismissible: false);
//       }
//     }
//   }
//
//   Future<void> _callCreateSignatureApi(String otpCode, BuildContext context) async {
//     if (signatureContent == null || signatureContent!.contains('Không lấy được token') || signatureContent!.isEmpty) {
//       debugPrint('Lỗi: Không tìm thấy token hợp lệ');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Không tìm thấy token hợp lệ. Vui lòng đăng nhập lại.')),
//       );
//       if (mounted) {
//         Get.dialog(_buildLoginDialog(context), barrierDismissible: false);
//       }
//       return;
//     }
//
//     const url = 'http://103.90.227.64:5290/api/SignatureDIgitalApi/create-signature-digital';
//     final headers = {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer ${UserManager().token}',
//     };
//     final body = jsonEncode({
//       'otpCode': otpCode,
//       'token': signatureContent,
//       'llx': widget.llx,
//       'lly': widget.lly,
//       'urx': widget.urx,
//       'ury': widget.ury,
//       'pageNumber': widget.currentPage,
//       'documentId': widget.documentId,
//     });
//
//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: headers,
//         body: body,
//       );
//
//       debugPrint('Phản hồi API ký tài liệu - HTTP Status: ${response.statusCode}, Body: ${response.body}');
//
//       final responseData = jsonDecode(response.body);
//       final bodyStatusCode = responseData['statusCode'] ?? 200;
//       if (response.statusCode == 200 &&
//           (bodyStatusCode == 200 || bodyStatusCode == 201) &&
//           responseData['message'] != 'Operation failed') {
//         debugPrint('Ký tài liệu API thành công: ${response.body}');
//         final approveUrl =
//             'http://103.90.227.64:5290/api/Task/create-handle-task-action?taskId=${widget.taskId}&userId=${UserManager().id}&action=SubmitDocument';
//         try {
//           final approveResponse = await http.post(
//             Uri.parse(approveUrl),
//             headers: {
//               'Content-Type': 'application/json',
//               'Authorization': 'Bearer ${UserManager().token}',
//             },
//           );
//
//           debugPrint('Phản hồi API phê duyệt - Status: ${approveResponse.statusCode}, Body: ${approveResponse.body}');
//
//           if (approveResponse.statusCode == 200) {
//             debugPrint('Phê duyệt tài liệu API thành công: ${approveResponse.body}');
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Ký và phê duyệt tài liệu thành công!')),
//             );
//             if (mounted) {
//               Navigator.pushAndRemoveUntil(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => TaskDetailPage(taskId: widget.taskId),
//                 ),
//                     (route) => false,
//               );
//             }
//           } else {
//             final errorData = jsonDecode(approveResponse.body);
//             final errorMessage = errorData['message'] ?? 'Phê duyệt tài liệu thất bại: ${approveResponse.statusCode}';
//             debugPrint('Phê duyệt thất bại: $errorMessage');
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(errorMessage)),
//             );
//           }
//         } catch (e) {
//           debugPrint('Lỗi khi gọi API phê duyệt: $e');
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Lỗi khi gọi API phê duyệt: $e')),
//           );
//         }
//       } else {
//         final errorMessage = responseData['message'] == 'Successfully created'
//             ? 'Ký tài liệu thất bại: Mã trạng thái không hợp lệ ($bodyStatusCode)'
//             : responseData['message'] ?? 'Nhập sai OTP: $bodyStatusCode';
//         debugPrint('Ký tài liệu thất bại: $errorMessage, Body: ${response.body}');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(errorMessage)),
//         );
//         if (mounted) {
//           Get.dialog(_buildPinDialog(context), barrierDismissible: false);
//         }
//       }
//     } catch (e) {
//       debugPrint('Lỗi khi gọi API ký tài liệu: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Lỗi khi gọi API ký tài liệu: $e')),
//       );
//       if (mounted) {
//         Get.dialog(_buildPinDialog(context), barrierDismissible: false);
//       }
//     }
//   }
//
//   Widget _buildLoginDialog(BuildContext context) {
//     TextEditingController emailController = TextEditingController();
//     TextEditingController passwordController = TextEditingController();
//
//     return Dialog(
//       backgroundColor: Colors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: SingleChildScrollView(
//         padding: EdgeInsets.only(
//           bottom: MediaQuery.of(context).viewInsets.bottom,
//           left: 16,
//           right: 16,
//           top: 16,
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Image(
//               height: 200,
//               image: AssetImage(TImages.lightAppLogo),
//             ),
//             Text(
//               'DMS',
//               style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: const Color(0xFF5894FE)),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Vui lòng đăng nhập tài khoản ký số',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: TColors.primary,
//               ),
//             ),
//             const SizedBox(height: 24),
//             TextField(
//               controller: emailController,
//               decoration: InputDecoration(
//                 hintText: 'Vui lòng nhập tài khoản',
//                 labelText: 'Tài khoản',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: passwordController,
//               obscureText: true,
//               decoration: InputDecoration(
//                 hintText: 'Vui lòng nhập mật khẩu',
//                 labelText: 'Mật khẩu',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   final userName = emailController.text.trim();
//                   final password = passwordController.text.trim();
//                   if (userName.isEmpty || password.isEmpty) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text('Vui lòng nhập đầy đủ tài khoản và mật khẩu')),
//                     );
//                     return;
//                   }
//                   Get.back();
//                   _callSignInApi(userName, password, context);
//                 },
//                 child: const Text('Đăng nhập'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue,
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _showLoginDialog(BuildContext context) {
//     if (!mounted) return;
//     Get.dialog(_buildLoginDialog(context), barrierDismissible: false);
//   }
//
//   Widget _buildPinDialog(BuildContext context) {
//     return PinDialog(
//       onVerify: (pin) {
//         Get.back();
//         _callCreateSignatureApi(pin, context);
//       },
//       onError: (message) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(message)),
//         );
//       },
//     );
//   }
//
//   void _showPinDialog(BuildContext context) {
//     if (!mounted) return;
//     Get.dialog(_buildPinDialog(context), barrierDismissible: false);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: const Text(
//           'Khởi tạo chức năng ký',
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 25,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           Container(
//             color: Colors.white,
//             padding: const EdgeInsets.symmetric(vertical: 8),
//             alignment: Alignment.center,
//           ),
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: documents.length,
//               itemBuilder: (context, index) {
//                 final doc = documents[index];
//                 return DocumentItem(
//                   type: doc['type'],
//                   title: doc['title'],
//                   date: doc['date'],
//                   size: doc['size'],
//                   iconColor: doc['iconColor'],
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () {
//           _showLoginDialog(context);
//         },
//         label: const Text('Xác nhận'),
//         icon: const Icon(Icons.check),
//         backgroundColor: Colors.green,
//         foregroundColor: Colors.white,
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//     );
//   }
// }
//
// class PinDialog extends StatefulWidget {
//   final Function(String) onVerify;
//   final Function(String) onError;
//
//   const PinDialog({
//     Key? key,
//     required this.onVerify,
//     required this.onError,
//   }) : super(key: key);
//
//   @override
//   _PinDialogState createState() => _PinDialogState();
// }
//
// class _PinDialogState extends State<PinDialog> {
//   final List<TextEditingController> pinControllers = List.generate(6, (index) => TextEditingController());
//   final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());
//   int remainingSeconds = 180;
//   Timer? timer;
//   bool _isMounted = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _isMounted = true;
//     startTimer();
//   }
//
//   void startTimer() {
//     timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (!_isMounted) {
//         timer.cancel();
//         return;
//       }
//       if (remainingSeconds > 0) {
//         setState(() {
//           remainingSeconds--;
//         });
//       } else {
//         timer.cancel();
//         widget.onError('Mã OTP đã hết hạn. Vui lòng yêu cầu mã mới.');
//         Get.back();
//       }
//     });
//   }
//
//   void nextField(int index, String value) {
//     if (!_isMounted) return;
//     if (value.isNotEmpty) {
//       if (index < pinControllers.length - 1) {
//         FocusScope.of(context).requestFocus(focusNodes[index + 1]);
//       } else {
//         FocusScope.of(context).unfocus();
//       }
//     } else if (index > 0) {
//       FocusScope.of(context).requestFocus(focusNodes[index - 1]);
//     }
//   }
//
//   @override
//   void dispose() {
//     _isMounted = false;
//     timer?.cancel();
//     for (var controller in pinControllers) {
//       controller.dispose();
//     }
//     for (var focusNode in focusNodes) {
//       focusNode.dispose();
//     }
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     String seconds = remainingSeconds.toString().padLeft(2, '0');
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     final otpFieldWidth = (screenWidth * 0.9 - TSizes.md * 2 - 5 * 8) / 6;
//
//     return Dialog(
//       backgroundColor: Colors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: ConstrainedBox(
//         constraints: BoxConstraints(
//           maxWidth: screenWidth * 0.9,
//           maxHeight: screenHeight * 0.7,
//         ),
//         child: SingleChildScrollView(
//           padding: EdgeInsets.only(
//             bottom: MediaQuery.of(context).viewInsets.bottom + TSizes.md,
//             left: TSizes.md,
//             right: TSizes.md,
//             top: TSizes.md,
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const Image(
//                 height: 150,
//                 image: AssetImage(TImages.lightAppLogo),
//               ),
//               Text(
//                 'DMS',
//                 style: Theme.of(context).textTheme.headlineLarge?.copyWith(
//                   color: const Color(0xFF5894FE),
//                   fontSize: 24,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: TSizes.spaceBtwItems),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
//                 child: Text(
//                   TTexts.otpVerificationSubTitle,
//                   style: Theme.of(context).textTheme.labelMedium?.copyWith(
//                     fontSize: 14,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               const SizedBox(height: TSizes.spaceBtwItems),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: List.generate(6, (index) {
//                   return SizedBox(
//                     width: otpFieldWidth,
//                     child: TextField(
//                       controller: pinControllers[index],
//                       focusNode: focusNodes[index],
//                       decoration: InputDecoration(
//                         border: const OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(8)),
//                         ),
//                         counterText: "",
//                         contentPadding: const EdgeInsets.symmetric(vertical: 10),
//                         filled: true,
//                         fillColor: Colors.grey[100],
//                       ),
//                       keyboardType: TextInputType.number,
//                       textAlign: TextAlign.center,
//                       maxLength: 1,
//                       textInputAction: index == 5 ? TextInputAction.done : TextInputAction.next,
//                       onChanged: (value) {
//                         nextField(index, value);
//                       },
//                       inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                       style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                     ),
//                   );
//                 }),
//               ),
//               const SizedBox(height: TSizes.spaceBtwItems),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(left: TSizes.md),
//                     child: Text(
//                       'Còn lại 00:$seconds',
//                       style: Theme.of(context).textTheme.labelMedium,
//                     ),
//                   ),
//                   TextButton(
//                     onPressed: remainingSeconds > 0
//                         ? null
//                         : () {
//                       if (!_isMounted) return;
//                       setState(() {
//                         remainingSeconds = 180;
//                         timer?.cancel();
//                         startTimer();
//                       });
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text('Đã gửi lại mã OTP')),
//                       );
//                     },
//                     child: const Text(
//                       TTexts.resendOTP,
//                       style: TextStyle(color: Colors.red),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: TSizes.spaceBtwItems),
//               GestureDetector(
//                 onTap: () {
//                   if (!_isMounted) return;
//                   final pin = pinControllers.map((controller) => controller.text).join();
//                   if (pin.length == 6 && RegExp(r'^\d{6}$').hasMatch(pin)) {
//                     widget.onVerify(pin);
//                   } else {
//                     widget.onError('Vui lòng nhập mã OTP 6 số hợp lệ');
//                   }
//                 },
//                 child: Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.symmetric(vertical: 15),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(15),
//                     color: Colors.blueAccent,
//                   ),
//                   child: Center(
//                     child: Text(
//                       TTexts.verificationButton,
//                       style: GoogleFonts.getFont(
//                         "Roboto Condensed",
//                         fontWeight: FontWeight.w700,
//                         color: Colors.white,
//                         fontSize: 18,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: TSizes.md),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class DocumentItem extends StatelessWidget {
//   final String type;
//   final String title;
//   final String date;
//   final String size;
//   final Color? iconColor;
//
//   const DocumentItem({
//     super.key,
//     required this.type,
//     required this.title,
//     required this.date,
//     required this.size,
//     this.iconColor,
//   });
//
//   String _getIconAsset() {
//     switch (type.toUpperCase()) {
//       case 'PDF':
//         return TImages.pdf;
//       case 'DOCX':
//         return TImages.docx;
//       case 'XLS':
//         return TImages.xls;
//       case 'SVG':
//         return TImages.svg;
//       case 'JPG':
//         return TImages.jpg;
//       default:
//         return TImages.defaultFile;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         // TODO: Chuyển đến trang chi tiết nếu cần
//       },
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 12),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: const Color(0xFFECECEC),
//             width: 1,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               spreadRadius: 2,
//               blurRadius: 5,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             Container(
//               width: 40,
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: iconColor ?? Colors.grey[200],
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Image.asset(
//                 _getIconAsset(),
//                 width: 32,
//                 height: 32,
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     '$date | $size',
//                     style: const TextStyle(fontSize: 14, color: Colors.grey),
//                   ),
//                 ],
//               ),
//             ),
//             const Icon(Icons.more_vert, color: Colors.grey),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class TabItem extends StatelessWidget {
//   final String title;
//
//   const TabItem({super.key, required this.title});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
//       child: Text(
//         title,
//         style: const TextStyle(
//           color: Colors.grey,
//           fontWeight: FontWeight.normal,
//         ),
//       ),
//     );
//   }
// }


import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../authentication/controllers/user/user_manager.dart';
import '../../../task/screens/task_detail/task_detail.dart';
import '../setting/setting.dart';

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
    required this.currentPage,
    required this.taskId,
  }) : super(key: key);

  @override
  _DocumentListSignConfirmPageState createState() => _DocumentListSignConfirmPageState();
}

class _DocumentListSignConfirmPageState extends State<DocumentListSignConfirmPage> {
  late final List<Map<String, dynamic>> documents;
  String? signatureContent;
  String? _userName; // Store username for resend OTP
  String? _password; // Store password for resend OTP

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
      return inputDate;
    }
  }

  Widget _buildLoadingDialog(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            const SizedBox(width: 16),
            Text(
              'Đang xử lý...',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _callSignInApi(String userName, String password, BuildContext context) async {
    if (mounted) {
      Get.dialog(_buildLoadingDialog(context), barrierDismissible: false);
    }

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

      debugPrint('Phản hồi API đăng nhập - Status: ${response.statusCode}, Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['content'] != null) {
          final content = responseData['content'];
          if (content.contains('Không lấy được token') || content.isEmpty) {
            debugPrint('Đăng nhập thất bại - Content: $content');
            if (mounted) {
              Get.back(); // Close loading dialog
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Đăng nhập thất bại: $content')),
              );
              Get.dialog(_buildLoginDialog(context), barrierDismissible: false);
            }
            return;
          }
          setState(() {
            signatureContent = content;
            _userName = userName; // Store username
            _password = password; // Store password
          });
          debugPrint('Đăng nhập API thành công - Content: $signatureContent');
          if (mounted) {
            Get.back(); // Close loading dialog
            Get.dialog(_buildPinDialog(context), barrierDismissible: false);
          }
        } else {
          if (mounted) {
            Get.back(); // Close loading dialog
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Không tìm thấy content trong phản hồi API')),
            );
            Get.dialog(_buildLoginDialog(context), barrierDismissible: false);
          }
        }
      } else {
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['message'] ?? 'Đăng nhập không thành công: ${response.statusCode}';
        if (mounted) {
          Get.back(); // Close loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
          Get.dialog(_buildLoginDialog(context), barrierDismissible: false);
        }
      }
    } catch (e) {
      debugPrint('Lỗi API đăng nhập: $e');
      if (mounted) {
        Get.back(); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi gọi API đăng nhập: $e')),
        );
        Get.dialog(_buildLoginDialog(context), barrierDismissible: false);
      }
    }
  }

  Future<void> _callCreateSignatureApi(String otpCode, BuildContext context) async {
    if (signatureContent == null || signatureContent!.contains('Không lấy được token') || signatureContent!.isEmpty) {
      debugPrint('Lỗi: Không tìm thấy token hợp lệ');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không tìm thấy token hợp lệ. Vui lòng đăng nhập lại.')),
        );
        Get.dialog(_buildLoginDialog(context), barrierDismissible: false);
      }
      return;
    }

    if (mounted) {
      Get.dialog(_buildLoadingDialog(context), barrierDismissible: false);
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

      debugPrint('Phản hồi API ký tài liệu - HTTP Status: ${response.statusCode}, Body: ${response.body}');

      final responseData = jsonDecode(response.body);
      final bodyStatusCode = responseData['statusCode'] ?? 200;
      if (response.statusCode == 200 &&
          (bodyStatusCode == 200 || bodyStatusCode == 201) &&
          responseData['message'] != 'Operation failed') {
        debugPrint('Ký tài liệu API thành công: ${response.body}');
        final approveUrl =
            'http://103.90.227.64:5290/api/Task/create-handle-task-action?taskId=${widget.taskId}&userId=${UserManager().id}&action=ApproveDocument';
        try {
          final approveResponse = await http.post(
            Uri.parse(approveUrl),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${UserManager().token}',
            },
          );

          debugPrint('Phản hồi API phê duyệt - Status: ${approveResponse.statusCode}, Body: ${approveResponse.body}');

          if (approveResponse.statusCode == 200) {
            debugPrint('Phê duyệt tài liệu API thành công: ${approveResponse.body}');
            if (mounted) {
              Get.back(); // Close loading dialog
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Ký và phê duyệt tài liệu thành công!')),
              );
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskDetailPage(taskId: widget.taskId),
                ),
                    (route) => false,
              );
            }
          } else {
            final errorData = jsonDecode(approveResponse.body);
            final errorMessage = errorData['message'] ?? 'Phê duyệt tài liệu thất bại: ${approveResponse.statusCode}';
            debugPrint('Phê duyệt thất bại: $errorMessage');
            if (mounted) {
              Get.back(); // Close loading dialog
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(errorMessage)),
              );
            }
          }
        } catch (e) {
          debugPrint('Lỗi khi gọi API phê duyệt: $e');
          if (mounted) {
            Get.back(); // Close loading dialog
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Lỗi khi gọi API phê duyệt: $e')),
            );
          }
        }
      } else {
        final errorMessage = responseData['message'] == 'Successfully created'
            ? 'Ký tài liệu thất bại: Mã trạng thái không hợp lệ ($bodyStatusCode)'
            : responseData['message'] ?? 'Nhập sai OTP: $bodyStatusCode';
        debugPrint('Ký tài liệu thất bại: $errorMessage, Body: ${response.body}');
        if (mounted) {
          Get.back(); // Close loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
          Get.dialog(_buildPinDialog(context), barrierDismissible: false);
        }
      }
    } catch (e) {
      debugPrint('Lỗi khi gọi API ký tài liệu: $e');
      if (mounted) {
        Get.back(); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi gọi API ký tài liệu: $e')),
        );
        Get.dialog(_buildPinDialog(context), barrierDismissible: false);
      }
    }
  }

  Widget _buildLoginDialog(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
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
                  Get.back();
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
  }

  void _showLoginDialog(BuildContext context) {
    if (!mounted) return;
    Get.dialog(_buildLoginDialog(context), barrierDismissible: false);
  }

  Widget _buildPinDialog(BuildContext context) {
    return PinDialog(
      userName: _userName,
      password: _password,
      onVerify: (pin) {
        Get.back();
        _callCreateSignatureApi(pin, context);
      },
      onError: (message) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      },
      onResend: _callSignInApi,
      onShowLoginDialog: () => _showLoginDialog(context),
    );
  }

  void _showPinDialog(BuildContext context) {
    if (!mounted) return;
    Get.dialog(_buildPinDialog(context), barrierDismissible: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: 16,
            backgroundImage: AssetImage(
              'assets/logos/dms-document-management-system-digital-business-cloud-storage-icon-digital-data_100456-10606.jpg',
            ),
          ),
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
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Get.to(() => UpdateSettingsPage());
              },
              child: CircleAvatar(
                backgroundImage: (UserManager().avatar != null && UserManager().avatar!.isNotEmpty)
                    ? NetworkImage(UserManager().avatar!)
                    : const AssetImage('assets/images/home_screen/user.png') as ImageProvider,
              ),
            ),
          ),
        ],
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
  final String? userName;
  final String? password;
  final Function(String) onVerify;
  final Function(String) onError;
  final Function(String, String, BuildContext) onResend;
  final VoidCallback onShowLoginDialog;

  const PinDialog({
    Key? key,
    this.userName,
    this.password,
    required this.onVerify,
    required this.onError,
    required this.onResend,
    required this.onShowLoginDialog,
  }) : super(key: key);

  @override
  _PinDialogState createState() => _PinDialogState();
}

class _PinDialogState extends State<PinDialog> {
  final List<TextEditingController> pinControllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());
  int remainingSeconds = 180;
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
        widget.onError('Mã OTP đã hết hạn. Vui lòng yêu cầu mã mới.');
      }
    });
  }

  void nextField(int index, String value) {
    if (!_isMounted) return;
    if (value.isNotEmpty) {
      if (index < pinControllers.length - 1) {
        FocusScope.of(context).requestFocus(focusNodes[index + 1]);
      } else {
        FocusScope.of(context).unfocus();
      }
    } else if (index > 0) {
      FocusScope.of(context).requestFocus(focusNodes[index - 1]);
    }
  }

  void clearOtpFields() {
    for (var controller in pinControllers) {
      controller.clear();
    }
  }

  @override
  void dispose() {
    _isMounted = false;
    timer?.cancel();
    for (var controller in pinControllers) {
      controller.dispose();
    }
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String seconds = remainingSeconds.toString().padLeft(2, '0');
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final otpFieldWidth = (screenWidth * 0.12).clamp(40.0, 60.0); // 12% of screen width, clamped between 40 and 60
    final otpFieldHeight = (screenWidth * 0.12).clamp(40.0, 60.0); // Match width for square fields
    final fontSize = (screenWidth * 0.05).clamp(16.0, 24.0); // Responsive font size
    final spacing = screenWidth * 0.02; // 2% of screen width for spacing

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: screenWidth * 0.9,
          maxHeight: screenHeight * 0.7,
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
                  return Flexible(
                    child: Container(
                      width: otpFieldWidth,
                      height: otpFieldHeight,
                      margin: EdgeInsets.symmetric(horizontal: spacing / 2),
                      child: TextField(
                        controller: pinControllers[index],
                        focusNode: focusNodes[index],
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          counterText: "",
                          contentPadding: EdgeInsets.zero,
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        textInputAction: index == 5 ? TextInputAction.done : TextInputAction.next,
                        onChanged: (value) {
                          nextField(index, value);
                        },
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                          height: 1.0,
                        ),
                      ),
                    ),
                  );
                }),
              ),
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
                        : () async {
                      if (!_isMounted) return;
                      if (widget.userName == null || widget.password == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Vui lòng đăng nhập lại để gửi lại mã OTP')),
                        );
                        Get.back();
                        widget.onShowLoginDialog();
                        return;
                      }
                      try {
                        await widget.onResend(widget.userName!, widget.password!, context);
                        setState(() {
                          remainingSeconds = 180;
                          timer?.cancel();
                          startTimer();
                          clearOtpFields();
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Đã gửi lại mã OTP đến ${widget.userName}')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Lỗi khi gửi lại OTP: $e')),
                        );
                      }
                    },
                    child: Text(
                      TTexts.resendOTP,
                      style: TextStyle(color: remainingSeconds == 0 ? Colors.red : Colors.grey),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              GestureDetector(
                onTap: () {
                  if (!_isMounted) return;
                  final pin = pinControllers.map((controller) => controller.text).join();
                  if (pin.length == 6 && RegExp(r'^\d{6}$').hasMatch(pin)) {
                    widget.onVerify(pin);
                  } else {
                    widget.onError('Vui lòng nhập mã OTP 6 số hợp lệ');
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

class DocumentItem extends StatelessWidget {
  final String type;
  final String title;
  final String date;
  final String size;
  final Color? iconColor;

  const DocumentItem({
    super.key,
    required this.type,
    required this.title,
    required this.date,
    required this.size,
    this.iconColor,
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
        // TODO: Chuyển đến trang chi tiết nếu cần
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
                color: iconColor ?? Colors.grey[200],
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

class TabItem extends StatelessWidget {
  final String title;

  const TabItem({super.key, required this.title});

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