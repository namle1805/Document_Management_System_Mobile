import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:iconsax/iconsax.dart';
import '../../../authentication/controllers/user/user_manager.dart';
import '../../models/document_detail.dart';
import '../document_sign_confirm/document_list_confirm.dart';

class ViewDocumentSignaturePage extends StatefulWidget {
  final String imageUrl;
  final String documentId;
  final String size;
  final String documentName;
  final List<SizeInfo> sizes;
  final String date;
  final String taskId;


  const ViewDocumentSignaturePage({
    Key? key,
    required this.imageUrl,
    required this.documentName,
    required this.sizes, required this.documentId, required this.size, required this.date, required this.taskId,
  }) : super(key: key);

  @override
  State<ViewDocumentSignaturePage> createState() => _ViewDocumentSignaturePageState();
}

class _ViewDocumentSignaturePageState extends State<ViewDocumentSignaturePage> {
  final Completer<PDFViewController> _pdfViewController = Completer<PDFViewController>();
  final GlobalKey _pdfContainerKey = GlobalKey();

  Offset? _signaturePosition;
  double _signatureWidth = 100;
  double _signatureHeight = 50;
  bool _isSignatureVisible = false;
  String? _signatureImageUrl;

  int _currentPage = 1;
  int? _totalPages;

  Size _currentPageSize = const Size(595, 842); // A4 default
  Size _pdfContainerSize = Size.zero;

