import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:moneycart/app/base/widgets/custom_app_bar.dart';
import 'package:moneycart/app/docs/controllers/doc_controller.dart';
import 'package:moneycart/app/docs/pages/doc_details.dart';
import 'package:moneycart/config/theme/app_pallete.dart';

class DocPage extends StatelessWidget {
  final DocController _docController = Get.put(DocController());

  DocPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Documents',
        actions: 'assets/icons/refresh.svg',
        callback: _docController.fetchDocuments,
      ),
      body: RefreshIndicator(
        onRefresh: _docController.fetchDocuments,
        child: Obx(() {
          if (_docController.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppPallete.primary,
                ),
              ),
            );
          }

          if (_docController.documents.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/svgs/no_doc.svg',
                    width: 200,
                    height: 200,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No documents available',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Check back later or upload a new document.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      _docController.fetchDocuments();
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 2,
                      backgroundColor: AppPallete.boldprimary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Refresh'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: _docController.documents.length,
            itemBuilder: (context, index) {
              final doc = _docController.documents[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: SvgPicture.asset(
                    'assets/icons/doc_fill.svg',
                    colorFilter: const ColorFilter.mode(
                      AppPallete.primary,
                      BlendMode.srcIn,
                    ),
                    width: 40,
                    height: 40,
                  ),
                  title: Text(
                    doc['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    'Uploaded on: ${doc['uploadDate']}\nStatus: ${doc['status']}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  trailing: IconButton(
                    icon: SvgPicture.asset('assets/icons/details.svg'),
                    onPressed: () {
                      // Navigate to document details page
                      Get.to(() => DocDetailsPage(doc: doc));
                    },
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
