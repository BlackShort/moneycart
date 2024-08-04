import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:moneycart/config/constants/app_constants.dart';
import 'package:moneycart/config/routes/route_names.dart';
import 'package:moneycart/config/theme/app_pallete.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final String? leading;
  final String? actions;
  final String? routeName;
  final VoidCallback? callback;

  const CustomAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.routeName,
    this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Builder(
        builder: (context) => IconButton(
          icon: SvgPicture.asset(
            leading ?? 'assets/icons/menu_fill.svg',
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(
              AppPallete.secondary,
              BlendMode.srcIn,
            ),
          ),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      title: Text(
        title ?? AppConstants.appName,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: title != null ? AppPallete.secondary : AppPallete.primary,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      actions: [
        IconButton(
          icon: SvgPicture.asset(
            actions ?? 'assets/icons/bell_out.svg',
            width: 22,
            height: 22,
            colorFilter: const ColorFilter.mode(
              AppPallete.secondary,
              BlendMode.srcIn,
            ),
          ),
          onPressed: () {
            if (callback != null) {
              callback!();
            } else if (routeName != null) {
              Get.toNamed(routeName!);
            } else {
              Get.toNamed(AppRoute.notification);
            }
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
