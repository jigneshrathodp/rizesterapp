import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/product_list_controller.dart';
import '../../widgets/widgets.dart';


class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is initialized and registered
    final controller = Get.isRegistered<ProductListController>()
        ? Get.find<ProductListController>()
        : Get.put(ProductListController());
    
    return Column(
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
            child: Obx(
              () => controller.isLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
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
                              scrollDirection: Axis.vertical,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Obx(
                                  () => DataTable(
                                    columns: const [
                                      DataColumn(label: Text('#', style: TextStyle(fontWeight: FontWeight.bold))),
                                      DataColumn(label: Text('Image', style: TextStyle(fontWeight: FontWeight.bold))),
                                      DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                                      DataColumn(label: Text('Category', style: TextStyle(fontWeight: FontWeight.bold))),
                                      DataColumn(label: Text('SKU', style: TextStyle(fontWeight: FontWeight.bold))),
                                      DataColumn(label: Text('Quantity', style: TextStyle(fontWeight: FontWeight.bold))),
                                      DataColumn(label: Text('Weight (gm)', style: TextStyle(fontWeight: FontWeight.bold))),
                                      DataColumn(label: Text('Cost/gm', style: TextStyle(fontWeight: FontWeight.bold))),
                                      DataColumn(label: Text('Total Cost', style: TextStyle(fontWeight: FontWeight.bold))),
                                      DataColumn(label: Text('Sell Price', style: TextStyle(fontWeight: FontWeight.bold))),
                                      DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                                      DataColumn(label: Text('For Sale', style: TextStyle(fontWeight: FontWeight.bold))),
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
                                                    width: 60,
                                                    height: 60,
                                                    child: data['image'] != null && data['image'].toString().isNotEmpty
                                                        ? ClipRRect(
                                                            borderRadius: BorderRadius.circular(8),
                                                            child: Image.network(
                                                              data['image'],
                                                              width: 50,
                                                              height: 50,
                                                              fit: BoxFit.cover,
                                                              errorBuilder: (context, error, stackTrace) {
                                                                return Container(
                                                                  width: 50,
                                                                  height: 50,
                                                                  decoration: BoxDecoration(
                                                                    color: Colors.grey[200],
                                                                    borderRadius: BorderRadius.circular(8),
                                                                  ),
                                                                  child: const Icon(
                                                                    Icons.image,
                                                                    size: 24,
                                                                    color: Colors.grey,
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          )
                                                        : Container(
                                                            width: 50,
                                                            height: 50,
                                                            decoration: BoxDecoration(
                                                              color: Colors.grey[200],
                                                              borderRadius: BorderRadius.circular(8),
                                                            ),
                                                            child: const Icon(
                                                              Icons.image,
                                                              size: 24,
                                                              color: Colors.grey,
                                                            ),
                                                          ),
                                                  ),
                                                ),
                                                DataCell(
                                                  Container(
                                                    width: 150,
                                                    child: Text(
                                                      data['name'] ?? '',
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                                DataCell(Text(controller.getCategoryName(data['category']))),
                                                DataCell(Text(data['sku'] ?? '')),
                                                DataCell(Text(data['quantity'] ?? '')),
                                                DataCell(Text(data['weight_in_gram'] ?? '')),
                                                DataCell(Text(data['cost_per_gram'] ?? '')),
                                                DataCell(Text(data['total_cost'] ?? '')),
                                                DataCell(Text(
                                                  data['sell_price'] ?? '',
                                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                                )),
                                                DataCell(
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color: data['active'] == 'Active' ? Colors.green : Colors.grey,
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    child: Text(
                                                      data['active'] ?? '',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                DataCell(Text(data['for_sale'] ?? '')),
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
      );
  }
}
