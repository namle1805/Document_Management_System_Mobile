import 'package:dms/data/services/document_service.dart';
import 'package:flutter/material.dart';
import 'package:dms/features/document/screens/document_detail/document_detail.dart';
import 'package:dms/navigation_menu.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../models/document_list.dart';

class SearchDocumentPage extends StatefulWidget {
  final String searchQuery;

  const SearchDocumentPage({super.key, required this.searchQuery});

  @override
  State<SearchDocumentPage> createState() => _SearchDocumentPageState();
}

class _SearchDocumentPageState extends State<SearchDocumentPage> {
  late Future<List<DocumentModel>> futureDocuments;


  @override
  void initState() {
    super.initState();
    futureDocuments = DocumentService().fetchSearchDocuments(widget.searchQuery);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          _buildBreadcrumbs(),
          Expanded(
            child: FutureBuilder<List<DocumentModel>>(
              future: futureDocuments,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Lỗi: ${snapshot.error}'));
                }

                final documents = snapshot.data!;
                if (documents.isEmpty) {
                  return Center(child: Text('Không tìm thấy văn bản nào.'));
                }

                return ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final doc = documents[index];
                    final formattedDate = DateFormat('yyyy-MM-dd').format(doc.createdDate);
                    return DocumentItem(
                      type: "PDF",
                      title: doc.documentName,
                      // date: doc.createdDate.split('T')[0],
                      date: DateFormat('yyyy-MM-dd').format(doc.createdDate),
                      size: doc.size ?? 'Không rõ',
                      iconColor: Colors.red[100]!,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getTypeFromName(String name) {
    final ext = name.split('.').last.toUpperCase();
    return ext;
  }

  Widget _buildBreadcrumbs() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 8),
      alignment: Alignment.center,
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 16, color: Colors.grey),
          children: [
            TextSpan(text: 'Trang Chủ'),
            TextSpan(text: ' - '),
            TextSpan(text: 'Tìm Kiếm Văn Bản'),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => NavigationMenu()),
          );
        },
      ),
      title: Text(
        'Văn bản tìm kiếm',
        style: TextStyle(
          color: Colors.black,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }
}

class TabItem extends StatelessWidget {
  final String title;

  TabItem({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey,
          fontWeight:  FontWeight.normal,
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
        Get.to(() => DocumentDetailPage(workFlowId: '', documentId: '', sizes: [], size: size, date: date, taskId: '', taskType: '', isUsb: null!,
        ));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Color(0xFFECECEC),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              padding: EdgeInsets.all(8),
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
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    '$date | $size',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Icon(Icons.more_vert, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
