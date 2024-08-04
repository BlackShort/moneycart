import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneycart/app/auth/controllers/auth_controller.dart';
import 'package:moneycart/app/notification/controllers/notification_controller.dart';
import 'package:moneycart/app/notification/controllers/notification_service.dart';
import 'package:moneycart/config/constants/app_constants.dart';
import 'package:moneycart/config/routes/route_names.dart';
import 'package:moneycart/config/routes/routes_page.dart';
import 'package:moneycart/config/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:moneycart/firebase_options.dart';
import 'package:moneycart/notification_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize dependencies
  Get.put(NotificationService());
  Get.put(AuthController());
  Get.put(NotificationController());
  Get.put(NotificationHandler());

  // Run the app
  runApp(const MoneyCartApp());
}

class MoneyCartApp extends StatelessWidget {
  const MoneyCartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      getPages: Routes.routes,
      initialRoute: AppRoute.onboard,
    );
  }
}
