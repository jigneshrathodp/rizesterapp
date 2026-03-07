import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/category_list_controller.dart';
import '../../widgets/widgets.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {

  final CategoryListController controller = Get.put(CategoryListController());

  @override
  Widget build(BuildContext context) {

    return Column(
        children: [

          /// TITLE
          ScreenTitle(
            title: 'Category List',
            action: Row(
              children: [

                Obx(() => controller.isLoading.value
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : IconButton(
                  onPressed: controller.fetchCategories,
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Refresh',
                ),
                ),

                const SizedBox(width: 8),

                ElevatedButton(
                  onPressed: controller.navigateToCreateCategory,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Add Category'),
                ),
              ],
            ),
          ),

          Expanded(
            child: Column(
              children: [

                /// SEARCH + ENTRIES
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
                              items: controller.entriesOptions.map((value) {
                                return DropdownMenuItem(
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
                        textInputAction: TextInputAction.search,
                        onTapOutside: (_) => FocusScope.of(context).unfocus(), // ✅ બહાર tap કરો તો keyboard બંધ
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

                /// TABLE
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Obx(

                            () => controller.isLoading.value &&
                            controller.categories.isEmpty
                            ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 16),
                                Text('Loading categories...'),
                              ],
                            ),
                          ),
                        )

                            : DataTable(

                          columns: const [

                            DataColumn(label: Text('#',style: TextStyle(fontWeight: FontWeight.bold))),

                            DataColumn(label: Text('Image',style: TextStyle(fontWeight: FontWeight.bold))),

                            DataColumn(label: Text('Category Name',style: TextStyle(fontWeight: FontWeight.bold))),

                            DataColumn(label: Text('SKU',style: TextStyle(fontWeight: FontWeight.bold))),

                            DataColumn(label: Text('Action',style: TextStyle(fontWeight: FontWeight.bold))),
                          ],

                          rows: controller.paginatedData.map((category) {

                            return DataRow(
                              cells: [

                                /// ID
                                DataCell(Text((category['id'] ?? 0).toString())),

                                /// IMAGE
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
                                      child: (category['imageUrl'] != null &&
                                          (category['imageUrl'] as String).isNotEmpty)

                                          ? Image.network(
                                        category['imageUrl'],
                                        fit: BoxFit.cover,
                                        errorBuilder: (context,error,stackTrace) {
                                          return const Icon(Icons.category,color: Colors.grey);
                                        },
                                      )

                                          : const Icon(Icons.category,color: Colors.grey),
                                    ),
                                  ),
                                ),

                                /// NAME
                                DataCell(
                                  SizedBox(
                                    width: 150,
                                    child: Text(
                                      category['name'] ?? 'Unknown',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),

                                /// SKU
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.blue[50],
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.blue),
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

                                /// ACTION
                                DataCell(
                                  Row(
                                    children: [

                                      IconButton(
                                        icon: const Icon(Icons.edit,color: Colors.blue,size: 20),
                                        onPressed: () =>
                                            controller.navigateToUpdateCategory(category),
                                      ),

                                      IconButton(
                                        icon: const Icon(Icons.delete,color: Colors.red,size: 20),
                                        onPressed: () =>
                                            controller.deleteCategory(category['id'] ?? 0),
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
              ],
            ),
          ),
          // ✅ PAGINATION FIXED BOTTOM - keyboard સાથે ઉપર નહીં આવે
          SafeArea(
            top: false,
            child: Obx(
                  () => Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Colors.grey),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        'Showing ${((controller.currentPage.value - 1) * int.parse(controller.selectedEntries.value)) + 1} to ${((controller.currentPage.value - 1) * int.parse(controller.selectedEntries.value)) + controller.paginatedData.length} of ${controller.totalEntries} entries',
                      ),
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: controller.currentPage.value > 1
                              ? controller.goToPreviousPage
                              : null,
                          child: const Text('Previous'),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: controller.currentPage.value < controller.totalPages.value
                              ? controller.goToNextPage
                              : null,
                          child: const Text('Next'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
  }
}