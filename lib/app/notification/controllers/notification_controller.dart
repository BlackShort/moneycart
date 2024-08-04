import 'package:get/get.dart';
import '../models/notification_model.dart';
import 'notification_service.dart';

class NotificationController extends GetxController {
  final NotificationService _notificationService = Get.find<NotificationService>();

  RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  RxBool isLoading = false.obs;
  RxBool hasError = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  void fetchNotifications() async {
    try {
      isLoading.value = true;
      await _notificationService.loadNotifications();
      isLoading.value = false;
    } catch (e) {
      hasError.value = true;
      isLoading.value = false;
    }
  }

  void addNotification(NotificationModel notification) {
    _notificationService.addNotification(notification);
  }

  void markAsRead(String id) {
    _notificationService.markAsRead(id);
  }

  void deleteNotification(String id) {
    _notificationService.deleteNotification(id);
  }

  void deleteOldNotifications() {
    _notificationService.deleteOldNotifications();
  }
}
