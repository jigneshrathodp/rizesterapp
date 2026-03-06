import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/advertise_list_controller.dart';
import '../../widgets/widgets.dart';

class AdvertiseListScreen extends StatefulWidget {
  const AdvertiseListScreen({super.key});

  @override
  State<AdvertiseListScreen> createState() => _AdvertiseListScreenState();
}

class _AdvertiseListScreenState extends State<AdvertiseListScreen> {
  final AdvertiseListController controller = Get.put(AdvertiseListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          ScreenTitle(
            title: 'Advertise List',
            action: Row(
              children: [
                Obx(() => controller.isLoading.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : IconButton(
                        onPressed: controller.fetchAdvertises,
                        icon: const Icon(Icons.refresh),
                        tooltip: 'Refresh',
                      )),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: controller.navigateToCreateAd,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Add Advertise'),
                ),
              ],
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
                        onTapOutside: (_) => FocusScope.of(context).unfocus(),
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
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Obx(
                        () => controller.isLoading.value && controller.advertiseData.isEmpty
                            ? const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(32),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(),
                                      SizedBox(height: 16),
                                      Text('Loading advertisements...'),
                                    ],
                                  ),
                                ),
                              )
                            : DataTable(
                                columns: const [
                                  DataColumn(
                                      label: Text('#',
                                          style: TextStyle(fontWeight: FontWeight.bold))),
                                  DataColumn(
                                      label: Text('Title',
                                          style: TextStyle(fontWeight: FontWeight.bold))),
                                  DataColumn(
                                      label: Text('Platform',
                                          style: TextStyle(fontWeight: FontWeight.bold))),
                                  DataColumn(
                                      label: Text('Price',
                                          style: TextStyle(fontWeight: FontWeight.bold))),
                                  DataColumn(
                                      label: Text('Date',
                                          style: TextStyle(fontWeight: FontWeight.bold))),
                                  DataColumn(
                                      label: Text('Action',
                                          style: TextStyle(fontWeight: FontWeight.bold))),
                                ],
                                rows: controller.paginatedData.map((ad) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text((ad['id'] ?? 0).toString())),
                                      DataCell(
                                        SizedBox(
                                          width: 200,
                                          child: Text(
                                            ad['title'] ?? 'Unknown',
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.blue[50],
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(color: Colors.blue),
                                          ),
                                          child: Text(
                                            ad['platform'] ?? 'N/A',
                                            style: TextStyle(
                                              color: Colors.blue[700],
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(Text('\$${ad['price'] ?? '0'}')),
                                      DataCell(Text(ad['date'] ?? 'N/A')),
                                      DataCell(
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.edit,
                                                  color: Colors.blue, size: 20),
                                              onPressed: () =>
                                                  controller.navigateToUpdateAd(ad),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete,
                                                  color: Colors.red, size: 20),
                                              onPressed: () =>
                                                  controller.deleteAdvertise(ad['id']),
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
        ],
      ),
      bottomNavigationBar: SafeArea(
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
                    'Showing ${((controller.currentPage.value - 1) * int.parse(controller.selectedEntries.value)) + 1} to ${((controller.currentPage.value - 1) * int.parse(controller.selectedEntries.value)) + controller.paginatedData.length} of ${controller.advertiseData.length} entries',
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
    );
  }
}

