import 'package:flutter/material.dart';
import 'package:moneycart/app/base/models/bottom_bar_model.dart';
import 'package:moneycart/app/base/widgets/custom_bottom_bar.dart';
import 'package:moneycart/app/docs/pages/doc_page.dart';
import 'package:moneycart/app/home/pages/home_page.dart';
import 'package:moneycart/app/profile/pages/profile.dart';
import 'package:moneycart/app/referral/pages/referral_page.dart';
// import 'package:moneycart/app/status/pages/status_page.dart';

class BasePage extends StatelessWidget {
  const BasePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBottomBar(
      items: [
        BottomBarModel(
          page: HomePage(),
          icon: 'assets/icons/home_out.svg',
          activeIcon: 'assets/icons/home_fill.svg',
          title: 'Home',
        ),
        BottomBarModel(
          page: DocPage(),
          icon: 'assets/icons/doc_out.svg',
          activeIcon: 'assets/icons/doc_fill.svg',
          title: 'Docs',
        ),
        // BottomBarModel(
        //   page: const StatusPage(),
        //   icon: 'assets/icons/duration_out.svg',
        //   activeIcon: 'assets/icons/duration_fill.svg',
        //   title: 'Status',
        // ),
        BottomBarModel(
          page: const ReferralPage(),
          icon: 'assets/icons/referral_out.svg',
          activeIcon: 'assets/icons/referral_fill.svg',
          title: 'Reward',
        ),
        BottomBarModel(
          page: const ProfilePage(),
          icon: 'assets/icons/user_out.svg',
          activeIcon: 'assets/icons/user_fill.svg',
          title: 'Profile',
        ),
      ],
    );
  }
}
