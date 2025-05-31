import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../../../utils/constants/colors.dart';
import '../../../authentication/controllers/user/user_manager.dart';
import '../../../task/screens/task_detail/task_detail.dart';
import '../../models/document_detail.dart';
import 'package:http/http.dart' as http;

class ViewDocumentApprovePage extends StatefulWidget {
  final String imageUrl;
  final String documentId;
  final String documentName;
  final String taskId;

  const ViewDocumentApprovePage({
    super.key,
    required this.imageUrl,
    required this.documentId,
    required this.taskId,
    required this.documentName,
  });

  @override
  State<ViewDocumentApprovePage> createState() => _ViewDocumentApprovePageState();
}

class _ViewDocumentApprovePageState extends State<ViewDocumentApprovePage> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  late Future<DocumentDetail?> _documentDetailFuture;

  @override
  void initState() {
    super.initState();
    // _documentDetailFuture = DocumentService.fetchDocumentDetail(
    //   documentId: widget.documentId,
    //   workFlowId: widget.workFlowId,
    // );
  }

  // Hàm hiển thị popup
  void _showDialog(BuildContext context, {required bool isApproved}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                isApproved
                    ? 'assets/images/email_otp_images/success.png'
                    : 'assets/images/email_otp_images/delete-button.png',
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 16),
              Text(
                isApproved
                    ? 'Văn bản đã được chấp nhận thành công'
                    : 'Văn bản đã bị từ chối',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Đóng dialog
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskDetailPage(
                        taskId: widget.taskId,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text(
                  'Hoàn thành',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Hàm xử lý chấp nhận tài liệu
  Future<bool> _acceptDocument() async {
    try {
      final response = await http.post(
        Uri.parse(
          'http://103.90.227.64:5290/api/Task/create-handle-task-action?taskId=${widget.taskId}&userId=${UserManager().id}&action=ApproveDocument',
        ),
        headers: {
          'Authorization': 'Bearer ${UserManager().token}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw Exception('Lỗi khi chấp nhận: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
      return false;
    }
  }

  // Hàm xử lý từ chối tài liệu
  Future<bool> _rejectDocument() async {
    try {
      final response = await http.post(
        Uri.parse(
          'http://103.90.227.64:5290/api/Task/create-handle-task-action?taskId=${widget.taskId}&userId=${UserManager().id}&action=RejectTask',
        ),
        headers: {
          'Authorization': 'Bearer ${UserManager().token}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw Exception('Lỗi khi từ chối: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.documentName,
          style: const TextStyle(color: Colors.white, fontSize: 20),
          textAlign: TextAlign.center,
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
      body: Column(
        children: [
          Expanded(
            child: SfPdfViewer.network(
              widget.imageUrl,
              key: _pdfViewerKey,
              headers: {
                'Authorization': 'Bearer ${UserManager().token}',
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      bool success = await _rejectDocument();
                      if (success) {
                        _showDialog(context, isApproved: false);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF0695F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Từ chối',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      bool success = await _acceptDocument();
                      if (success) {
                        _showDialog(context, isApproved: true);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A8EEA),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Chấp nhận',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}