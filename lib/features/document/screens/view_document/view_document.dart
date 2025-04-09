// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:iconsax/iconsax.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'dart:io';
//
// // class ViewDocumentPage extends StatefulWidget {
// //   const ViewDocumentPage({super.key});
// //
// //   @override
// //   State<ViewDocumentPage> createState() => _ViewDocumentPageState();
// // }
// //
// // class _ViewDocumentPageState extends State<ViewDocumentPage> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         centerTitle: true,
// //         title: Text("PDF View"),
// //       ));
// //     //   body:
// //     //   SfPdfViewer.network('https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf'),
// //     // );
// //   }
// // }
// //
//
//
// class ViewDocumentPage extends StatefulWidget {
//   @override
//   _ViewDocumentPageState createState() => _ViewDocumentPageState();
// }
//
// class _ViewDocumentPageState extends State<ViewDocumentPage> {
//   String? localPath; // Đường dẫn file PDF đã tải về
//   bool isLoading = true; // Trạng thái tải file
//
//   @override
//   void initState() {
//     super.initState();
//     _downloadAndSavePDF();
//   }
//
//   // Hàm tải file PDF từ URL và lưu vào thiết bị
//   Future<void> _downloadAndSavePDF() async {
//     try {
//       // URL của file PDF (thay bằng URL thực tế của bạn)
//       const pdfUrl = 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf';
//       final response = await http.get(Uri.parse(pdfUrl));
//
//       // Lấy thư mục tạm để lưu file
//       final directory = await getTemporaryDirectory();
//       final filePath = '${directory.path}/document.pdf';
//       final file = File(filePath);
//
//       // Lưu file PDF vào thiết bị
//       await file.writeAsBytes(response.bodyBytes);
//       setState(() {
//         localPath = filePath;
//         isLoading = false;
//       });
//     } catch (e) {
//       print('Error downloading PDF: $e');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.blue),
//           onPressed: () {
//             Navigator.pop(context); // Quay lại màn hình trước
//           },
//         ),
//         title: Text(
//           'Quyết định 53/2015 QĐ-TTg chi...',
//           style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
//           overflow: TextOverflow.ellipsis,
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Iconsax.more, color: Colors.black),
//             onPressed: () {
//               // Xử lý khi nhấn nút ba chấm
//             },
//           ),
//         ],
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator()) // Hiển thị loading khi đang tải PDF
//           : localPath != null
//           ? PDFView(
//         filePath: localPath!, // Đường dẫn file PDF đã tải về
//         enableSwipe: true,
//         swipeHorizontal: false,
//         autoSpacing: true,
//         pageFling: true,
//         onError: (error) {
//           print('Error loading PDF: $error');
//         },
//         onPageError: (page, error) {
//           print('Error on page $page: $error');
//         },
//       )
//           : Center(child: Text('Không thể tải file PDF')),
//       bottomNavigationBar: BottomNavigationBar(
//         items: [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifications'),
//           BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks'),
//           BottomNavigationBarItem(icon: Icon(Icons.file_copy), label: 'Types'),
//         ],
//         selectedItemColor: Colors.blue,
//         unselectedItemColor: Colors.grey,
//         currentIndex: 3, // Tab "Types" được chọn
//       ),
//     );
//   }
// }