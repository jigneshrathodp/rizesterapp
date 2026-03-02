import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/product_list_controller.dart';
import '../../widgets/widgets.dart';
import 'create_product_screen.dart';
import 'update_product_screen.dart';
import '../Order/buy_now_screen.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductListController());
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          ScreenTitle(
            title: 'Product List',
            action: ElevatedButton(
              onPressed: controller.navigateToCreateProduct,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              child: const Text('Add Product'),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Text('Show '),
                          Obx(
                            () => DropdownButton<String>(
                              value: controller.selectedEntries.value,
                              items: controller.entriesOptions.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: controller.updateEntries,
                            ),
                          ),
                          const Text(' entries'),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: controller.searchController,
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                // Expandable table section
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Obx(
                        () => DataTable(
                          columns: const [
                            DataColumn(label: Text('#', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Category', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('SKU', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Price', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Qty', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Action', style: TextStyle(fontWeight: FontWeight.bold))),
                          ],
                          rows: controller.paginatedData.isEmpty
                              ? []
                              : controller.paginatedData.map((data) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text((data['id'] ?? '').toString())),
                                      DataCell(
                                        Container(
                                          width: 150,
                                          child: Text(
                                            data['name'] ?? '',
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      DataCell(Text(data['category'] ?? '')),
                                      DataCell(Text(data['sku'] ?? '')),
                                      DataCell(Text(
                                        data['price'] ?? '',
                                        style: const TextStyle(fontWeight: FontWeight.w500),
                                      )),
                                      DataCell(Text(data['quantity'] ?? '')),
                                      DataCell(
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: data['status'] == 'Active' ? Colors.green : Colors.grey,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            data['status'] ?? '',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.edit, color: Colors.black, size: 20),
                                              onPressed: () => controller.navigateToUpdateProduct(data),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                                              onPressed: () => controller.showDeleteDialog(data['name'], data['id']),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => controller.paginatedData.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Center(
                            child: Text(
                              'No data available in table',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        )
                      : Container(),
                ),
              ],
            ),
          ),
          // Fixed bottom pagination section
          Obx(
            () => Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text('Showing ${((controller.currentPage.value - 1) * int.parse(controller.selectedEntries.value)) + 1} to ${((controller.currentPage.value - 1) * int.parse(controller.selectedEntries.value)) + controller.paginatedData.length} of ${controller.productData.length} entries'),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: controller.currentPage.value > 1 ? controller.goToPreviousPage : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: controller.currentPage.value > 1 ? Colors.black : Colors.grey[300],
                          foregroundColor: controller.currentPage.value > 1 ? Colors.white : Colors.black,
                        ),
                        child: const Text('Previous'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: controller.currentPage.value < controller.totalPages.value ? controller.goToNextPage : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: controller.currentPage.value < controller.totalPages.value ? Colors.black : Colors.grey[300],
                          foregroundColor: controller.currentPage.value < controller.totalPages.value ? Colors.white : Colors.black,
                        ),
                        child: const Text('Next'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
