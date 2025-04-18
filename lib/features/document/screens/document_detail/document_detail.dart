import 'dart:ui';
import 'package:dms/features/authentication/controllers/user/user_manager.dart';
import 'package:dms/features/document/models/document_detail.dart';
import 'package:dms/features/document/screens/document_list/document_belong_type_list.dart';
import 'package:dms/features/document/screens/view_document/view_document.dart';
import 'package:dms/utils/constants/image_strings.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../data/services/document_service.dart';
import '../../../../utils/constants/colors.dart';


class DocumentDetailPage extends StatefulWidget {
  final String workFlowId;
  final String documentId;

  const DocumentDetailPage({
    required this.workFlowId, required this.documentId,
  });

  @override
  _DocumentDetailPageState createState() => _DocumentDetailPageState();
}

class _DocumentDetailPageState extends State<DocumentDetailPage> {
  bool _isContentExpanded = false;

  late Future<DocumentDetail?> _documentDetailFuture;

  @override
  void initState() {
    super.initState();
    _documentDetailFuture = DocumentService.fetchDocumentDetail(
      documentId: widget.documentId,
      workFlowId: widget.workFlowId,
    );

    _documentDetailFuture.then((detail) {
      if (detail != null) {
        setState(() {
          signBys = detail.signBys ?? [];
        });
      }
    });
  }


  // Danh sách người xem (dữ liệu mẫu)
  final List<Map<String, dynamic>> viewers = [
    {
      'name': 'Maria Morgan',
      'role': 'Nhân viên văn thư',
      'avatar': 'https://lh3.googleusercontent.com/a/ACg8ocI6cVpQdHFNblzJUq_5RBKcYxIbXDeGwP4ETCbiJLDslfMDek8J=s576-c-no',
      'isOnline': false,
    }
  ];

   List<String> signBys = [
  ];

