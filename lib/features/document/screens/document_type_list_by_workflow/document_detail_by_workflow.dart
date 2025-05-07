// import 'dart:ui';
// import 'package:dms/features/authentication/controllers/user/user_manager.dart';
// import 'package:dms/features/document/models/document_detail.dart';
// import 'package:dms/features/document/screens/view_document/view_document.dart';
// import 'package:dms/utils/constants/image_strings.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:intl/intl.dart';
// import '../../../../data/services/document_service.dart';
// import '../../../../utils/constants/colors.dart';
//
// class DocumentDetailByWorkflowPage extends StatefulWidget {
//   final String? workFlowId;
//   final String? documentId;
//   final List<SizeInfo> sizes;
//   final String? size;
//   final String? date;
//   final String? taskId;
//
//
//
//   const DocumentDetailByWorkflowPage({
//     Key? key,
//     required this.workFlowId,
//     required this.documentId, required this.sizes, required this.size, required this.date, required this.taskId,
//   }) : super(key: key);
//
//   @override
//   _DocumentDetailByWorkflowPageState createState() => _DocumentDetailByWorkflowPageState();
// }
//
// class _DocumentDetailByWorkflowPageState extends State<DocumentDetailByWorkflowPage> {
//   bool _isContentExpanded = false;
//   late Future<DocumentDetail?> _documentDetailFuture;
//   List<String> signBys = [];
//   List<GranterInfo> granterList = [];
//   List<String> viewerList = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _documentDetailFuture = DocumentService.fetchDocumentDetail(
//       documentId: widget.documentId!,
//       workFlowId: widget.workFlowId!,
//     );
//
//     _documentDetailFuture.then((detail) {
//       if (detail != null) {
//         setState(() {
//           signBys = detail.signBys ?? [];
//           granterList = detail.granterList ?? [];
//           viewerList = detail.viewerList ?? [];
//         });
//       }
//     });
//   }
//
//   void _showViewersList(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return FutureBuilder<DocumentDetail?>(
//           future: _documentDetailFuture,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
//               return const Center(child: Text('Không có dữ liệu người xem'));
//             }
//
//             final userList = snapshot.data!.userList;
//             if (userList.isEmpty) {
//               return const Center(child: Text('Không có người xem'));
//             }
//
//             return Dialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               backgroundColor: Colors.white,
//               child: Container(
//                 padding: const EdgeInsets.all(16),
//                 constraints: BoxConstraints(
//                   maxHeight: MediaQuery.of(context).size.height * 0.6,
//                   maxWidth: MediaQuery.of(context).size.width * 0.9,
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         IconButton(
//                           icon: const Icon(Icons.arrow_circle_left_outlined, color: Colors.black, size: 30),
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                         ),
//                         Expanded(
//                           child: Text(
//                             'Danh sách người xem',
//                             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                             textAlign: TextAlign.center,
//                             softWrap: true,
//                             overflow: TextOverflow.visible,
//                             maxLines: 2,
//                           ),
//                         ),
//                         const SizedBox(width: 48),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     Expanded(
//                       child: ListView.builder(
//                         shrinkWrap: true,
//                         itemCount: userList.length,
//                         itemBuilder: (context, index) {
//                           final user = userList[index];
//                           return Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 8.0),
//                             child: Row(
//                               children: [
//                                 CircleAvatar(
//                                   radius: 24,
//                                   backgroundImage: AssetImage(TImages.user),
//                                 ),
//                                 const SizedBox(width: 16),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       if (user.fullName != null && user.fullName.isNotEmpty)
//                                         Text(
//                                           user.fullName,
//                                           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                                           softWrap: true,
//                                           overflow: TextOverflow.visible,
//                                         ),
//                                       if (user.divisionName != null && user.divisionName.isNotEmpty) ...[
//                                         const SizedBox(height: 4),
//                                         Text(
//                                           user.divisionName,
//                                           style: const TextStyle(fontSize: 14, color: Colors.grey),
//                                           softWrap: true,
//                                           overflow: TextOverflow.visible,
//                                         ),
//                                       ],
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//   void _showGrantedByList(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return FutureBuilder<DocumentDetail?>(
//           future: _documentDetailFuture,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
//               return const Center(child: Text('Không có dữ liệu người có thẩm quyền'));
//             }
//
//             final granterList = snapshot.data!.granterList ?? [];
//             if (granterList.isEmpty) {
//               return const Center(child: Text('Không có người có thẩm quyền'));
//             }
//
//             return Dialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               backgroundColor: Colors.white,
//               child: Container(
//                 padding: const EdgeInsets.all(16),
//                 constraints: BoxConstraints(
//                   maxHeight: MediaQuery.of(context).size.height * 0.6,
//                   maxWidth: MediaQuery.of(context).size.width * 0.9,
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         IconButton(
//                           icon: const Icon(Icons.arrow_circle_left_outlined, color: Colors.black, size: 30),
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                         ),
//                         Expanded(
//                           child: Text(
//                             'Danh sách người có thẩm quyền',
//                             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                             textAlign: TextAlign.center,
//                             softWrap: true,
//                             overflow: TextOverflow.visible,
//                             maxLines: 2,
//                           ),
//                         ),
//                         const SizedBox(width: 48),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     Expanded(
//                       child: ListView.builder(
//                         shrinkWrap: true,
//                         itemCount: granterList.length,
//                         itemBuilder: (context, index) {
//                           final granter = granterList[index];
//                           return Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 8.0),
//                             child: Row(
//                               children: [
//                                 CircleAvatar(
//                                   radius: 24,
//                                   backgroundImage: granter.avatar.isNotEmpty
//                                       ? NetworkImage(granter.avatar)
//                                       : AssetImage(TImages.user) as ImageProvider,
//                                 ),
//                                 const SizedBox(width: 16),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       if (granter.fullName.isNotEmpty)
//                                         Text(
//                                           granter.fullName,
//                                           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                                           softWrap: true,
//                                           overflow: TextOverflow.visible,
//                                         ),
//                                       if (granter.userName.isNotEmpty) ...[
//                                         const SizedBox(height: 4),
//                                         Text(
//                                           granter.userName,
//                                           style: const TextStyle(fontSize: 14, color: Colors.grey),
//                                           softWrap: true,
//                                           overflow: TextOverflow.visible,
//                                         ),
//                                       ],
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   void _showApproveByList(BuildContext context) {
//     if (signBys.isEmpty) {
//       return;
//     }
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           backgroundColor: Colors.white,
//           child: Container(
//             padding: const EdgeInsets.all(16),
//             constraints: BoxConstraints(
//               maxHeight: MediaQuery.of(context).size.height * 0.6,
//               maxWidth: MediaQuery.of(context).size.width * 0.9,
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.arrow_circle_left_outlined, color: Colors.black, size: 30),
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                     ),
//                     Expanded(
//                       child: Text(
//                         'Danh sách người duyệt',
//                         style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                         textAlign: TextAlign.center,
//                         softWrap: true,
//                         overflow: TextOverflow.visible,
//                         maxLines: 2,
//                       ),
//                     ),
//                     const SizedBox(width: 48),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 Expanded(
//                   child: ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: signBys.length,
//                     itemBuilder: (context, index) {
//                       final signer = signBys[index];
//                       return Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 8.0),
//                         child: Row(
//                           children: [
//                             const CircleAvatar(
//                               radius: 24,
//                               backgroundImage: AssetImage(TImages.user),
//                             ),
//                             const SizedBox(width: 16),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     signer,
//                                     style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                                     softWrap: true,
//                                     overflow: TextOverflow.visible,
//                                   ),
//                                   const SizedBox(height: 4),
//                                   const Text(
//                                     'Người duyệt',
//                                     style: TextStyle(fontSize: 14, color: Colors.grey),
//                                     softWrap: true,
//                                     overflow: TextOverflow.visible,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//
//   void _showViewerByList(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return FutureBuilder<DocumentDetail?>(
//           future: _documentDetailFuture,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
//               return const Center(child: Text('Không có dữ liệu người xem'));
//             }
//
//             final userList = snapshot.data!.userList;
//             if (userList.isEmpty) {
//               return const Center(child: Text('Không có người xem'));
//             }
//
//             return Dialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               backgroundColor: Colors.white,
//               child: Container(
//                 padding: const EdgeInsets.all(16),
//                 constraints: BoxConstraints(
//                   maxHeight: MediaQuery.of(context).size.height * 0.6,
//                   maxWidth: MediaQuery.of(context).size.width * 0.9,
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         IconButton(
//                           icon: const Icon(Icons.arrow_circle_left_outlined, color: Colors.black, size: 30),
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                         ),
//                         Expanded(
//                           child: Text(
//                             'Danh sách người xem',
//                             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                             textAlign: TextAlign.center,
//                             softWrap: true,
//                             overflow: TextOverflow.visible,
//                             maxLines: 2,
//                           ),
//                         ),
//                         const SizedBox(width: 48),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     Expanded(
//                       child: ListView.builder(
//                         shrinkWrap: true,
//                         itemCount: userList.length,
//                         itemBuilder: (context, index) {
//                           final user = userList[index];
//                           return Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 8.0),
//                             child: Row(
//                               children: [
//                                 CircleAvatar(
//                                   radius: 24,
//                                   backgroundImage: AssetImage(TImages.user),
//                                 ),
//                                 const SizedBox(width: 16),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       if (user.fullName != null && user.fullName.isNotEmpty)
//                                         Text(
//                                           user.fullName,
//                                           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                                           softWrap: true,
//                                           overflow: TextOverflow.visible,
//                                         ),
//                                       if (user.divisionName != null && user.divisionName.isNotEmpty) ...[
//                                         const SizedBox(height: 4),
//                                         Text(
//                                           user.divisionName,
//                                           style: const TextStyle(fontSize: 14, color: Colors.grey),
//                                           softWrap: true,
//                                           overflow: TextOverflow.visible,
//                                         ),
//                                       ],
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   void _showSignByList(BuildContext context) {
//     if (signBys.isEmpty) {
//       return;
//     }
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           backgroundColor: Colors.white,
//           child: Container(
//             padding: const EdgeInsets.all(16),
//             constraints: BoxConstraints(
//               maxHeight: MediaQuery.of(context).size.height * 0.6,
//               maxWidth: MediaQuery.of(context).size.width * 0.9,
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.arrow_circle_left_outlined, color: Colors.black, size: 30),
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                     ),
//                     Expanded(
//                       child: Text(
//                         'Danh sách người ký',
//                         style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                         textAlign: TextAlign.center,
//                         softWrap: true,
//                         overflow: TextOverflow.visible,
//                         maxLines: 2,
//                       ),
//                     ),
//                     const SizedBox(width: 48),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 Expanded(
//                   child: ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: signBys.length,
//                     itemBuilder: (context, index) {
//                       final signer = signBys[index];
//                       return Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 8.0),
//                         child: Row(
//                           children: [
//                             const CircleAvatar(
//                               radius: 24,
//                               backgroundImage: AssetImage(TImages.user),
//                             ),
//                             const SizedBox(width: 16),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     signer,
//                                     style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                                     softWrap: true,
//                                     overflow: TextOverflow.visible,
//                                   ),
//                                   const SizedBox(height: 4),
//                                   const Text(
//                                     'Người ký',
//                                     style: TextStyle(fontSize: 14, color: Colors.grey),
//                                     softWrap: true,
//                                     overflow: TextOverflow.visible,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   String formatDate(String dateString) {
//     DateTime dateTime = DateTime.parse(dateString);
//     final DateFormat dateFormat = DateFormat('HH:mm dd/MM/yyyy');
//     return dateFormat.format(dateTime);
//   }
//
//   String convertDocumentStatus(String status) {
//     switch (status) {
//       case 'Archived':
//         return 'Đã lưu';
//       case 'InProgress':
//         return 'Đang xử lý';
//       case 'Completed':
//         return 'Đã hoàn thành';
//       case 'Rejected':
//         return 'Đã từ chối';
//       default:
//         return 'Không xác định';
//     }
//   }
//
//   String convertScope(String scope) {
//     switch (scope) {
//       case 'OutGoing':
//         return 'Văn bản đi';
//       case 'InComing':
//         return 'Văn bản đến';
//       case 'Division':
//         return 'Phòng ban';
//       case 'School':
//         return 'Toàn trường';
//       default:
//         return 'Không xác định';
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         title: const Text(
//           'Chi tiết văn bản',
//           style: TextStyle(color: Colors.white),
//           textAlign: TextAlign.center,
//           softWrap: true,
//           overflow: TextOverflow.visible,
//         ),
//         centerTitle: true,
//         backgroundColor: TColors.primary,
//         iconTheme: const IconThemeData(color: Colors.white),
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Iconsax.arrow_left_24),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body:
//       FutureBuilder<DocumentDetail?>(
//         future: _documentDetailFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
//             return const Center(child: Text('Không thể tải dữ liệu.'));
//           }
//
//           final document = snapshot.data!;
//           final noCacheUrl = "${document.documentUrl}&t=${DateTime.now().millisecondsSinceEpoch}";
//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Hình ảnh tài liệu
//                 Center(
//                   child: Container(
//                     height: 200,
//                     width: MediaQuery.of(context).size.width * 0.9, // Responsive width
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(17),
//                     ),
//                     child: Stack(
//                       alignment: Alignment.center,
//                       children: [
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(17),
//                           child: Image.network(
//                             'https://moit.gov.vn/upload/2005517/20230717/6389864b4b2f9d217e94904689052455.jpg',
//                             fit: BoxFit.cover,
//                             width: double.infinity,
//                             height: double.infinity,
//                             errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
//                           ),
//                         ),
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(17),
//                           child: BackdropFilter(
//                             filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
//                             child: Container(
//                               color: Colors.black.withOpacity(0.2),
//                               width: double.infinity,
//                               height: double.infinity,
//                             ),
//                           ),
//                         ),
//                         IconButton(
//                           icon: const Icon(
//                             Iconsax.search_zoom_in,
//                             color: Colors.white,
//                             size: 40,
//                           ),
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => ViewDocumentPage(imageUrl: noCacheUrl, documentName: document.documentName ?? '',),
//                               ),
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 // const SizedBox(height: 16),
//                 // // Tên văn bản
//                 // Center(
//                 //   child: Text(
//                 //     document.documentName ?? '',
//                 //     style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 //     textAlign: TextAlign.center,
//                 //     softWrap: true,
//                 //     overflow: TextOverflow.visible,
//                 //   ),
//                 // ),
//                 // const SizedBox(height: 16),
//                 // // Quyết định, trạng thái, người tạo và số người tham gia
//                 // Row(
//                 //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 //   crossAxisAlignment: CrossAxisAlignment.start,
//                 //   children: [
//                 //     // Quyết định và trạng thái
//                 //     Flexible(
//                 //       child: Column(
//                 //         crossAxisAlignment: CrossAxisAlignment.start,
//                 //         children: [
//                 //           Row(
//                 //             children: [
//                 //               Container(
//                 //                 padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
//                 //                 decoration: BoxDecoration(
//                 //                   color: Colors.orange[100],
//                 //                   borderRadius: BorderRadius.circular(12),
//                 //                 ),
//                 //                 child: const Icon(
//                 //                   Iconsax.document,
//                 //                   color: Colors.orange,
//                 //                   size: 16,
//                 //                 ),
//                 //               ),
//                 //               const SizedBox(width: 8),
//                 //               Flexible(
//                 //                 child: Text(
//                 //                   document.documentTypeName ?? '',
//                 //                   style: const TextStyle(color: Colors.orange, fontSize: 12),
//                 //                   softWrap: true,
//                 //                   overflow: TextOverflow.visible,
//                 //                 ),
//                 //               ),
//                 //             ],
//                 //           ),
//                 //           const SizedBox(height: 8),
//                 //           Row(
//                 //             children: [
//                 //               Container(
//                 //                 padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
//                 //                 decoration: BoxDecoration(
//                 //                   color: Colors.green[100],
//                 //                   borderRadius: BorderRadius.circular(12),
//                 //                 ),
//                 //                 child: const Icon(
//                 //                   Iconsax.tick_circle,
//                 //                   color: Colors.green,
//                 //                   size: 16,
//                 //                 ),
//                 //               ),
//                 //               const SizedBox(width: 8),
//                 //               Flexible(
//                 //                 child: Text(
//                 //                   'Trạng thái: ${convertDocumentStatus(document.processingStatus.toString())}',
//                 //                   style: const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w600),
//                 //                   softWrap: true,
//                 //                   overflow: TextOverflow.visible,
//                 //                 ),
//                 //               ),
//                 //             ],
//                 //           ),
//                 //         ],
//                 //       ),
//                 //     ),
//                 //     // Người tạo và số người tham gia
//                 //     Flexible(
//                 //       child: Column(
//                 //         crossAxisAlignment: CrossAxisAlignment.end,
//                 //         children: [
//                 //           Row(
//                 //             mainAxisAlignment: MainAxisAlignment.end,
//                 //             children: [
//                 //               CircleAvatar(
//                 //                 radius: 12,
//                 //                 backgroundImage: NetworkImage(UserManager().avatar.toString()),
//                 //               ),
//                 //               const SizedBox(width: 8),
//                 //               Flexible(
//                 //                 child: Text(
//                 //                   UserManager().name,
//                 //                   style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
//                 //                   softWrap: true,
//                 //                   overflow: TextOverflow.visible,
//                 //                 ),
//                 //               ),
//                 //             ],
//                 //           ),
//                 //           const SizedBox(height: 8),
//                 //           Row(
//                 //             mainAxisAlignment: MainAxisAlignment.end,
//                 //             children: [
//                 //               const Icon(Iconsax.profile_2user5, size: 16),
//                 //               const SizedBox(width: 8),
//                 //               Flexible(
//                 //                 child: Text(
//                 //                   '1 Tham gia',
//                 //                   style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w400),
//                 //                   softWrap: true,
//                 //                   overflow: TextOverflow.visible,
//                 //                 ),
//                 //               ),
//                 //             ],
//                 //           ),
//                 //         ],
//                 //       ),
//                 //     ),
//                 //   ],
//                 // ),
//                 // const SizedBox(height: 16),
//                 // const Padding(
//                 //   padding: EdgeInsets.symmetric(horizontal: 30),
//                 //   child: Divider(),
//                 // ),
//                 // const SizedBox(height: 16),
//                 // // Nội dung
//                 // Column(
//                 //   crossAxisAlignment: CrossAxisAlignment.start,
//                 //   children: [
//                 //     const Text(
//                 //       'Nội dung',
//                 //       style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
//                 //     ),
//                 //     const SizedBox(height: 8),
//                 //     Text.rich(
//                 //       TextSpan(
//                 //         children: [
//                 //           TextSpan(
//                 //             text: _isContentExpanded
//                 //                 ? document.documentContent
//                 //                 :(document.documentContent?.length ?? 0) > 100
//                 //                 ? '${document.documentContent?.substring(0, 100)}... '
//                 //                 : '${document.documentContent} ',
//                 //             style: const TextStyle(fontSize: 15, color: Colors.black87),
//                 //           ),
//                 //           TextSpan(
//                 //             text: _isContentExpanded ? 'LESS' : 'MORE',
//                 //             style: const TextStyle(
//                 //               color: Colors.black,
//                 //               fontWeight: FontWeight.bold,
//                 //               fontSize: 15,
//                 //             ),
//                 //             recognizer: TapGestureRecognizer()
//                 //               ..onTap = () {
//                 //                 setState(() {
//                 //                   _isContentExpanded = !_isContentExpanded;
//                 //                 });
//                 //               },
//                 //           ),
//                 //         ],
//                 //       ),
//                 //       softWrap: true,
//                 //       overflow: TextOverflow.visible,
//                 //     ),
//                 //   ],
//                 // ),
//                 // const SizedBox(height: 16),
//                 // // Phòng ban
//                 // Row(
//                 //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 //   crossAxisAlignment: CrossAxisAlignment.start,
//                 //   children: [
//                 //     const Text(
//                 //       'Phòng ban:',
//                 //       style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                 //     ),
//                 //     Flexible(
//                 //       child: Row(
//                 //         mainAxisAlignment: MainAxisAlignment.end,
//                 //         children: [
//                 //           Container(
//                 //             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 //             decoration: BoxDecoration(
//                 //               color: Colors.red[50],
//                 //               borderRadius: BorderRadius.circular(12),
//                 //             ),
//                 //             child: Text(
//                 //               UserManager().divisionName,
//                 //               style: const TextStyle(color: Colors.red, fontSize: 12),
//                 //               softWrap: true,
//                 //               overflow: TextOverflow.visible,
//                 //             ),
//                 //           ),
//                 //         ],
//                 //       ),
//                 //     ),
//                 //   ],
//                 // ),
//                 // const SizedBox(height: 8),
//                 // // Thông tin chi tiết
//                 // InfoItem(title: 'Ngày tạo:', value: formatDate(document.createdDate ?? '')),
//                 // InfoItem(
//                 //   title: 'Ngày có hiệu lực:',
//                 //   value: document.dateIssued != null ? formatDate(document.dateIssued!) : 'Không có',
//                 // ),
//                 //
//                 // Row(
//                 //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 //   crossAxisAlignment: CrossAxisAlignment.start,
//                 //   children: [
//                 //     const Text(
//                 //       'Ký bởi:',
//                 //       style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                 //     ),
//                 //     Row(
//                 //       children: [
//                 //         GestureDetector(
//                 //           onTap: () {
//                 //             _showSignByList(context);
//                 //           },
//                 //           child: const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey),
//                 //         ),
//                 //       ],
//                 //     ),
//                 //   ],
//                 // ),
//                 // const SizedBox(height: 8),
//                 // Row(
//                 //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 //   crossAxisAlignment: CrossAxisAlignment.start,
//                 //   children: [
//                 //     const Text(
//                 //       'Người duyệt:',
//                 //       style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                 //     ),
//                 //     Row(
//                 //       children: [
//                 //         GestureDetector(
//                 //           onTap: () {
//                 //             _showApproveByList(context);
//                 //           },
//                 //           child: const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey),
//                 //         ),
//                 //       ],
//                 //     ),
//                 //   ],
//                 // ),
//                 // const SizedBox(height: 8),
//                 // InfoItem(title: 'Mã văn bản:', value: document.documentId ?? ''),
//                 // InfoItem(title: 'Số hiệu văn bản:', value: document.numberOfDocument ?? ''),
//                 // Row(
//                 //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 //   crossAxisAlignment: CrossAxisAlignment.start,
//                 //   children: [
//                 //     const Text(
//                 //       'Người xem:',
//                 //       style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                 //     ),
//                 //     Row(
//                 //       children: [
//                 //         CircleAvatar(
//                 //           radius: 12,
//                 //           backgroundImage: NetworkImage(UserManager().avatar.toString()),
//                 //         ),
//                 //         const SizedBox(width: 8),
//                 //         GestureDetector(
//                 //           onTap: () {
//                 //             _showViewersList(context);
//                 //           },
//                 //           child: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
//                 //         ),
//                 //       ],
//                 //     ),
//                 //   ],
//                 // ),
//
//                 if (document.documentUrl.isNotEmpty) const SizedBox(height: 16),
//                 if (document.documentName != null && document.documentName!.isNotEmpty)
//                   Center(
//                     child: Text(
//                       document.documentName!,
//                       style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       textAlign: TextAlign.center,
//                       softWrap: true,
//                       overflow: TextOverflow.visible,
//                     ),
//                   ),
//                 if (document.documentName != null && document.documentName!.isNotEmpty) const SizedBox(height: 16),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Flexible(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           if (document.documentTypeName != null && document.documentTypeName!.isNotEmpty)
//                             Row(
//                               children: [
//                                 Container(
//                                   padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
//                                   decoration: BoxDecoration(
//                                     color: Colors.orange[100],
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   child: const Icon(
//                                     Iconsax.document,
//                                     color: Colors.orange,
//                                     size: 16,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 8),
//                                 Flexible(
//                                   child: Text(
//                                     document.documentTypeName!,
//                                     style: const TextStyle(color: Colors.orange, fontSize: 12),
//                                     softWrap: true,
//                                     overflow: TextOverflow.visible,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           if (document.documentTypeName != null && document.documentTypeName!.isNotEmpty)
//                             const SizedBox(height: 8),
//                           if (document.processingStatus != null && document.processingStatus!.isNotEmpty)
//                             Row(
//                               children: [
//                                 Container(
//                                   padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
//                                   decoration: BoxDecoration(
//                                     color: Colors.green[100],
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   child: const Icon(
//                                     Iconsax.tick_circle,
//                                     color: Colors.green,
//                                     size: 16,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 8),
//                                 Flexible(
//                                   child: Text(
//                                     'Trạng thái: ${convertDocumentStatus(document.processingStatus!)}',
//                                     style: const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w600),
//                                     softWrap: true,
//                                     overflow: TextOverflow.visible,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                         ],
//                       ),
//                     ),
//                     Flexible(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           if (UserManager().name.isNotEmpty)
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 CircleAvatar(
//                                   radius: 12,
//                                   backgroundImage: NetworkImage(UserManager().avatar.toString()),
//                                 ),
//                                 const SizedBox(width: 8),
//                                 Flexible(
//                                   child: Text(
//                                     UserManager().name,
//                                     style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
//                                     softWrap: true,
//                                     overflow: TextOverflow.visible,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           if (UserManager().name.isNotEmpty) const SizedBox(height: 8),
//                           if (document.userList.isNotEmpty)
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 const Icon(Iconsax.profile_2user5, size: 16),
//                                 const SizedBox(width: 8),
//                                 Flexible(
//                                   child: Text(
//                                     '${document.userList.length} Tham gia',
//                                     style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w400),
//                                     softWrap: true,
//                                     overflow: TextOverflow.visible,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 30),
//                   child: Divider(),
//                 ),
//                 const SizedBox(height: 16),
//                 if (document.documentContent != null && document.documentContent!.isNotEmpty)
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Nội dung',
//                         style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 8),
//                       Text.rich(
//                         TextSpan(
//                           children: [
//                             TextSpan(
//                               text: _isContentExpanded
//                                   ? document.documentContent
//                                   : document.documentContent!.length > 100
//                                   ? '${document.documentContent!.substring(0, 100)}... '
//                                   : '${document.documentContent!} ',
//                               style: const TextStyle(fontSize: 15, color: Colors.black87),
//                             ),
//                             if (document.documentContent!.length > 100)
//                               TextSpan(
//                                 text: _isContentExpanded ? 'LESS' : 'MORE',
//                                 style: const TextStyle(
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 15,
//                                 ),
//                                 recognizer: TapGestureRecognizer()
//                                   ..onTap = () {
//                                     setState(() {
//                                       _isContentExpanded = !_isContentExpanded;
//                                     });
//                                   },
//                               ),
//                           ],
//                         ),
//                         softWrap: true,
//                         overflow: TextOverflow.visible,
//                       ),
//                     ],
//                   ),
//                 if (document.documentContent != null && document.documentContent!.isNotEmpty) const SizedBox(height: 16),
//                 if (UserManager().divisionName.isNotEmpty)
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Phòng ban:',
//                         style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                       ),
//                       Flexible(
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                               decoration: BoxDecoration(
//                                 color: Colors.red[50],
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: Text(
//                                 UserManager().divisionName,
//                                 style: const TextStyle(color: Colors.red, fontSize: 12),
//                                 softWrap: true,
//                                 overflow: TextOverflow.visible,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 if (UserManager().divisionName.isNotEmpty) const SizedBox(height: 8),
//                 if (document.scope != null && document.scope!.isNotEmpty)
//                   InfoItem(title: 'Phạm vi:', value: convertScope(document.scope!)),
//                 if (document.workFlowName != null && document.workFlowName!.isNotEmpty)
//                   InfoItem(title: 'Luồng xử lý:', value: document.workFlowName!),
//                 if (document.createdDate != null && document.createdDate!.isNotEmpty)
//                   InfoItem(title: 'Ngày tạo:', value: formatDate(document.createdDate!)),
//                 if (document.dateExpired != null && document.dateExpired!.isNotEmpty)
//                   InfoItem(
//                     title: 'Ngày hết hiệu lực:',
//                     value: formatDate(document.dateExpired!),
//                   ),
//                 if (document.deadline != null && document.deadline!.isNotEmpty)
//                   InfoItem(
//                     title: 'Hạn xử lý:',
//                     value: formatDate(document.deadline!),
//                   ),
//                 if (document.dateIssued != null && document.dateIssued!.isNotEmpty)
//                   InfoItem(
//                     title: 'Ngày ban hành:',
//                     value: formatDate(document.dateIssued!),
//                   ),
//                 if (document.sender != null && document.sender!.isNotEmpty)
//                   InfoItem(title: 'Người gửi:', value: document.sender!),
//                 if (document.receiver != null && document.receiver!.isNotEmpty)
//                   InfoItem(title: 'Người nhận:', value: document.receiver!),
//                 if (signBys.isNotEmpty)
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Ký bởi:',
//                         style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                       ),
//                       Row(
//                         children: [
//                           GestureDetector(
//                             onTap: () {
//                               _showSignByList(context);
//                             },
//                             child: const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 if (signBys.isNotEmpty) const SizedBox(height: 8),
//                 if (signBys.isNotEmpty)
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Người duyệt:',
//                         style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                       ),
//                       Row(
//                         children: [
//                           GestureDetector(
//                             onTap: () {
//                               _showApproveByList(context);
//                             },
//                             child: const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 if (signBys.isNotEmpty) const SizedBox(height: 8),
//                 if (granterList.isNotEmpty)
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Người có thẩm quyền:',
//                         style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                       ),
//                       Row(
//                         children: [
//                           GestureDetector(
//                             onTap: () {
//                               _showGrantedByList(context);
//                             },
//                             child: const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 if (granterList.isNotEmpty) const SizedBox(height: 8),
//                 if (document.userList.isNotEmpty)
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Người xem:',
//                         style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                       ),
//                       Row(
//                         children: [
//                           GestureDetector(
//                             onTap: () {
//                               _showViewerByList(context);
//                             },
//                             child: const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 if (document.userList.isNotEmpty) const SizedBox(height: 8),
//                 if (document.documentId != null && document.documentId!.isNotEmpty)
//                   InfoItem(title: 'Mã văn bản:', value: document.documentId!),
//                 if (document.numberOfDocument != null && document.numberOfDocument!.isNotEmpty)
//                   InfoItem(title: 'Số hiệu văn bản:', value: document.numberOfDocument!),
//                 if (document.userList.isNotEmpty)
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Người xem:',
//                         style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                       ),
//                       Row(
//                         children: [
//                           CircleAvatar(
//                             radius: 12,
//                             backgroundImage: NetworkImage(UserManager().avatar.toString()),
//                           ),
//                           const SizedBox(width: 8),
//                           GestureDetector(
//                             onTap: () {
//                               _showViewersList(context);
//                             },
//                             child: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
// // Widget cho mỗi mục thông tin
// class InfoItem extends StatelessWidget {
//   final String title;
//   final String value;
//
//   const InfoItem({Key? key, required this.title, required this.value}) : super(key: key);
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//             softWrap: true,
//             overflow: TextOverflow.visible,
//           ),
//           Flexible(
//             child: Text(
//               value,
//               style: const TextStyle(fontSize: 14, color: Colors.black87),
//               softWrap: true,
//               overflow: TextOverflow.visible,
//               textAlign: TextAlign.end,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'dart:ui';
import 'package:dms/features/authentication/controllers/user/user_manager.dart';
import 'package:dms/features/document/models/document_detail.dart';
import 'package:dms/features/document/screens/view_document/view_document.dart';
import 'package:dms/utils/constants/image_strings.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../../../data/services/document_service.dart';
import '../../../../utils/constants/colors.dart';

class DocumentDetailByWorkflowPage extends StatefulWidget {
  final String? workFlowId;
  final String? documentId;
  final List<SizeInfo> sizes;
  final String? size;
  final String? date;
  final String? taskId;

  const DocumentDetailByWorkflowPage({
    Key? key,
    required this.workFlowId,
    required this.documentId,
    required this.sizes,
    required this.size,
    required this.date,
    required this.taskId,
  }) : super(key: key);

  @override
  _DocumentDetailByWorkflowPageState createState() => _DocumentDetailByWorkflowPageState();
}

class _DocumentDetailByWorkflowPageState extends State<DocumentDetailByWorkflowPage> {
  bool _isContentExpanded = false;
  late Future<DocumentDetail?> _documentDetailFuture;
  List<String> signBys = [];
  List<GranterInfo> granterList = [];
  List<ViewerInfo> viewerList = [];

  @override
  void initState() {
    super.initState();
    _documentDetailFuture = DocumentService.fetchDocumentDetail(
      documentId: widget.documentId!,
      workFlowId: widget.workFlowId!,
    );

    _documentDetailFuture.then((detail) {
      if (detail != null) {
        setState(() {
          signBys = detail.signBys ?? [];
          granterList = detail.granterList ?? [];
          viewerList = detail.viewerList ?? [];
        });
      }
    });
  }

  void _showViewersList(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<DocumentDetail?>(
          future: _documentDetailFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('Không có dữ liệu người xem'));
            }

            final userList = snapshot.data!.userList;
            if (userList.isEmpty) {
              return const Center(child: Text('Không có người xem'));
            }

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: Colors.white,
              child: Container(
                padding: const EdgeInsets.all(16),
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.6,
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_circle_left_outlined, color: Colors.black, size: 30),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Expanded(
                          child: Text(
                            'Danh sách người xem',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            maxLines: 2,
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: userList.length,
                        itemBuilder: (context, index) {
                          final user = userList[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundImage: AssetImage(TImages.user),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (user.fullName != null && user.fullName.isNotEmpty)
                                        Text(
                                          user.fullName,
                                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                          softWrap: true,
                                          overflow: TextOverflow.visible,
                                        ),
                                      if (user.divisionName != null && user.divisionName.isNotEmpty) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          user.divisionName,
                                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                                          softWrap: true,
                                          overflow: TextOverflow.visible,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showGrantedByList(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<DocumentDetail?>(
          future: _documentDetailFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('Không có dữ liệu người có thẩm quyền'));
            }

            final granterList = snapshot.data!.granterList ?? [];
            if (granterList.isEmpty) {
              return const Center(child: Text('Không có người có thẩm quyền'));
            }

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: Colors.white,
              child: Container(
                padding: const EdgeInsets.all(16),
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.6,
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_circle_left_outlined, color: Colors.black, size: 30),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Expanded(
                          child: Text(
                            'Danh sách người có thẩm quyền',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            maxLines: 2,
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: granterList.length,
                        itemBuilder: (context, index) {
                          final granter = granterList[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundImage: granter.avatar.isNotEmpty
                                      ? NetworkImage(granter.avatar)
                                      : AssetImage(TImages.user) as ImageProvider,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (granter.fullName.isNotEmpty)
                                        Text(
                                          granter.fullName,
                                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                          softWrap: true,
                                          overflow: TextOverflow.visible,
                                        ),
                                      if (granter.userName.isNotEmpty) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          granter.userName,
                                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                                          softWrap: true,
                                          overflow: TextOverflow.visible,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showApproveByList(BuildContext context) {
    if (signBys.isEmpty) {
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
          child: Container(
            padding: const EdgeInsets.all(16),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6,
              maxWidth: MediaQuery.of(context).size.width * 0.9,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_circle_left_outlined, color: Colors.black, size: 30),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Expanded(
                      child: Text(
                        'Danh sách người duyệt',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        maxLines: 2,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: signBys.length,
                    itemBuilder: (context, index) {
                      final signer = signBys[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 24,
                              backgroundImage: AssetImage(TImages.user),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    signer,
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Người duyệt',
                                    style: TextStyle(fontSize: 14, color: Colors.grey),
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showViewerByList(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<DocumentDetail?>(
          future: _documentDetailFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('Không có dữ liệu người xem'));
            }

            final viewerList = snapshot.data!.viewerList ?? [];
            if (viewerList.isEmpty) {
              return const Center(child: Text('Không có người xem'));
            }

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: Colors.white,
              child: Container(
                padding: const EdgeInsets.all(16),
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.6,
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_circle_left_outlined, color: Colors.black, size: 30),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Expanded(
                          child: Text(
                            'Danh sách người xem',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            maxLines: 2,
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: viewerList.length,
                        itemBuilder: (context, index) {
                          final view = viewerList[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundImage: view.avatar.isNotEmpty
                                      ? NetworkImage(view.avatar)
                                      : AssetImage(TImages.user) as ImageProvider,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (view.fullName.isNotEmpty)
                                        Text(
                                          view.fullName,
                                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                          softWrap: true,
                                          overflow: TextOverflow.visible,
                                        ),
                                      if (view.userName.isNotEmpty) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          view.userName,
                                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                                          softWrap: true,
                                          overflow: TextOverflow.visible,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showSignByList(BuildContext context) {
    if (signBys.isEmpty) {
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
          child: Container(
            padding: const EdgeInsets.all(16),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6,
              maxWidth: MediaQuery.of(context).size.width * 0.9,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_circle_left_outlined, color: Colors.black, size: 30),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Expanded(
                      child: Text(
                        'Danh sách người ký',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        maxLines: 2,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: signBys.length,
                    itemBuilder: (context, index) {
                      final signer = signBys[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 24,
                              backgroundImage: AssetImage(TImages.user),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    signer,
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Người ký',
                                    style: TextStyle(fontSize: 14, color: Colors.grey),
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    final DateFormat dateFormat = DateFormat('HH:mm dd/MM/yyyy');
    return dateFormat.format(dateTime);
  }

  String convertDocumentStatus(String status) {
    switch (status) {
      case 'Archived':
        return 'Đã lưu';
      case 'InProgress':
        return 'Đang xử lý';
      case 'Completed':
        return 'Đã hoàn thành';
      case 'Rejected':
        return 'Đã từ chối';
      default:
        return 'Không xác định';
    }
  }

  String convertScope(String scope) {
    switch (scope) {
      case 'OutGoing':
        return 'Văn bản đi';
      case 'InComing':
        return 'Văn bản đến';
      case 'Division':
        return 'Phòng ban';
      case 'School':
        return 'Toàn trường';
      default:
        return 'Không xác định';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Chi tiết văn bản',
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
          softWrap: true,
          overflow: TextOverflow.visible,
        ),
        centerTitle: true,
        backgroundColor: TColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_24),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<DocumentDetail?>(
        future: _documentDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Không thể tải dữ liệu.'));
          }

          final document = snapshot.data!;
          final noCacheUrl = "${document.documentUrl}&t=${DateTime.now().millisecondsSinceEpoch}";
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(17),
                          child: Image.network(
                            'https://moit.gov.vn/upload/2005517/20230717/6389864b4b2f9d217e94904689052455.jpg',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(17),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: Container(
                              color: Colors.black.withOpacity(0.2),
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Iconsax.search_zoom_in,
                            color: Colors.white,
                            size: 40,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewDocumentPage(
                                  imageUrl: noCacheUrl,
                                  documentName: document.documentName ?? '',
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                if (document.documentName != null && document.documentName!.isNotEmpty)
                  const SizedBox(height: 16),
                if (document.documentName != null && document.documentName!.isNotEmpty)
                  Center(
                    child: Text(
                      document.documentName!,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                if (document.documentName != null && document.documentName!.isNotEmpty) const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (document.documentTypeName != null && document.documentTypeName!.isNotEmpty)
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.orange[100],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Iconsax.document,
                                    color: Colors.orange,
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    document.documentTypeName!,
                                    style: const TextStyle(color: Colors.orange, fontSize: 12),
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              ],
                            ),
                          if (document.documentTypeName != null && document.documentTypeName!.isNotEmpty)
                            const SizedBox(height: 8),
                          if (document.processingStatus != null && document.processingStatus!.isNotEmpty)
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.green[100],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Iconsax.tick_circle,
                                    color: Colors.green,
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    'Trạng thái: ${convertDocumentStatus(document.processingStatus!)}',
                                    style: const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w600),
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (UserManager().name.isNotEmpty)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                CircleAvatar(
                                  radius: 12,
                                  backgroundImage: NetworkImage(UserManager().avatar.toString()),
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    UserManager().name,
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              ],
                            ),
                          if (UserManager().name.isNotEmpty) const SizedBox(height: 8),
                          if (document.userList.isNotEmpty)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Icon(Iconsax.profile_2user5, size: 16),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    '${document.userList.length} Tham gia',
                                    style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w400),
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Divider(),
                ),
                const SizedBox(height: 16),
                if (document.documentContent != null && document.documentContent!.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Nội dung',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: _isContentExpanded
                                  ? document.documentContent
                                  : document.documentContent!.length > 100
                                  ? '${document.documentContent!.substring(0, 100)}... '
                                  : '${document.documentContent!}',
                              style: const TextStyle(fontSize: 15, color: Colors.black87),
                            ),
                            if (document.documentContent!.length > 100)
                              TextSpan(
                                text: _isContentExpanded ? 'LESS' : 'MORE',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    setState(() {
                                      _isContentExpanded = !_isContentExpanded;
                                    });
                                  },
                              ),
                          ],
                        ),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ],
                  ),
                if (document.documentContent != null && document.documentContent!.isNotEmpty) const SizedBox(height: 16),
                if (UserManager().divisionName.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Phòng ban:',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.red[50],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                UserManager().divisionName,
                                style: const TextStyle(color: Colors.red, fontSize: 12),
                                softWrap: true,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                if (UserManager().divisionName.isNotEmpty) const SizedBox(height: 8),
                if (document.scope != null && document.scope!.isNotEmpty)
                  InfoItem(title: 'Phạm vi:', value: convertScope(document.scope!)),
                if (document.workFlowName != null && document.workFlowName!.isNotEmpty)
                  InfoItem(title: 'Luồng xử lý:', value: document.workFlowName!),
                if (document.createdDate != null && document.createdDate!.isNotEmpty)
                  InfoItem(title: 'Ngày tạo:', value: formatDate(document.createdDate!)),
                if (document.dateExpired != null && document.dateExpired!.isNotEmpty)
                  InfoItem(
                    title: 'Ngày hết hiệu lực:',
                    value: formatDate(document.dateExpired!),
                  ),
                if (document.deadline != null && document.deadline!.isNotEmpty)
                  InfoItem(
                    title: 'Hạn xử lý:',
                    value: formatDate(document.deadline!),
                  ),
                if (document.dateIssued != null && document.dateIssued!.isNotEmpty)
                  InfoItem(
                    title: 'Ngày ban hành:',
                    value: formatDate(document.dateIssued!),
                  ),
                if (document.sender != null && document.sender!.isNotEmpty)
                  InfoItem(title: 'Người gửi:', value: document.sender!),
                if (document.receiver != null && document.receiver!.isNotEmpty)
                  InfoItem(title: 'Người nhận:', value: document.receiver!),
                if (signBys.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ký bởi:',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showSignByList(context);
                            },
                            child: const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                if (signBys.isNotEmpty) const SizedBox(height: 8),
                if (signBys.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Người duyệt:',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showApproveByList(context);
                            },
                            child: const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                if (signBys.isNotEmpty) const SizedBox(height: 8),
                if (granterList.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Người có thẩm quyền:',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showGrantedByList(context);
                            },
                            child: const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                if (granterList.isNotEmpty) const SizedBox(height: 8),
                if (document.viewerList!.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Người xem:',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showViewerByList(context);
                            },
                            child: const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                if (document.viewerList!.isNotEmpty) const SizedBox(height: 8),
                if (document.documentId != null && document.documentId!.isNotEmpty)
                  InfoItem(title: 'Mã văn bản:', value: document.documentId!),
                if (document.numberOfDocument != null && document.numberOfDocument!.isNotEmpty)
                  InfoItem(title: 'Số hiệu văn bản:', value: document.numberOfDocument!),
                if (document.userList.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Người xem:',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundImage: NetworkImage(UserManager().avatar.toString()),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              _showViewersList(context);
                            },
                            child: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class InfoItem extends StatelessWidget {
  final String title;
  final String value;

  const InfoItem({Key? key, required this.title, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            softWrap: true,
            overflow: TextOverflow.visible,
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              softWrap: true,
              overflow: TextOverflow.visible,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}