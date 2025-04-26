  import 'dart:async';
  import 'package:flutter/material.dart';
  import 'package:iconsax/iconsax.dart';
  import '../../../authentication/controllers/user/user_manager.dart';
  import '../document_sign_confirm/document_list.dart';
  import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';


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
    final Completer<PDFViewController> _pdfViewController = Completer<PDFViewController>();
    int _currentPage = 1;
    int? _totalPages;

    // Quản lý trạng thái chữ ký
    Offset? _signaturePosition; // Vị trí chữ ký (trung tâm của ảnh)
    double _signatureWidth = 100; // Chiều rộng hiện tại của ảnh
    double _signatureHeight = 50; // Chiều cao hiện tại của ảnh
    bool _isSignatureVisible = false; // Hiển thị chữ ký hay không

    // Kích thước mặc định ban đầu của ảnh
    final double _defaultSignatureWidth = 100;
    final double _defaultSignatureHeight = 50;

    // Biến để lưu kích thước trang PDF
    Size _currentPageSize = const Size(595, 842); // Kích thước mặc định A4 (đơn vị: points)
    double _zoomLevel = 1.0;
    Offset _scrollOffset = Offset.zero;

    // Tọa độ llx, lly, urx, ury (trong hệ tọa độ PDF)
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
        _startScrollCheckTimer();
      });
    }

    @override
    void dispose() {
      _scrollCheckTimer?.cancel();
      super.dispose();
    }

    // Kiểm tra vị trí cuộn và trang hiện tại định kỳ
    void _startScrollCheckTimer() {
      _scrollCheckTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) async {
        try {
          final controller = await _pdfViewController.future;
          final newPage = (await controller.getCurrentPage())! + 1;
          if (newPage != _currentPage) {
            setState(() {
              _currentPage = newPage;
            });
            _updatePageSize();
          }
        } catch (e) {
          print('Error checking page: $e');
        }
      });
    }

    // Cập nhật kích thước trang PDF và thông tin liên quan
    void _updatePageSize() {
      final containerRenderBox = _pdfContainerKey.currentContext?.findRenderObject() as RenderBox?;
      if (containerRenderBox != null) {
        setState(() {
          _pdfContainerSize = containerRenderBox.size;
          _restrictSignatureBounds();
        });
      }
    }

    // Giới hạn vị trí và kích thước chữ ký trên màn hình
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

    // Tính toán tọa độ llx, lly, urx, ury trong hệ tọa độ PDF
    void _updateSignatureBounds() {
      if (_signaturePosition == null || _pdfContainerSize == Size.zero) return;

      // Tính vị trí góc dưới bên trái và trên bên phải trong hệ tọa độ màn hình
      final screenLlx = _signaturePosition!.dx - _signatureWidth / 2;
      final screenLly = _signaturePosition!.dy + _signatureHeight / 2;
      final screenUrx = _signaturePosition!.dx + _signatureWidth / 2;
      final screenUry = _signaturePosition!.dy - _signatureHeight / 2;

      // Tính tỷ lệ giữa kích thước hiển thị trên màn hình và kích thước thực tế của trang PDF
      final pdfWidthRatio = _currentPageSize.width / (_pdfContainerSize.width / _zoomLevel);
      final pdfHeightRatio = _currentPageSize.height / (_pdfContainerSize.height / _zoomLevel);

      // Ánh xạ tọa độ từ hệ tọa độ màn hình sang hệ tọa độ PDF
      final pdfLlx = (screenLlx + _scrollOffset.dx) * pdfWidthRatio;
      final pdfLly = (_pdfContainerSize.height - screenLly + _scrollOffset.dy) * pdfHeightRatio;
      final pdfUrx = (screenUrx + _scrollOffset.dx) * pdfWidthRatio;
      final pdfUry = (_pdfContainerSize.height - screenUry + _scrollOffset.dy) * pdfHeightRatio;

      setState(() {
        _llx = pdfLlx.clamp(0, _currentPageSize.width);
        _lly = pdfLly.clamp(0, _currentPageSize.height);
        _urx = pdfUrx.clamp(0, _currentPageSize.width);
        _ury = pdfUry.clamp(0, _currentPageSize.height);
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
                      // Đặt chữ ký ở góc dưới bên trái của trang PDF
                      _signaturePosition = Offset(
                        _pdfContainerSize.width * 0.1, // 10% từ bên trái
                        _pdfContainerSize.height * 0.9, // 10% từ dưới lên
                      );
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
    void _onPdfTap(Offset position) {
      if (_isSignatureVisible) {
        setState(() {
          _signaturePosition = position;
        });
        _restrictSignatureBounds();
      }
    }

    // Hàm xử lý khi nhấn nút "Hoàn thành"
    void _onComplete() {
      if (_isSignatureVisible && _signaturePosition != null) {
        print('llx: ${_llx ?? 0}');
        print('lly: ${_lly ?? 0}');
        print('urx: ${_urx ?? 0}');
        print('ury: ${_ury ?? 0}');
        print('currentPage: $_currentPage');

        // Điều hướng đến trang xác nhận
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DocumentListSignConfirmPage(
              // llx: _llx ?? 0,
              // lly: _lly ?? 0,
              // urx: _urx ?? 0,
              // ury: _ury ?? 0,
              // currentPage: _currentPage,
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
              child: GestureDetector(
                onTapDown: (details) {
                  _onPdfTap(details.localPosition);
                },
                child: PDF(
                  enableSwipe: true,
                  swipeHorizontal: false,
                  autoSpacing: false,
                  pageFling: false,
                  onPageChanged: (page, total) {
                    setState(() {
                      _currentPage = page! + 1;
                      _totalPages = total;
                    });
                    _updatePageSize();
                  },
                  onViewCreated: (controller) {
                    _pdfViewController.complete(controller);
                  },
                  onError: (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error loading PDF: $error')),
                    );
                  },
                ).cachedFromUrl(
                  widget.imageUrl,
                  headers: {'Authorization': 'Bearer ${UserManager().token}'},
                  placeholder: (progress) => const Center(child: CircularProgressIndicator()),
                  errorWidget: (error) => Center(child: Text('Failed to load PDF: $error')),
                ),
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
                    // Nút điều khiển ở góc dưới bên phải để phóng to/thu nhỏ
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          setState(() {
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
                    // Hiển thị tọa độ llx, lly, urx, ury và trang hiện tại
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        color: Colors.black54,
                        child: Text(
                          'Page: $_currentPage\n'
                              'llx: ${_llx?.toStringAsFixed(2) ?? 'N/A'}\n'
                              'lly: ${_lly?.toStringAsFixed(2) ?? 'N/A'}\n'
                              'urx: ${_urx?.toStringAsFixed(2) ?? 'N/A'}\n'
                              'ury: ${_ury?.toStringAsFixed(2) ?? 'N/A'}',
                          style: const TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ),
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


