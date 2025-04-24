import 'package:dms/features/document/screens/document_detail/document_detail.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../../data/services/document_service.dart';
import '../../../../utils/constants/colors.dart';
import '../../../authentication/controllers/user/user_manager.dart';
import '../../models/document_detail.dart';


class ViewDocumentSignaturePage extends StatefulWidget {
  final String imageUrl;

  const ViewDocumentSignaturePage({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  @override
  _ViewDocumentSignaturePageState createState() => _ViewDocumentSignaturePageState();
}

class _ViewDocumentSignaturePageState extends State<ViewDocumentSignaturePage> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  // Quản lý trạng thái chữ ký
  Offset? _signaturePosition; // Vị trí chữ ký
  double _signatureWidth = 100; // Chiều rộng hiện tại của ảnh
  double _signatureHeight = 50; // Chiều cao hiện tại của ảnh
  bool _isSignatureVisible = false; // Hiển thị chữ ký hay không

  // Kích thước mặc định ban đầu của ảnh
  final double _defaultSignatureWidth = 100;
  final double _defaultSignatureHeight = 50;

  // Hàm hiển thị popup chọn chữ ký
  void _showSignaturePopup() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Chọn chữ ký số",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isSignatureVisible = true;
                    _signaturePosition = const Offset(50, 50);
                    _signatureWidth = _defaultSignatureWidth;
                    _signatureHeight = _defaultSignatureHeight;
                  });
                  Navigator.pop(context);
                },
                child: Image.network(
                  'https://chukydep.vn/Upload/post/chu-ky-ten-nam.jpg',
                  width: 150,
                  height: 75,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Hủy"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Hàm xử lý khi chạm vào PDF để đặt chữ ký
  void _onPdfTap(BuildContext context, PdfGestureDetails details) {
    if (_isSignatureVisible) {
      setState(() {
        _signaturePosition = details.position;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quyết định 53/2015 QD-TTg chính sách nội trú học sinh, sinh viên học cao đẳng trung cấp',
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_24),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          // Hiển thị PDF
          SfPdfViewer.network(
            widget.imageUrl,
            key: _pdfViewerKey,
            headers: {
              'Authorization': 'Bearer ${UserManager().token}',
            },
            onTap: (details) {
              _onPdfTap(context, details);
            },
          ),
          // Hiển thị hình ảnh chữ ký nếu đã chọn
          if (_isSignatureVisible && _signaturePosition != null)
            Positioned(
              left: _signaturePosition!.dx - (_signatureWidth / 2),
              top: _signaturePosition!.dy - (_signatureHeight / 2),
              child: Stack(
                children: [
                  // Ảnh chữ ký với khả năng kéo thả
                  GestureDetector(
                    onScaleUpdate: (details) {
                      setState(() {
                        // Kéo thả ảnh
                        _signaturePosition = Offset(
                          _signaturePosition!.dx + details.focalPointDelta.dx,
                          _signaturePosition!.dy + details.focalPointDelta.dy,
                        );
                      });
                    },
                    child: Container(
                      width: _signatureWidth,
                      height: _signatureHeight,
                      child: Image.network(
                        'https://chukydep.vn/Upload/post/chu-ky-ten-nam.jpg',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  // Nút điều khiển ở góc dưới bên phải để phóng to/thu nhỏ theo chiều chéo
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        setState(() {
                          // Tính toán thay đổi kích thước dựa trên khoảng cách kéo theo chiều chéo
                          double deltaX = details.delta.dx;
                          double deltaY = details.delta.dy;
                          // Cập nhật kích thước (giữ tỷ lệ đồng đều)
                          double delta = (deltaX + deltaY) / 2; // Trung bình thay đổi theo cả 2 chiều
                          _signatureWidth = (_signatureWidth + delta).clamp(50, 300); // Giới hạn kích thước
                          _signatureHeight = (_signatureHeight + delta * (_defaultSignatureHeight / _defaultSignatureWidth)).clamp(25, 150); // Giữ tỷ lệ
                        });
                      },
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.7),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.open_with,
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  // Nút xóa chữ ký
                  Positioned(
                    right: 0,
                    top: 0,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isSignatureVisible = false;
                          _signaturePosition = null;
                          _signatureWidth = _defaultSignatureWidth;
                          _signatureHeight = _defaultSignatureHeight;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, color: Colors.white, size: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showSignaturePopup,
        label: const Text("Thực hiện ký số"),
        icon: const Icon(Icons.edit),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
    );
  }
}