  // double? _llx, _lly, _urx, _ury;
  int? _llx, _lly, _urx, _ury;
  // For resizing
  bool _isResizingTopRight = false;
  bool _isResizingBottomRight = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updatePageSize();
    });
  }

  void _updatePageSize() {
    final containerRenderBox = _pdfContainerKey.currentContext?.findRenderObject() as RenderBox?;
    if (containerRenderBox != null) {
      setState(() {
        _pdfContainerSize = containerRenderBox.size;
        if (_currentPage - 1 >= 0 && _currentPage - 1 < widget.sizes.length) {
          _currentPageSize = Size(
            widget.sizes[_currentPage - 1].width ?? 595,
            widget.sizes[_currentPage - 1].height ?? 842,
          );
        } else {
          debugPrint('Invalid page index: $_currentPage, sizes length: ${widget.sizes.length}');
          _currentPageSize = const Size(595, 842);
        }
        debugPrint('PDF Container Size: $_pdfContainerSize');
        debugPrint('Current Page: $_currentPage, Page Size: $_currentPageSize');
        _restrictSignatureBounds();
      });
    } else {
      debugPrint('Container RenderBox is null');
    }
  }

  void _restrictSignatureBounds() {
    if (_signaturePosition == null || _pdfContainerSize == Size.zero) return;

    // Restrict signature within PDF page boundaries
    final minX = _signatureWidth / 2;
    final maxX = _pdfContainerSize.width - _signatureWidth / 2;
    final minY = _signatureHeight / 2; // Ensure signature doesn't go above top edge
    final maxY = _pdfContainerSize.height - _signatureHeight / 2; // Ensure signature stays within bottom edge

    double newX = _signaturePosition!.dx.clamp(minX, maxX);
    double newY = _signaturePosition!.dy.clamp(minY, maxY);

    if (newX != _signaturePosition!.dx || newY != _signaturePosition!.dy) {
      setState(() {
        _signaturePosition = Offset(newX, newY);
      });
    }

    _updateSignatureBounds();
  }

  void _updateSignatureBounds() {
    if (_signaturePosition == null || _pdfContainerSize == Size.zero) return;

    final scaleX = _currentPageSize.width / _pdfContainerSize.width;
    final scaleY = _currentPageSize.height / _pdfContainerSize.height;

    final centerX = _signaturePosition!.dx;
    final centerY = _signaturePosition!.dy;

    final pdfCenterX = centerX * scaleX;
    final pdfCenterY = (_pdfContainerSize.height - centerY) * scaleY;

    final halfWidth = (_signatureWidth / 2) * scaleX;
    final halfHeight = (_signatureHeight / 2) * scaleY;

    final pdfLlx = pdfCenterX - halfWidth;
    final pdfLly = pdfCenterY - halfHeight;
    final pdfUrx = pdfCenterX + halfWidth;
    final pdfUry = pdfCenterY + halfHeight;

    setState(() {
      // _llx = pdfLlx.clamp(0, _currentPageSize.width).toDouble();
      // _lly = pdfLly.clamp(0, _currentPageSize.height).toDouble();
      // _urx = pdfUrx.clamp(0, _currentPageSize.width).toDouble();
      // _ury = pdfUry.clamp(0, _currentPageSize.height).toDouble();
      _llx = pdfLlx.clamp(0, _currentPageSize.width).round();
      _lly = pdfLly.clamp(0, _currentPageSize.height).round();
      _urx = pdfUrx.clamp(0, _currentPageSize.width).round();
      _ury = pdfUry.clamp(0, _currentPageSize.height).round();

      debugPrint('Signature Bounds - Page: $_currentPage, llx: $_llx, lly: $_lly, urx: $_urx, ury: $_ury');
    });
  }

  void _placeSignature(Offset position) {
    setState(() {
      _isSignatureVisible = true;
      _signatureImageUrl = UserManager().signDigital;
      _signatureWidth = 100;
      _signatureHeight = 50;
      _signaturePosition = position;
    });
    _restrictSignatureBounds();
  }

  void _onPdfTap(Offset position) {
    if (!_isSignatureVisible) {
      _placeSignature(position);
    } else {
      setState(() {
        _signaturePosition = position;
      });
      _restrictSignatureBounds();
    }
  }

  void _onComplete() {
    if (_isSignatureVisible && _signaturePosition != null) {
      debugPrint('Signature Coordinates - llx: $_llx, lly: $_lly');
      debugPrint('Signature Coordinates - urx: $_urx, ury: $_ury');
      debugPrint('Current Page: $_currentPage');

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DocumentListSignConfirmPage(documentName: widget.documentName, createdDate: widget.date, documentId: widget.documentId, size: widget.size, llx: _llx!, lly: _lly!, urx: _urx!, ury: _ury!, currentPage: _currentPage, taskId: widget.taskId, ),
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
    final screenSize = MediaQuery.of(context).size;
    final pdfAspectRatio = _currentPageSize.width / _currentPageSize.height;

    // Calculate available height for PDF container
    const appBarHeight = kToolbarHeight; // AppBar height
    const bottomNavHeight = 100.0; // Approximate height of bottomNavigationBar
    final availableHeight = screenSize.height - appBarHeight - bottomNavHeight;
    final pdfWidth = screenSize.width;
    final pdfHeight = pdfWidth / pdfAspectRatio;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.documentName, style: const TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () async {
              final controller = await _pdfViewController.future;
              final page = await controller.getCurrentPage();
              debugPrint('Manually checked page: ${page! + 1}');
            },
            icon: const Icon(Icons.info),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20), // Push PDF frame down
                Container(
                  width: pdfWidth,
                  height: pdfHeight,
                  child: AspectRatio(
                    aspectRatio: pdfAspectRatio,
                    child: Container(
                      key: _pdfContainerKey,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                      ),
                      child: GestureDetector(
                        onTapDown: (details) {
                          _onPdfTap(details.localPosition);
                        },
                        child: PDF(
                          swipeHorizontal: false,
                          fitPolicy: FitPolicy.BOTH,
                          onPageChanged: (page, total) {
                            setState(() {
                              _currentPage = page! + 1;
                              _totalPages = total;
                            });
                            _updatePageSize();
                          },
                          onViewCreated: (PDFViewController controller) {
                            _pdfViewController.complete(controller);
                            controller.getPageCount().then((count) {
                              setState(() {
                                _totalPages = count;
                              });
                            });
                            controller.getCurrentPage().then((page) {
                              setState(() {
                                _currentPage = (page ?? 0) + 1;
                              });
                              _updatePageSize();
                            });
                          },
                        ).cachedFromUrl(
                          widget.imageUrl,
                          headers: {'Authorization': 'Bearer ${UserManager().token}'},
                          placeholder: (progress) => const Center(child: CircularProgressIndicator()),
                          errorWidget: (error) => Center(child: Text(error.toString())),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Ensure bottom content is visible
              ],
            ),
          ),
          if (_isSignatureVisible && _signaturePosition != null && _signatureImageUrl != null)
            Positioned(
              left: _signaturePosition!.dx - _signatureWidth / 2,
              top: _signaturePosition!.dy - _signatureHeight / 2 + 20, // Adjust for top padding
              child: Stack(
                children: [
                  // Signature Image with Blue Frame
                  GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        _signaturePosition = _signaturePosition! + details.delta;
                      });
                      _restrictSignatureBounds();
                    },
                    child: Container(
                      width: _signatureWidth,
                      height: _signatureHeight,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.2), // Light blue background
                        border: Border.all(color: Colors.blue, width: 2), // Blue frame
                      ),
                      child: Image.network(
                        _signatureImageUrl!,
                        width: _signatureWidth,
                        height: _signatureHeight,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  // Top-right corner (red X) for removing or resizing
                  Positioned(
                    right: 0,
                    top: 0,
                    child: GestureDetector(
                      onPanStart: (_) {
                        setState(() {
                          _isResizingTopRight = true;
                        });
                      },
                      onPanUpdate: (details) {
                        if (_isResizingTopRight) {
                          setState(() {
                            _signatureWidth += details.delta.dx;
                            _signatureHeight -= details.delta.dy;
                            _signatureWidth = _signatureWidth.clamp(50, 300);
                            _signatureHeight = _signatureHeight.clamp(25, 150);
                          });
                          _restrictSignatureBounds();
                        }
                      },
                      onPanEnd: (_) {
                        setState(() {
                          _isResizingTopRight = false;
                        });
                      },
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, color: Colors.white, size: 16),
                      ),
                    ),
                  ),
                  // Bottom-right corner (blue arrow) for resizing
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onPanStart: (_) {
                        setState(() {
                          _isResizingBottomRight = true;
                        });
                      },
                      onPanUpdate: (details) {
                        if (_isResizingBottomRight) {
                          setState(() {
                            _signatureWidth += details.delta.dx;
                            _signatureHeight += details.delta.dy;
                            _signatureWidth = _signatureWidth.clamp(50, 300);
                            _signatureHeight = _signatureHeight.clamp(25, 150);
                          });
                          _restrictSignatureBounds();
                        }
                      },
                      onPanEnd: (_) {
                        setState(() {
                          _isResizingBottomRight = false;
                        });
                      },
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.open_with, color: Colors.white, size: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Chạm vị trí bất kỳ để chọn chữ ký',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8), // Space between text and button
            ElevatedButton(
              onPressed: _onComplete,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Blue background
                foregroundColor: Colors.white, // White text/icon color
                minimumSize: const Size(double.infinity, 50), // Full width, height 50
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                ),
              ),
              child: const Text(
                'Hoàn thành',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}