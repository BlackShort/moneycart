import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneycart/app/docs/controllers/doc_controller.dart';

class DocDetailsPage extends StatelessWidget {
  final Map<String, dynamic> doc;

  const DocDetailsPage({required this.doc, super.key});

  Widget _buildDetailsTable(List<dynamic>? selectedDetails) {
    if (selectedDetails == null) return Container();

    return LayoutBuilder(
      builder: (context, constraints) {
        double tableWidth = constraints.maxWidth;
        double minColumnWidth = 100.0;
        int columnCount = 4;
        double columnWidth = (tableWidth / columnCount).clamp(minColumnWidth, double.infinity);

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const ClampingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: tableWidth),
            child: DataTable(
              columnSpacing: columnWidth - minColumnWidth,
              horizontalMargin: 10.0,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              columns: const [
                DataColumn(
                  label: Flexible(
                    child: Center(
                      child: Text('S.N', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                DataColumn(
                  label: Flexible(
                    child: Center(
                      child: Text('Company', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                DataColumn(
                  label: Flexible(
                    child: Center(
                      child: Text('Income', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                DataColumn(
                  label: Flexible(
                    child: Center(
                      child: Text('TDS', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
              rows: List<DataRow>.generate(
                selectedDetails.length,
                (index) {
                  var detail = selectedDetails[index];
                  return DataRow(
                    cells: [
                      DataCell(
                        Center(child: Text((index + 1).toString())),
                      ),
                      DataCell(
                        Center(child: Text(detail['company'].toString())),
                      ),
                      DataCell(
                        Center(child: Text(detail['income'].toString())),
                      ),
                      DataCell(
                        Center(child: Text(detail['tds'].toString())),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final DocController _docController = Get.find<DocController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Document Details'),
      ),
      body: Obx(() {
        if (!_docController.showDetailsTable.value) {
          return Center(child: Text('No details to show.'));
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildDetailsTable(_docController.selectedDetails),
            ),
            const SizedBox(height: 5),
            ElevatedButton(
              onPressed: () {
                _docController.hideDetails();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 10.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'Hide Details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        );
      }),
    );
  }
}
