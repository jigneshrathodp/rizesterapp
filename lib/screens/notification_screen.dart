import 'package:flutter/material.dart';
import '../utils/responsive_config.dart';
import '../widgets/widgets.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationItem> _notifications = [
    NotificationItem(
      id: 1,
      title: 'New Order Received',
      message: 'John Doe placed a new order for iPhone 13 Pro',
      time: '2 minutes ago',
      type: 'order',
      isRead: false,
    ),
    NotificationItem(
      id: 2,
      title: 'Product Out of Stock',
      message: 'Samsung Galaxy S22 is now out of stock',
      time: '15 minutes ago',
      type: 'product',
      isRead: false,
    ),
    NotificationItem(
      id: 3,
      title: 'Advertisement Approved',
      message: 'Your advertisement for Summer Sale has been approved',
      time: '1 hour ago',
      type: 'advertise',
      isRead: true,
    ),
    NotificationItem(
      id: 4,
      title: 'New Customer Registration',
      message: 'Jane Smith has registered as a new customer',
      time: '2 hours ago',
      type: 'customer',
      isRead: true,
    ),
    NotificationItem(
      id: 5,
      title: 'Order Completed',
      message: 'Order #12345 has been marked as completed',
      time: '3 hours ago',
      type: 'order',
      isRead: true,
    ),
    NotificationItem(
      id: 6,
      title: 'Low Stock Alert',
      message: 'MacBook Pro M2 has only 5 items left in stock',
      time: '5 hours ago',
      type: 'product',
      isRead: true,
    ),
    NotificationItem(
      id: 7,
      title: 'Payment Received',
      message: 'Payment of \$1,299.00 received for order #12344',
      time: '1 day ago',
      type: 'payment',
      isRead: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Notifications',
        onBackPressed: () => Navigator.pop(context),
        showNotifications: false,
        showProfile: false,
        actions: [
          // Mark all as read button
          IconButton(
            onPressed: _markAllAsRead,
            icon: const Icon(
              Icons.done_all,
              color: Colors.black,
              size: 24,
            ),
            tooltip: 'Mark all as read',
          ),
        ],
      ),
      body: CustomScrollWidget(
        children: [
          Padding(
            padding: EdgeInsets.all(ResponsiveConfig.spacingMd(context)),
            child: CustomColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomSpacer(height: 20),
                
                // Notifications list
                _notifications.isEmpty
                    ? _buildEmptyState()
                    : CustomColumn(
                        children: _notifications.map((notification) {
                          return Dismissible(
                            key: Key(notification.id.toString()),
                            direction: DismissDirection.endToStart,
                            background: _buildSwipeBackground(),
                            onDismissed: (direction) {
                              _deleteNotification(notification.id);
                            },
                            child: NotificationCard(
                              notification: notification,
                              onTap: () => _markAsRead(notification.id),
                            ),
                          );
                        }).toList(),
                      ),
                
                CustomSpacer(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwipeBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(
        right: ResponsiveConfig.responsivePadding(context, 20),
      ),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.delete,
            color: Colors.white,
            size: ResponsiveConfig.responsiveFont(context, 28),
          ),
          SizedBox(height: ResponsiveConfig.spacing2xs(context)),
          Text(
            'Delete',
            style: AppTextStyles.getBody(context).copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return CustomCard(
      padding: EdgeInsets.all(ResponsiveConfig.spacingXl(context)),
      child: CustomColumn(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off,
            size: ResponsiveConfig.responsiveFont(context, 80),
            color: Colors.grey[400],
          ),
          CustomSpacer(height: ResponsiveConfig.spacingMd(context)),
          Text(
            'No Notifications',
            style: AppTextStyles.getHeading(context).copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
          CustomSpacer(height: ResponsiveConfig.spacingSm(context)),
          Text(
            'You\'re all caught up!\nNo new notifications at the moment.',
            textAlign: TextAlign.center,
            style: AppTextStyles.getBody(context).copyWith(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  void _deleteNotification(int id) {
    setState(() {
      _notifications.removeWhere((notification) => notification.id == id);
    });

    // Show snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Notification deleted'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.white,
          onPressed: () {
            // Undo delete (in real app, you'd restore from a backup)
            setState(() {
              _notifications.insert(0, NotificationItem(
                id: id,
                title: 'Restored Notification',
                message: 'This notification was restored',
                time: 'Just now',
                type: 'system',
                isRead: false,
              ));
            });
          },
        ),
      ),
    );
  }

  void _markAsRead(int id) {
    setState(() {
      final index = _notifications.indexWhere((notification) => notification.id == id);
      if (index != -1) {
        _notifications[index] = _notifications[index].copyWith(isRead: true);
      }
    });
  }

  void _markAllAsRead() {
    setState(() {
      _notifications = _notifications.map((notification) {
        return notification.copyWith(isRead: true);
      }).toList();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback onTap;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: ResponsiveConfig.spacingMd(context)),
        padding: EdgeInsets.all(ResponsiveConfig.spacingMd(context)),
        decoration: BoxDecoration(
          color: notification.isRead ? Colors.white : Colors.blue[50],
          border: Border.all(
            color: notification.isRead ? Colors.grey[200]! : Colors.blue[200]!,
            width: notification.isRead ? 1 : 2,
          ),
          borderRadius: BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 8)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notification icon
            Container(
              width: ResponsiveConfig.responsiveWidth(context, 48),
              height: ResponsiveConfig.responsiveWidth(context, 48),
              decoration: BoxDecoration(
                color: _getNotificationColor(notification.type),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getNotificationIcon(notification.type),
                color: Colors.white,
                size: ResponsiveConfig.responsiveFont(context, 24),
              ),
            ),

            CustomSpacer(width: ResponsiveConfig.spacingMd(context)),

            // Notification content
            Expanded(
              child: CustomColumn(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomRow(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: AppTextStyles.getSubheading(context).copyWith(
                            fontWeight: notification.isRead 
                                ? FontWeight.w500 
                                : FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!notification.isRead) ...[
                        CustomSpacer(width: ResponsiveConfig.spacingXs(context)),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                  CustomSpacer(height: ResponsiveConfig.spacing2xs(context)),
                  Text(
                    notification.message,
                    style: AppTextStyles.getBody(context).copyWith(
                      color: Colors.grey[600],
                      fontWeight: notification.isRead 
                          ? FontWeight.normal 
                          : FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  CustomSpacer(height: ResponsiveConfig.spacingXs(context)),
                  Text(
                    notification.time,
                    style: AppTextStyles.getSmall(context).copyWith(
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'order':
        return Colors.green;
      case 'product':
        return Colors.orange;
      case 'advertise':
        return Colors.purple;
      case 'customer':
        return Colors.blue;
      case 'payment':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'order':
        return Icons.shopping_cart;
      case 'product':
        return Icons.inventory_2;
      case 'advertise':
        return Icons.campaign;
      case 'customer':
        return Icons.person_add;
      case 'payment':
        return Icons.payment;
      default:
        return Icons.notifications;
    }
  }
}

class NotificationItem {
  final int id;
  final String title;
  final String message;
  final String time;
  final String type;
  final bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    required this.isRead,
  });

  NotificationItem copyWith({
    int? id,
    String? title,
    String? message,
    String? time,
    String? type,
    bool? isRead,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      time: time ?? this.time,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
    );
  }
}
