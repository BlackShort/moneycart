import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:moneycart/core/errors/snackbar.dart';
import '../models/notification_model.dart';

class NotificationController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  RxBool isLoading = false.obs;
  RxBool hasError = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      final notification = await _firestore
          .collection('notifications')
          .doc(_auth.currentUser!.uid)
          .get();
      notifications.value = notification
          .data()!['notifications']
          .map<NotificationModel>((notif) => NotificationModel.fromMap(notif))
          .toList();
    } catch (e) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addNotification(NotificationModel notification) async {
    notifications.add(notification);
    await _firestore
        .collection('notifications')
        .doc(notification.id)
        .set(notification.toMap());
  }

  Future<void> markAsRead(String id) async {
    final notification = notifications.firstWhere((notif) => notif.id == id);
    notification.isRead = true;
    await _firestore
        .collection('notifications')
        .doc(id)
        .update(notification.toMap());
  }

  Future<void> deleteNotification(String id) async {
    try {
      // Fetch the document that holds the notifications array
      DocumentSnapshot doc = await _firestore
          .collection('notifications')
          .doc(_auth.currentUser!.uid)
          .get();

      // Cast the data to a Map and access the notifications array
      List notificationsList =
          List.from((doc.data() as Map<String, dynamic>)['notifications']);

      // Find the notification by its ID
      final notificationToDelete = notificationsList.firstWhere(
        (notif) => notif['id'] == id,
        orElse: () => null,
      );

      if (notificationToDelete != null) {
        // Remove the notification from the list
        notificationsList.remove(notificationToDelete);

        // Update the Firestore document with the modified notifications list
        await _firestore
            .collection('notifications')
            .doc(_auth.currentUser!.uid)
            .update({'notifications': notificationsList});
      }
    } catch (e) {
      showCustomSnackbar(
        title: 'Error',
        message: 'Failed to delete notification: $e',
      );
      hasError.value = true;
    }
  }

  void deleteOldNotifications() {
    final DateTime now = DateTime.now();
    notifications.removeWhere((notif) =>
        notif.timestamp.isBefore(now.subtract(const Duration(days: 7))));
  }
}
