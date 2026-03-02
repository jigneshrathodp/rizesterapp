import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/advertise_list_controller.dart';
import '../../widgets/widgets.dart';
import 'create_ad_screen.dart';
import 'update_ads_screen.dart';

class AdvertiseListScreen extends StatelessWidget {
  const AdvertiseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdvertiseListController());
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          ScreenTitle(
            title: 'Advertise List',
            action: ElevatedButton(
              onPressed: controller.navigateToCreateAd,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              child: const Text('Add Advertise'),
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
                      DataColumn(label: Text('Title', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Price', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Platform', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold))),
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
                                      data['title'] ?? '',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                DataCell(Text(
                                  data['price'] ?? '',
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                )),
                                DataCell(Text(data['platform'] ?? '')),
                                DataCell(Text(data['date'] ?? '')),
                                DataCell(
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Colors.black, size: 20),
                                        onPressed: () => controller.navigateToUpdateAd(data),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                                        onPressed: () {},
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
                    child: Text('Showing ${((controller.currentPage.value - 1) * int.parse(controller.selectedEntries.value)) + 1} to ${((controller.currentPage.value - 1) * int.parse(controller.selectedEntries.value)) + controller.paginatedData.length} of ${controller.advertiseData.length} entries'),
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
          )
        ]
      )
    );
  }
}

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Image.asset(
          'assets/images/rizester.png',
          height: 40,
          errorBuilder: (context, error, stackTrace) {
            return const Text(
              'Rizester',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: const Center(
        child: Text(
          'Notification Screen',
          style: TextStyle(
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

