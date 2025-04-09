import 'package:dms/navigation_menu.dart';
import 'package:dms/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../document_list/document_list.dart';

class DocumentTypeListPage extends StatefulWidget {
  @override
  State<DocumentTypeListPage> createState() => _DocumentTypeListPageState();
}
class _DocumentTypeListPageState extends State<DocumentTypeListPage> {
  int selectedTabIndex = 0;

  final List<String> tabs = [
    'Văn bản đến',
    'Văn bản đi',
    'Nội bộ toàn trường',
    'Nội bộ phòng ban',
  ];

  final List<List<String>> tabData = [
    ['Nghị Định', 'Thông Báo', 'Dự Án'],
    ['Nghị Quyết', 'Đề Án', 'Quy Định'],
    ['Họp mặt', 'Hoạt động Đoàn thể', 'Chương trình nội bộ'],
    ['Kế hoạch phòng ban', 'Báo cáo tháng', 'Biên bản họp'],
  ];

  @override
  Widget build(BuildContext context) {
    final currentDocumentTypes = tabData[selectedTabIndex];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.to(() => const NavigationMenu()),
        ),
        title: Text(
          'Văn bản',
          style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search_rounded, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.filter_alt_sharp, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(tabs.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTabIndex = index;
                      });
                    },
                    child: TabItem(
                      title: tabs[index],
                      isSelected: selectedTabIndex == index,
                    ),
                  );
                }),
              ),
            ),
          ),
          // Danh sách loại văn bản
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemCount: currentDocumentTypes.length,
                  itemBuilder: (context, index) {
                    return DocumentTypeItem(
                      title: currentDocumentTypes[index],
                      onTap: () {
                        // Điều hướng đến trang DocumentListPage khi nhấn
                        Get.to(() => DocumentListPage(
                        ));
                      },
                    );
                  }

              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget cho tab
class TabItem extends StatelessWidget {
  final String title;
  final bool isSelected;

  TabItem({required this.title, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue[50] : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.blue : Colors.grey,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

// Widget cho mỗi loại văn bản
// class DocumentTypeItem extends StatelessWidget {
//   final String title;
//
//   DocumentTypeItem({required this.title});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 2,
//             blurRadius: 5,
//             offset: Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Image(
//             image: AssetImage(TImages.folder),
//             width: 70,
//             height: 70,
//           ),
//           SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: Text(
//                   title,
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   textAlign: TextAlign.left,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//               Icon(Icons.more_vert, size: 20, color: Colors.black),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

class DocumentTypeItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  DocumentTypeItem({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // ← Thêm hành động khi bấm vào
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage(TImages.folder),
              width: 70,
              height: 70,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(Icons.more_vert, size: 20, color: Colors.black),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
