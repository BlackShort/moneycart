import 'package:flutter/material.dart';

class BottomBarModel {
  final Widget page;
  final String icon;
  final String activeIcon;
  final String title;
  final Color? color;

  BottomBarModel({
    required this.page,
    required this.icon,
    required this.activeIcon,
    required this.title,
    this.color,
  });
}
