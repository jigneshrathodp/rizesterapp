import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/order_list_controller.dart';
import '../../widgets/widgets.dart';
import 'order_now_screen.dart';

class OrderListScreen extends StatelessWidget {
  const OrderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderListController());
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          ScreenTitle(
            title: 'Order List',
            action: ElevatedButton(
              onPressed: controller.navigateToOrderNow,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              child: const Text('Add Order'),
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
                      DataColumn(label: Text('Product Name', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Category', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('User Name', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Shipping Cost', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Total Price', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Action', style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    rows: controller.paginatedData.isEmpty
                        ? []
                        : controller.paginatedData.map((order) {
                            return DataRow(
                              cells: [
                                DataCell(Text(order.id.toString())),
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
                                      child: Image.asset(
                                        order.imageUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return const Icon(
                                            Icons.image,
                                            color: Colors.grey,
                                            size: 24,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Container(
                                    width: 150,
                                    child: Text(
                                      order.productName,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: controller.getCategoryColor(order.category),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      order.category,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(Text(order.userName)),
                                DataCell(Text(
                                  order.shippingCost,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: order.shippingCost == '₹0' ? Colors.green : Colors.black,
                                  ),
                                )),
                                DataCell(Text(
                                  order.totalPrice,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                )),
                                DataCell(Text(order.date)),
                                DataCell(
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                                    onPressed: () => controller.deleteOrder(order.id),
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
                    child: Text('Showing ${((controller.currentPage.value - 1) * int.parse(controller.selectedEntries.value)) + 1} to ${((controller.currentPage.value - 1) * int.parse(controller.selectedEntries.value)) + controller.paginatedData.length} of ${controller.orders.length} entries'),
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
