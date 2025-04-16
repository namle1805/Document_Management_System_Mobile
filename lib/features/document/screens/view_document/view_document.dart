import 'package:dms/features/document/screens/document_detail/document_detail.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../../data/services/document_service.dart';
import '../../../../utils/constants/colors.dart';
import '../../../authentication/controllers/user/user_manager.dart';
import '../../models/document_detail.dart';

// class ViewDocumentPage extends StatefulWidget {
//   const ViewDocumentPage({super.key});
//
//   @override
//   State<ViewDocumentPage> createState() => _ViewDocumentPageState();
// }

class ViewDocumentPage extends StatefulWidget {
  final String imageUrl;

  const ViewDocumentPage({super.key, required this.imageUrl, });

  @override
  State<ViewDocumentPage> createState() => _ViewDocumentPageState();
}


class _ViewDocumentPageState extends State<ViewDocumentPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      AppBar(
        title: Text('Quyết định 53/2015 QD-TTg chính sách nội trú học sinh, sinh viên học cao đẳng trung cấp', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white), textAlign: TextAlign.center),
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
          // onPressed: () {
          //   Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(builder: (context) => const DocumentDetailPage(workFlowId: '', documentId: '',)),
          //   );
          // },
          onPressed: () {
            Navigator.pop(context);
          },

        ),
      ),
      body:
      SfPdfViewer.network(
        widget.imageUrl,
        key: _pdfViewerKey,
        headers: {
          'Authorization': 'Bearer ${UserManager().token}'
        },
      )


      // SfPdfViewer.asset(
      //   'assets/pdfs/48Phe-duyet-dc-cuc-bo-QH-DNIA.pdf',
      //   key: _pdfViewerKey,
      // ),
    );
  }
}