  void _showViewersList(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
          child: Container(
            padding: EdgeInsets.all(16),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6, // Giới hạn chiều cao dialog
              maxWidth: MediaQuery.of(context).size.width * 0.9, // Giới hạn chiều rộng dialog
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_circle_left_outlined, color: Colors.black, size: 30),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Expanded(
                      child: Text(
                        'Danh sách người xem',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        maxLines: 2,
                      ),
                    ),
                    SizedBox(width: 48),
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
                            Expanded(
                              child: Column(
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
  void _showSignByList(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
          child: Container(
            padding: EdgeInsets.all(16),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6, // Giới hạn chiều cao dialog
              maxWidth: MediaQuery.of(context).size.width * 0.9, // Giới hạn chiều rộng dialog
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_circle_left_outlined, color: Colors.black, size: 30),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Expanded(
                      child: Text(
                        'Danh sách người xem',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        maxLines: 2,
                      ),
                    ),
                    SizedBox(width: 48),
                  ],
                ),

                SizedBox(height: 8),
                // Danh sách người xem
                // Expanded(
                //   child: ListView.builder(
                //     shrinkWrap: true,
                //     itemCount: viewers.length,
                //     itemBuilder: (context, index) {
                //       final viewer = viewers[index];
                //       return Padding(
                //         padding: const EdgeInsets.symmetric(vertical: 8.0),
                //         child: Row(
                //           children: [
                //             // Avatar
                //             Stack(
                //               children: [
                //                 CircleAvatar(
                //                   radius: 24,
                //                   backgroundImage: AssetImage(TImages.user),
                //                 ),
                //                 if (viewer['isOnline'])
                //                   Positioned(
                //                     right: 0,
                //                     bottom: 0,
                //                     child: Container(
                //                       width: 16,
                //                       height: 16,
                //                       decoration: BoxDecoration(
                //                         color: Colors.green,
                //                         shape: BoxShape.circle,
                //                         border: Border.all(color: Colors.white, width: 2),
                //                       ),
                //                     ),
                //                   ),
                //               ],
                //             ),
                //             SizedBox(width: 16),
                //             // Tên và vai trò
                //             Expanded(
                //               child: Column(
                //                 crossAxisAlignment: CrossAxisAlignment.start,
                //                 children: [
                //                   Text(
                //                     'Người ký',
                //                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                //                   ),
                //                   SizedBox(height: 4),
                //                   Text(
                //                     UserManager().position,
                //                     style: TextStyle(fontSize: 14, color: Colors.grey),
                //                   ),
                //                 ],
                //               ),
                //             ),
                //           ],
                //         ),
                //       );
                //     },
                //   ),
                // ),
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
                            // Avatar mặc định
                            CircleAvatar(
                              radius: 24,
                              backgroundImage: AssetImage(TImages.user),
                            ),
                            SizedBox(width: 16),
                            // Tên người ký
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    signer,
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Người ký', // Có thể thay bằng role nếu cần
                                    style: TextStyle(fontSize: 14, color: Colors.grey),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar:
      AppBar(
        title: Text('Chi tiết văn bản', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white), textAlign: TextAlign.center),
        centerTitle: true,
        backgroundColor: TColors.primary,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          // IconButton(
          //   icon: Icon(Icons.more_vert, color: Colors.white),
          //   onPressed: () {
          //     // Xử lý khi nhấn nút ba chấm
          //   },
          // ),
        ],
        leading: IconButton(
          icon: Icon(Iconsax.arrow_left_24),
          onPressed: () {
            Navigator.pop(context);
          },

        ),
      ),
      body:
      FutureBuilder<DocumentDetail?>(
        future: _documentDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('Không thể tải dữ liệu.'));
          }

          final document = snapshot.data!;
          return
            SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Hình ảnh tài liệu bị thu nhỏ, làm mờ, với nút zoom in

                  Container(
                    height: 200,
                    width: 350,
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
                          icon: Icon(
                            Iconsax.search_zoom_in,
                            color: Colors.white,
                            size: 40,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ViewDocumentPage(imageUrl: document.documentUrl,)),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      document.documentName,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 16),
                  // Quyết Định ngang hàng với Nam Lee, Trạng thái: Đã Lưu ngang hàng với 5 Joined
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Cột cho Quyết Định và Trạng thái: Đã Lưu
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.orange[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Iconsax.document,
                                  color: Colors.orange,
                                  size: 16,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                              document.documentTypeName,
                                style: TextStyle(color: Colors.orange, fontSize: 12),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Iconsax.tick_circle,
                                  color: Colors.green,
                                  size: 16,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Trạng thái: ${document.processingStatus}',
                                style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // Cột cho Nam Lee và 5 Joined
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 12,
                                backgroundImage: NetworkImage(
                                    UserManager().avatar.toString()
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                UserManager().name,
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Stack(
                                children: [
                                  Icon(Iconsax.profile_2user5, size: 16),
                                ],
                              ),
                              SizedBox(width: 8),
                              Text(
                                '1 Tham gia',
                                style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30), // chỉnh tùy ý
                    child: Divider(),
                  ),
                  SizedBox(height: 16),

                  // Nội dung
                  Padding(
                    padding: EdgeInsets.only(left: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nội dung',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        // Text.rich(
                        //   TextSpan(
                        //     children: [
                        //       TextSpan(
                        //         text: _isContentExpanded
                        //             ? 'FORCE is an external agent capable of changing the state of rest or motion of a particular body. It has a magnitude and direction, making it a vector quantity. This external agent can cause an object to accelerate, decelerate, or change direction depending on the net force applied.'
                        //             : 'FORCE is an external agent capable of changing the state of rest or motion of a particular body. It has a... ',
                        //         style: TextStyle(fontSize: 15, color: Colors.black87),
                        //       ),
                        //       TextSpan(
                        //         text: _isContentExpanded ? 'LESS' : 'MORE',
                        //         style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
                        //         recognizer: TapGestureRecognizer()
                        //           ..onTap = () {
                        //             setState(() {
                        //               _isContentExpanded = !_isContentExpanded;
                        //             });
                        //           },
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: _isContentExpanded
                                    ? document.documentContent
                                    : document.documentContent.length > 100
                                    ? '${document.documentContent.substring(0, 100)}... '
                                    : '${document.documentContent} ',
                                style: TextStyle(fontSize: 15, color: Colors.black87),
                              ),
                              TextSpan(
                                text: _isContentExpanded ? 'LESS' : 'MORE',
                                style: TextStyle(
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
                        ),

                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Phòng ban:',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          // Container(
                          //   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          //   decoration: BoxDecoration(
                          //     color: Colors.orange[100],
                          //     borderRadius: BorderRadius.circular(16),
                          //   ),
                          //   child: Text(
                          //     'Lãnh đạo',
                          //     style: TextStyle(color: Colors.orange, fontSize: 12),
                          //   ),
                          // ),
                          // SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.red[50],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              UserManager().divisionName,
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Thông tin chi tiết
                  InfoItem(title: 'Ngày tạo:', value: document.createdDate),
                  InfoItem(title: 'Ngày có hiệu lực:', value: document.dateIssued),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Ký bởi:',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          // Row(
                          //   children: [
                          //     CircleAvatar(
                          //       radius: 12,
                          //       backgroundImage: NetworkImage(
                          //           UserManager().avatar.toString()
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          GestureDetector(
                            onTap: () {
                              _showSignByList(context); // Hiển thị bottom sheet khi nhấn
                            },
                            child: Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),

                  InfoItem(title: 'Mã văn bản:', value: document.documentId),
                  InfoItem(title: 'Số hiệu văn bản:', value: document.numberOfDocument),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Người xem:',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 12,
                                backgroundImage: NetworkImage(
                                    UserManager().avatar.toString()
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              _showViewersList(context); // Hiển thị bottom sheet khi nhấn
                            },
                            child: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
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
// Widget cho mỗi mục thông tin
class InfoItem extends StatelessWidget {
  final String title;
  final String value;

  InfoItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}