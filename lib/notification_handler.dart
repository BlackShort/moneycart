import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:moneycart/app/insurance/pages/insurance_page.dart';
import 'package:moneycart/app/loan/pages/loan_page.dart';
import 'package:moneycart/app/notification/controllers/notification_controller.dart';
import 'package:moneycart/app/notification/models/notification_model.dart';
import 'package:moneycart/app/notification/pages/notification_page.dart';
import 'package:moneycart/app/pf/pages/pf_page.dart';
import 'package:moneycart/app/tds/pages/tds_page.dart';

class NotificationHandler extends GetxService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final NotificationController _notificationController = Get.find<NotificationController>();

  void initialize() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleMessage(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleMessage(message, isClick: true);
    });

    _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        _handleMessage(message, isClick: true);
      }
    });
  }

  void _handleMessage(RemoteMessage message, {bool isClick = false}) {
    final notification = message.notification;
    if (notification != null) {
      final notificationModel = NotificationModel(
        id: message.messageId ?? '',
        title: notification.title ?? '',
        body: notification.body ?? '',
        timestamp: DateTime.now(),
      );
      _notificationController.addNotification(notificationModel);

      if (isClick) {
        handleNotificationClick(message.data);
      }
    }
  }

  void handleNotificationClick(Map<String, dynamic> data) {
    switch (data['type']) {
      case 'pf':
        Get.to(() => const PfPage(), arguments: data);
        break;
      case 'tds':
        Get.to(() => const TdsPage(), arguments: data);
        break;
      case 'loan':
        Get.to(() => const LoanPage(), arguments: data);
        break;
      case 'insurance':
        Get.to(() => const InsurancePage(), arguments: data);
        break;
      default:
        Get.to(() => NotificationPage());
    }
  }
}
