import 'dart:convert';
import 'package:http/http.dart' as http;
import '../App_model/Notifications_model/DelteNotificationModel.dart';
import '../App_model/Notifications_model/MarkallNotificationModel.dart';
import '../App_model/Notifications_model/MarkreadNotificationModel.dart';
import '../App_model/Notifications_model/ReadNotificationModel.dart';
import '../App_model/Notifications_model/UnreadNotificationModel.dart';
import '../api_url.dart';

class NotificationService {
  static Map<String, String> _getHeaders({required String token}) {
    return {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };
  }

  // ================= NOTIFICATION APIS =================

  // Get Unread Notifications
  static Future<UnreadNotificationModel> getUnreadNotifications(String token) async {
    try {
      final response = await http.get(
        Uri.parse(ApiUrls.unreadNotifications),
        headers: _getHeaders(token: token),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw Exception('Request timeout'),
      );
      if (response.statusCode == 200) {
        return UnreadNotificationModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to get unread notifications: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Unread notifications error: $e');
    }
  }

  // Get Read Notifications
  static Future<ReadNotificationModel> getReadNotifications(String token) async {
    try {
      final response = await http.get(
        Uri.parse(ApiUrls.readNotifications),
        headers: _getHeaders(token: token),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw Exception('Request timeout'),
      );
      if (response.statusCode == 200) {
        return ReadNotificationModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to get read notifications: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Read notifications error: $e');
    }
  }

  // Mark Notification as Read
  static Future<MarkreadNotificationModel> markNotificationRead(String token, int id) async {
    try {
      final response = await http.post(
        Uri.parse(ApiUrls.markNotificationRead.replaceAll('{id}', id.toString())),
        headers: _getHeaders(token: token),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw Exception('Request timeout'),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return MarkreadNotificationModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to mark notification as read: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Mark notification read error: $e');
    }
  }

  // Mark All Notifications as Read
  static Future<MarkallNotificationModel> markAllNotificationsRead(String token) async {
    try {
      final response = await http.post(
        Uri.parse(ApiUrls.markAllNotificationsRead),
        headers: _getHeaders(token: token),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw Exception('Request timeout'),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return MarkallNotificationModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to mark all notifications as read: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Mark all notifications read error: $e');
    }
  }

  // Delete Notification
  static Future<DelteNotificationModel> deleteNotification(String token, int id) async {
    try {
      final response = await http.delete(
        Uri.parse(ApiUrls.notificationDelete.replaceAll('{id}', id.toString())),
        headers: _getHeaders(token: token),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw Exception('Request timeout'),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return DelteNotificationModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to delete notification: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Delete notification error: $e');
    }
  }
}
