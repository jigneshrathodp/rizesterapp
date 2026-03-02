import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/category_list_controller.dart';
import '../../widgets/widgets.dart';
import 'update_category_screen.dart';
import 'create_category_screen.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoryListController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          ScreenTitle(
            title: 'Category List',
            action: ElevatedButton(
              onPressed: controller.navigateToCreateCategory,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              child: const Text('Add Category'),
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
                            DataColumn(label: Text('Image', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Category Name', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('SKU', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Barcode', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Action', style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                        rows: controller.paginatedData.isEmpty
                            ? []
                            : controller.paginatedData.map((category) {
                                return DataRow(
                                  cells: [
                                    DataCell(Text((category['id'] ?? 0).toString())),
                                    DataCell(
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: Colors.grey[100],
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: category['imageUrl'] != null
                                              ? Image.asset(
                                                  category['imageUrl']!,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return const Icon(
                                                      Icons.category,
                                                      color: Colors.grey,
                                                      size: 24,
                                                    );
                                                  },
                                                )
                                              : const Icon(
                                                  Icons.category,
                                                  color: Colors.grey,
                                                  size: 24,
                                                ),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Container(
                                        width: 150,
                                        child: Text(
                                          category['name'] ?? 'Unknown',
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.blue[50],
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(color: Colors.blue[200]!),
                                        ),
                                        child: Text(
                                          category['sku'] ?? 'N/A',
                                          style: TextStyle(
                                            color: Colors.blue[700],
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(Text(category['barcode'] ?? 'N/A')),
                                    DataCell(Text(category['date'] ?? 'N/A')),
                                    DataCell(
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                                            onPressed: () => controller.navigateToUpdateCategory(category),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                                            onPressed: () => controller.deleteCategory(category['id'] ?? 0),
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
                if (controller.paginatedData.isEmpty)
                  const Padding(
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
                    child: Text('Showing ${((controller.currentPage.value - 1) * int.parse(controller.selectedEntries.value)) + 1} to ${((controller.currentPage.value - 1) * int.parse(controller.selectedEntries.value)) + controller.paginatedData.length} of ${controller.categories.length} entries'),
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

