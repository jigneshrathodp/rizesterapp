import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rizesterapp/widgets/widgets.dart';
import 'package:rizesterapp/screens/Profile/profile_screen.dart';
import 'package:rizesterapp/screens/main_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  
  // GlobalKey for scaffold
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<NotificationItem> notifications = [

    NotificationItem(
        id: 1,
        title: "New Order",
        message: "John ordered iPhone 13 Pro",
        time: "2 min ago",
        type: "order",
        isRead: false),

    NotificationItem(
        id: 2,
        title: "Product Out Of Stock",
        message: "Samsung S22 stock finished",
        time: "10 min ago",
        type: "product",
        isRead: false),

    NotificationItem(
        id: 3,
        title: "Payment Received",
        message: "₹50,000 payment received",
        time: "1 hour ago",
        type: "payment",
        isRead: true),

    NotificationItem(
        id: 4,
        title: "New Customer",
        message: "Rahul registered account",
        time: "3 hours ago",
        type: "customer",
        isRead: true),

  ];

  @override
  Widget build(BuildContext context) {

    final controller = Get.isRegistered<MainScreenController>()
        ? Get.find<MainScreenController>()
        : null;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xfff5f6fa),
      appBar: CustomAppBar(
        logoAsset: 'assets/black.png',
        onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
        onNotificationPressed: () => Get.back(),
        onProfilePressed: () => Get.to(() => const ProfileScreen()),
      ),
      drawer: controller != null
          ? SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Obx(
                () => CustomDrawer(
                  selectedIndex: controller.selectedIndex.value,
                  onItemTapped: controller.onItemTapped,
                  logoAsset: 'assets/white.png',
                ),
              ),
            )
          : null,

      body: notifications.isEmpty
          ? emptyUI()
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {

          final item = notifications[index];

          return Dismissible(

            key: Key(item.id.toString()),

            direction: DismissDirection.endToStart,

            background: deleteBackground(),

            onDismissed: (direction) {

              setState(() {
                notifications.removeAt(index);
              });

              Get.snackbar(
                "Deleted",
                "Notification removed",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            },

            child: notificationCard(item),
          );
        },
      ),
    );
  }

  Widget notificationCard(NotificationItem item) {

    return GestureDetector(

      onTap: () {

        setState(() {
          item.isRead = true;
        });

      },

      child: Container(

        margin: const EdgeInsets.only(bottom: 15),

        padding: const EdgeInsets.all(15),

        decoration: BoxDecoration(

          color: item.isRead ? Colors.white : const Color(0xffeef4ff),

          borderRadius: BorderRadius.circular(14),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 10,
              offset: const Offset(0,4),
            )
          ],
        ),

        child: Row(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Container(
              height: 50,
              width: 50,

              decoration: BoxDecoration(
                color: getColor(item.type),
                borderRadius: BorderRadius.circular(12),
              ),

              child: Icon(
                getIcon(item.type),
                color: Colors.white,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    children: [

                      Expanded(
                        child: Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: item.isRead
                                ? FontWeight.w500
                                : FontWeight.bold,
                          ),
                        ),
                      ),

                      if (!item.isRead)
                        Container(
                          height: 8,
                          width: 8,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        )

                    ],
                  ),

                  const SizedBox(height: 5),

                  Text(
                    item.message,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    item.time,
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),

                ],
              ),
            )

          ],
        ),
      ),
    );
  }

  Widget deleteBackground() {

    return Container(

      alignment: Alignment.centerRight,

      padding: const EdgeInsets.only(right: 25),

      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(14),
      ),

      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.delete, color: Colors.white),
          SizedBox(height: 5),
          Text(
            "Delete",
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }

  Widget emptyUI() {

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Icon(
            Icons.notifications_off,
            size: 90,
            color: Colors.grey[400],
          ),

          const SizedBox(height: 15),

          const Text(
            "No Notifications",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            "You're all caught up!",
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),

        ],
      ),
    );
  }

  Color getColor(String type) {

    switch (type) {
      case "order":
        return Colors.green;

      case "product":
        return Colors.orange;

      case "payment":
        return Colors.teal;

      case "customer":
        return Colors.blue;

      default:
        return Colors.grey;
    }
  }

  IconData getIcon(String type) {

    switch (type) {
      case "order":
        return Icons.shopping_cart;

      case "product":
        return Icons.inventory;

      case "payment":
        return Icons.payment;

      case "customer":
        return Icons.person;

      default:
        return Icons.notifications;
    }
  }
}

class NotificationItem {

  int id;
  String title;
  String message;
  String time;
  String type;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    required this.isRead,
  });
}