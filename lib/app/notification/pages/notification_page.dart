import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:moneycart/app/common/widgets/loader.dart';
import 'package:moneycart/app/notification/controllers/notification_controller.dart';
import 'package:moneycart/config/theme/app_pallete.dart';
import 'package:moneycart/notification_handler.dart';

class NotificationPage extends StatelessWidget {
  final NotificationController _notificationController =
      Get.find<NotificationController>();
  final NotificationHandler _notificationHandler =
      Get.find<NotificationHandler>();

  NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back_ios_rounded,
            color: AppPallete.secondary,
            size: 19,
          ),
        ),
        titleSpacing: 0,
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: AppPallete.secondary,
            fontWeight: FontWeight.w500,
            fontSize: 19,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      body: RefreshIndicator(
          color: AppPallete.boldprimary,
          onRefresh: _notificationController.fetchNotifications,
          child: Obx(() {
            if (_notificationController.isLoading.value) {
              return const Loader();
            } else if (_notificationController.hasError.value) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/svgs/connection_error.svg',
                      width: MediaQuery.of(context).size.width * 0.6,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Failed to load notifications',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            } else if (_notificationController.notifications.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/svgs/no_message.svg',
                      width: MediaQuery.of(context).size.width * 0.6,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'No Notifications',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return ListView.builder(
                itemCount: _notificationController.notifications.length,
                itemBuilder: (context, index) {
                  final notification =
                      _notificationController.notifications[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Card(
                      elevation: 1.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 16.0),
                        leading: const CircleAvatar(
                          backgroundColor: Color.fromARGB(255, 77, 197, 117),
                          child: Icon(
                            Icons.notifications,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          notification.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(notification.body),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _notificationController
                                .deleteNotification(notification.id);
                          },
                        ),
                        onTap: () {
                          _notificationController.markAsRead(notification.id);
                          _notificationHandler
                              .handleNotificationClick(notification.toMap());
                        },
                      ),
                    ),
                  );
                },
              );
            }
          })),
    );
  }
}
