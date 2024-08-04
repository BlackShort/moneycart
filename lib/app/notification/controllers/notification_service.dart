import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/notification_model.dart';

class NotificationService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final notifications = <NotificationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  Future<void> addNotification(NotificationModel notification) async {
    notifications.add(notification);
    await _firestore.collection('notifications').doc(notification.id).set(notification.toMap());
  }

  Future<void> markAsRead(String id) async {
    final notification = notifications.firstWhere((notif) => notif.id == id);
    notification.isRead = true;
    await _firestore.collection('notifications').doc(id).update(notification.toMap());
  }

  Future<void> deleteNotification(String id) async {
    notifications.removeWhere((notif) => notif.id == id);
    await _firestore.collection('notifications').doc(id).delete();
  }

  Future<void> loadNotifications() async {
    final snapshot = await _firestore.collection('notifications').get();
    notifications.value = snapshot.docs
        .map((doc) => NotificationModel.fromMap(doc.data()))
        .toList();
  }

  void deleteOldNotifications() {
    final DateTime now = DateTime.now();
    notifications.removeWhere((notif) => notif.timestamp.isBefore(now.subtract(Duration(days: 7))));
    // Optional: remove old notifications from Firestore as well
    // await removeOldNotificationsFromFirestore();
  }
}
