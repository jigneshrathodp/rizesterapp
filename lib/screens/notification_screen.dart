import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rizesterapp/widgets/widgets.dart';
import 'package:rizesterapp/screens/Profile/profile_screen.dart';
import 'package:rizesterapp/screens/main_screen.dart';

import 'notification_screen.dart' as notification;

class NotificationScreen extends StatefulWidget {
  final bool showAppBar;
  const NotificationScreen({super.key, this.showAppBar = false});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  
  // GlobalKey for scaffold
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Empty notifications list - will be populated from API
  List<NotificationItem> notifications = [];

  @override
  Widget build(BuildContext context) {

    final controller = Get.isRegistered<MainScreenController>()
        ? Get.find<MainScreenController>()
        : null;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: widget.showAppBar ? PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: _CustomAppBarWrapper(
          logoAsset: 'assets/black.png',
          onNotificationPressed: () {
            Get.to(() => notification.NotificationScreen());
          },
          onProfilePressed: () {
            Get.to(() => const ProfileScreen(showAppBar: true));
          },
        ),
      ) : null,


      body: notifications.isEmpty
          ? _buildEmptyUI()
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {

          final item = notifications[index];

          return Dismissible(
            key: Key(item.id.toString()),
            direction: DismissDirection.endToStart,
            background: _buildDeleteBackground(),
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
            child: _buildNotificationCard(item),
          );
        },
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem item) {
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
                color: _getColor(item.type),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getIcon(item.type),
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

  Widget _buildDeleteBackground() {
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

  Widget _buildEmptyUI() {
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

  Color _getColor(String type) {
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

  IconData _getIcon(String type) {
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

class _CustomAppBarWrapper extends StatelessWidget implements PreferredSizeWidget {
  final String logoAsset;
  final VoidCallback onNotificationPressed;
  final VoidCallback onProfilePressed;

  const _CustomAppBarWrapper({
    required this.logoAsset,
    required this.onNotificationPressed,
    required this.onProfilePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => CustomAppBar(
        logoAsset: logoAsset,
        onMenuPressed: () => Scaffold.of(context).openDrawer(),
        onNotificationPressed: onNotificationPressed,
        onProfilePressed: onProfilePressed,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}