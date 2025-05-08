import 'package:dms/data/services/document_service.dart';
import 'package:dms/features/document/screens/document_detail/document_detail.dart';
import 'package:dms/features/document/screens/document_type_list_by_workflow/document_detail_by_workflow.dart';
import 'package:dms/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../models/document_list.dart';
import '../search_document/search_document.dart';


class DocumentsListByWorkflowPage extends StatefulWidget {
  final String documentTypeId;
  final String workFlowId;
  final String typeName;

  const DocumentsListByWorkflowPage({
    required this.documentTypeId, required this.workFlowId, required this.typeName,
  });

  @override
  _DocumentsListByWorkPageState createState() => _DocumentsListByWorkPageState();
}

class _DocumentsListByWorkPageState extends State<DocumentsListByWorkflowPage> {
  late Future<List<DocumentModel>> futureDocuments;

  @override
  void initState() {
    super.initState();
    futureDocuments = DocumentService().fetchDocumentsHome(widget.documentTypeId);
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _searchController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),

        title: Text(
          "Văn Bản ${widget.typeName}",
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          // IconButton(
          //   icon: Icon(Icons.search, color: Colors.black),
          //   onPressed: () {
          //     // TODO: Thêm chức năng tìm kiếm ở đây
          //   },
          // ),
        ],
      ),
      body: Column(
        children: [
          // ... thanh breadcrumbs + search giữ nguyên

          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 8),
            alignment: Alignment.center,
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 16, color: Colors.grey),
                children: [
                  TextSpan(text: 'Trang Chủ'),
                  TextSpan(text: ' - '),
                  TextSpan(text: 'Loại Văn Bản'),
                  TextSpan(text: ' - '),
                  TextSpan(
                    text: 'Danh sách văn bản',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            // width: 300,
            width: MediaQuery.of(context).size.width * 0.8,
            child: TextField(
              controller: _searchController,
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchDocumentPage(searchQuery: value.trim()),
                    ),
                  );
                }
              },
              decoration: InputDecoration(
                hintText: 'Tìm kiếm văn bản',
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.search, color: Colors.black),
                suffixIcon: Icon(Iconsax.filter_search, color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<DocumentModel>>(
              future: futureDocuments,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Lỗi: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text("Không có văn bản nào"));
                }

                final documents = snapshot.data!;
                return ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final doc = documents[index];
                    return DocumentItem(
                      type: "PDF", // hoặc bạn có thể viết logic để đoán loại file từ tên
                      title: doc.documentName ?? '',
                      date: _formatDate(doc.createdDate) ?? '',
                      size: doc.size ?? "Chưa rõ",
                      iconColor: Colors.red[100]!, workFlowId: doc.workFlowId, documentId: doc.id,
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

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')} "
        "${_monthName(date.month)} "
        "${date.year}";
  }

  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
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
  final String? type;
  final String? title;
  final String? date;
  final String? size;
  final String? workFlowId;
  final String? documentId;
  final Color iconColor;

  const DocumentItem({
    super.key,
     this.type,
     this.title,
     this.date,
     this.size,
    required this.iconColor,  this.workFlowId,  this.documentId,
  });

  String _getIconAsset() {
    switch (type?.toUpperCase()) {
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
        Get.to(() =>
            DocumentDetailByWorkflowPage(workFlowId: workFlowId!, documentId: documentId!, sizes: [], size: size!, date: date!, taskId: '',
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
                    title!,
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