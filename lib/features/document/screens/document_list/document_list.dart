import 'package:dms/features/document/screens/home/home.dart';
import 'package:dms/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/image_strings.dart';

class DocumentListPage extends StatelessWidget {
  final List<Map<String, dynamic>> documents = [
    {
      'type': 'DOCX',
      'title': 'Quy định chi tiết một số điều...',
      'date': '29 Oct 2024',
      'size': '329.4 MB',
      'iconColor': Colors.blue[100],
    },
    {
      'type': 'DOCX',
      'title': 'Quy định chi tiết một số điều...',
      'date': '29 Oct 2024',
      'size': '329.4 MB',
      'iconColor': Colors.blue[100],
    },
    {
      'type': 'PDF',
      'title': 'Nghị định liên quan đến điều...',
      'date': '28 Oct 2024',
      'size': '122 MB',
      'iconColor': Colors.red[100],
    },
    {
      'type': 'PDF',
      'title': 'Quy định phụ cấp đặc thù...',
      'date': '28 Oct 2024',
      'size': '122 MB',
      'iconColor': Colors.red[100],
    },
    {
      'type': 'XLS',
      'title': 'Quy định xử phạt vi phạm hành...',
      'date': '25 Oct 2024',
      'size': '2.4 MB',
      'iconColor': Colors.green[100],
    },
    {
      'type': 'SVG',
      'title': 'Quy định về kiểm định chất...',
      'date': '24 Oct 2024',
      'size': '11 MB',
      'iconColor': Colors.yellow[100],
    },
    {
      'type': 'DOCX',
      'title': 'Nghị định hướng dẫn Luật giao...',
      'date': '19 Oct 2024',
      'size': '84.9 MB',
      'iconColor': Colors.blue[100],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
          'Văn Bản Nghị Định',
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {
              // TODO: Thêm chức năng tìm kiếm ở đây
            },
          ),
        ],
      ),

      body: Column(
        children: [
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
                    text: 'Văn Bản Nghị Định',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final doc = documents[index];
                return DocumentItem(
                  type: doc['type'],
                  title: doc['title'],
                  date: doc['date'],
                  size: doc['size'],
                  iconColor: doc['iconColor'],
                );
              },
            ),
          ),
        ],
      ),
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

  DocumentItem({
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
        return TImages.defaultFile; // file mặc định nếu không khớp
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Color(0xFFECECEC),
          width: 1
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
            child:
             Image.asset(
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
    );
  }
}
