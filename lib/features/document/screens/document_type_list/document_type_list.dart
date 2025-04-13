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
    'Đã lưu',
  ];

  final List<List<String>> tabData = [
    ['Nghị Định', 'Thông Báo', 'Dự Án'],
    ['Nghị Quyết', 'Đề Án', 'Quy Định'],
    ['Họp mặt', 'Hoạt động Đoàn thể', 'Chương trình nội bộ'],
    ['Kế hoạch phòng ban', 'Báo cáo tháng', 'Biên bản họp'],
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
        title: const Text(
          'Văn bản',
          style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          // IconButton(
          //   icon: Icon(Icons.search_rounded, color: Colors.black),
          //   onPressed: () {},
          // ),
          // IconButton(
          //   icon: Icon(Icons.filter_alt_sharp, color: Colors.black),
          //   onPressed: () {},
          // ),
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

class DocumentTypeItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const DocumentTypeItem({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: const Image(
                image: AssetImage(TImages.folder),
                width: 60,
                height: 60,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 10),
            // Row(
            //   children: [
            //     Expanded(
            //       child:
            //       Text(
            //         title,
            //         style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            //         textAlign: TextAlign.left,
            //         overflow: TextOverflow.ellipsis,
            //         maxLines: 1,
            //       ),
            //     ),
            //     const Icon(Icons.more_vert, size: 18, color: Colors.black),
            //   ],
            // ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                ),
                const Icon(Icons.more_vert, size: 18, color: Colors.black),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
