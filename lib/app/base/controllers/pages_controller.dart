import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PagesController extends GetxController {
  final selectedTab = 0.obs;
  final navigatorKeys = List<GlobalKey<NavigatorState>>.generate(
    4, // Adjust the number to match your tabs
    (index) => GlobalKey<NavigatorState>(),
  );
}
