  import 'dart:async';
  import 'package:flutter/material.dart';
  import 'package:iconsax/iconsax.dart';
  import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
  import '../../../authentication/controllers/user/user_manager.dart';
  import '../document_sign_confirm/document_list.dart';


  class ViewDocumentSignaturePage extends StatefulWidget {
    final String imageUrl;
    final String documentName;

    const ViewDocumentSignaturePage({
      Key? key,
      required this.imageUrl,
      required this.documentName,
    }) : super(key: key);

    @override
    _ViewDocumentSignaturePageState createState() => _ViewDocumentSignaturePageState();
  }

  class _ViewDocumentSignaturePageState extends State<ViewDocumentSignaturePage> {
    final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
    final PdfViewerController _pdfViewerController = PdfViewerController();

    // Quản lý trạng thái chữ ký
    Offset? _signaturePosition; // Vị trí chữ ký (trung tâm của ảnh)
    double _signatureWidth = 100; // Chiều rộng hiện tại của ảnh
    double _signatureHeight = 50; // Chiều cao hiện tại của ảnh
    bool _isSignatureVisible = false; // Hiển thị chữ ký hay không

    // Kích thước mặc định ban đầu của ảnh
    final double _defaultSignatureWidth = 100;
    final double _defaultSignatureHeight = 50;

    // Biến để lưu kích thước trang PDF
    Size _currentPageSize = const Size(595, 842); // Mặc định A4 (đơn vị: points)
    double _zoomLevel = 1.0;
    Offset _scrollOffset = Offset.zero;

    // Tọa độ llx, lly, urx, ury
    double? _llx, _lly, _urx, _ury;

    // Lấy kích thước widget hiển thị PDF
    final GlobalKey _pdfContainerKey = GlobalKey();
    Size _pdfContainerSize = Size.zero;

    // Timer để kiểm tra vị trí cuộn định kỳ
    Timer? _scrollCheckTimer;

    @override
    void initState() {
      super.initState();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updatePageSize();
        // Bắt đầu kiểm tra vị trí cuộn định kỳ
        _startScrollCheckTimer();
      });
    }

    @override
    void dispose() {
      _scrollCheckTimer?.cancel();
      super.dispose();
    }

    // Kiểm tra vị trí cuộn định kỳ
    void _startScrollCheckTimer() {
      _scrollCheckTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        final newScrollOffset = _pdfViewerController.scrollOffset;
        if (newScrollOffset != _scrollOffset) {
          setState(() {
            _scrollOffset = newScrollOffset;
          });
          _updatePageSize();
        }
      });
    }

    // Lấy kích thước widget chứa PDF và cập nhật thông tin
    void _updatePageSize() {
      final pdfViewerState = _pdfViewerKey.currentState;
      final containerRenderBox = _pdfContainerKey.currentContext?.findRenderObject() as RenderBox?;
      if (pdfViewerState != null && containerRenderBox != null) {
        setState(() {
          _pdfContainerSize = containerRenderBox.size;
          _zoomLevel = _pdfViewerController.zoomLevel;
          _scrollOffset = _pdfViewerController.scrollOffset;
          _updateSignatureBounds();
        });
      }
    }

    // Hàm giới hạn vị trí và kích thước chữ ký
    void _restrictSignatureBounds() {
      if (_signaturePosition == null || _pdfContainerSize == Size.zero) return;

      // Tính kích thước hiển thị của trang PDF trên màn hình (sau khi áp dụng zoom)
      final displayPageWidth = _pdfContainerSize.width;
      final displayPageHeight = _pdfContainerSize.height;

      // Tính giới hạn vị trí để chữ ký không vượt ra ngoài trang PDF
      final minX = _signatureWidth / 2;
      final maxX = displayPageWidth - _signatureWidth / 2;
      final minY = _signatureHeight / 2;
      final maxY = displayPageHeight - _signatureHeight / 2;

      // Giới hạn vị trí
      double newX = _signaturePosition!.dx.clamp(minX, maxX);
      double newY = _signaturePosition!.dy.clamp(minY, maxY);

      // Cập nhật vị trí nếu cần
      if (newX != _signaturePosition!.dx || newY != _signaturePosition!.dy) {
        setState(() {
          _signaturePosition = Offset(newX, newY);
        });
      }

      // Cập nhật tọa độ llx, lly, urx, ury
      _updateSignatureBounds();
    }

    // Tính toán tọa độ llx, lly, urx, ury
    void _updateSignatureBounds() {
      if (_signaturePosition == null || _pdfContainerSize == Size.zero) return;

      // Tính vị trí góc dưới bên trái và trên bên phải trong hệ tọa độ màn hình
      final screenLlx = _signaturePosition!.dx - _signatureWidth / 2;
      final screenLly = _signaturePosition!.dy + _signatureHeight / 2;
      final screenUrx = _signaturePosition!.dx + _signatureWidth / 2;
      final screenUry = _signaturePosition!.dy - _signatureHeight / 2;

      // Chuyển đổi sang hệ tọa độ PDF
      // Giả định kích thước trang PDF là _currentPageSize (mặc định A4: 595x842 points)
      // Tọa độ màn hình được ánh xạ tỷ lệ với tọa độ PDF
      final pdfWidthRatio = _currentPageSize.width / _pdfContainerSize.width;
      final pdfHeightRatio = _currentPageSize.height / _pdfContainerSize.height;

      setState(() {
        _llx = (screenLlx - _scrollOffset.dx) * pdfWidthRatio;
        _lly = (_pdfContainerSize.height - screenLly - _scrollOffset.dy) * pdfHeightRatio;
        _urx = (screenUrx - _scrollOffset.dx) * pdfWidthRatio;
        _ury = (_pdfContainerSize.height - screenUry - _scrollOffset.dy) * pdfHeightRatio;
      });
    }

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
                    _updatePageSize();
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
        _restrictSignatureBounds();
      }
    }

    // Hàm xử lý khi nhấn nút "Hoàn thành"
    void _onComplete() {
      if (_isSignatureVisible && _signaturePosition != null) {
        final currentPage = _pdfViewerController.pageNumber;
        // In các giá trị ra console
        print('llx: ${_llx ?? 0}');
        print('lly: ${_lly ?? 0}');
        print('urx: ${_urx ?? 0}');
        print('ury: ${_ury ?? 0}');
        print('currentPage: $currentPage');

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DocumentListSignConfirmPage(
              // llx: _llx ?? 0,
              // lly: _lly ?? 0,
              // urx: _urx ?? 0,
              // ury: _ury ?? 0,
              // currentPage: currentPage,
              // documentName: widget.documentName,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vui lòng chọn và đặt chữ ký trước khi hoàn thành.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.documentName,
            style: const TextStyle(color: Colors.white),
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
            Container(
              key: _pdfContainerKey,
              child: SfPdfViewer.network(
                widget.imageUrl,
                key: _pdfViewerKey,
                controller: _pdfViewerController,
                headers: {
                  'Authorization': 'Bearer ${UserManager().token}',
                },
                onTap: (details) {
                  _onPdfTap(context, details);
                },
                onDocumentLoaded: (details) {
                  _updatePageSize();
                },
                onZoomLevelChanged: (details) {
                  setState(() {
                    _zoomLevel = _pdfViewerController.zoomLevel;
                  });
                  _updatePageSize();
                },
                onPageChanged: (details) {
                  _updatePageSize();
                },
              ),
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
                        _restrictSignatureBounds();
                      },
                      child: Image.network(
                        'https://chukydep.vn/Upload/post/chu-ky-ten-nam.jpg',
                        width: _signatureWidth,
                        height: _signatureHeight,
                        fit: BoxFit.contain,
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
                            double delta = (deltaX + deltaY) / 2;
                            _signatureWidth = (_signatureWidth + delta).clamp(50, 300);
                            _signatureHeight = (_signatureHeight + delta * (_defaultSignatureHeight / _defaultSignatureWidth)).clamp(25, 150);
                          });
                          _restrictSignatureBounds();
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
                            _llx = null;
                            _lly = null;
                            _urx = null;
                            _ury = null;
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
                    // Hiển thị tọa độ llx, lly, urx, ury (chỉ để debug)
                    // Positioned(
                    //   left: 0,
                    //   top: 0,
                    //   child: Container(
                    //     padding: const EdgeInsets.all(4),
                    //     color: Colors.black54,
                    //     child: Text(
                    //       'llx: ${_llx?.toStringAsFixed(2) ?? 'N/A'}\n'
                    //           'lly: ${_lly?.toStringAsFixed(2) ?? 'N/A'}\n'
                    //           'urx: ${_urx?.toStringAsFixed(2) ?? 'N/A'}\n'
                    //           'ury: ${_ury?.toStringAsFixed(2) ?? 'N/A'}',
                    //       style: const TextStyle(color: Colors.white, fontSize: 10),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton.extended(
              onPressed: _showSignaturePopup,
              label: const Text("Thực hiện ký số"),
              icon: const Icon(Icons.edit),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            const SizedBox(width: 16),
            if (_isSignatureVisible)
              FloatingActionButton.extended(
                onPressed: _onComplete,
                label: const Text("Hoàn thành"),
                icon: const Icon(Icons.check),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
          ],
        ),
      );
    }
  }