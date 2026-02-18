import 'package:flutter/material.dart';


class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  final List<Map<String, dynamic>> dashboardItems = const [
    {
      'title': 'Total Category',
      'value': '10',
      'icon': Icons.category, // Category icon for product categories
    },
    {
      'title': 'Total Products',
      'value': '25',
      'icon': Icons.shopping_bag, // Shopping bag icon for products
    },
    {
      'title': 'Total Orders',
      'value': '150',
      'icon': Icons.list_alt, // List icon for orders
    },
    {
      'title': 'Pending Orders',
      'value': '5',
      'icon': Icons.pending_actions, // Pending icon for pending orders
    },
    {
      'title': 'Completed Orders',
      'value': '145',
      'icon': Icons.check_circle, // Check icon for completed orders
    },
    {
      'title': 'Total Revenue',
      'value': '\$5,000',
      'icon': Icons.attach_money, // Money icon for revenue
    },
    {
      'title': 'Active Users',
      'value': '50',
      'icon': Icons.people, // People icon for users
    },
    {
      'title': 'Notifications',
      'value': '12',
      'icon': Icons.notifications, // Bell icon for notifications
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: dashboardItems.map((item) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.black,
                  width: 0.2,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Big Icon Container
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        item['icon'],
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Text Column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title'],
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['value'],
                            style: const TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
