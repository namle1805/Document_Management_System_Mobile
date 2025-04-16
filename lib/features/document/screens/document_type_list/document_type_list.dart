import 'dart:convert';

import 'package:dms/navigation_menu.dart';
import 'package:dms/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../authentication/controllers/user/user_manager.dart';
import '../../models/document_type_model.dart';
import '../document_list/document_list.dart';
import 'package:http/http.dart' as http;


class DocumentTypeListPage extends StatefulWidget {
  @override
  State<DocumentTypeListPage> createState() => _DocumentTypeListPageState();
}


class _DocumentTypeListPageState extends State<DocumentTypeListPage> {
  int selectedTabIndex = 0;
  List<Workflow> workflows = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWorkflows();
  }

  Future<void> fetchWorkflows() async {
    try {
      final response = await http.get(
        Uri.parse("http://nghetrenghetre.xyz:5290/api/Document/view-all-type-documents-by-workflow-mobile"),
        headers: {
          "Authorization": 'Bearer ${UserManager().token}'
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List content = data['content'];

        setState(() {
          workflows = content
              .map((e) => Workflow.fromJson(e))
              .where((e) => e.workFlowName != null)
              .toList();
          isLoading = false;
        });
      } else {
        print("Lỗi khi fetch API: ${response.statusCode}");
      }
    } catch (e) {
      print("Lỗi khi fetch API: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final currentWorkflow = workflows[selectedTabIndex];
    final currentDocumentTypes = currentWorkflow.documentTypes;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.to(() => const NavigationMenu()),
        ),
        title: const Text('Văn bản', style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Tab từ workflows
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(workflows.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTabIndex = index;
                      });
                    },
                    child: TabItem(
                      title: workflows[index].workFlowName,
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
                itemCount: currentDocumentTypes.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, index) {
                  final docType = currentDocumentTypes[index];
                  return DocumentTypeItem(
                    title: docType.documentTypeName,
                    onTap: () {
                      Get.to(() => DocumentListPage(
                        workFlowId: currentWorkflow.workFlowId!,
                        documentTypeId: docType.documentTypeId, typeName: docType.documentTypeName,
                      ));

                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}


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
