import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:moneycart/app/base/widgets/custom_drawer.dart';
import 'package:moneycart/app/referral/pages/how_it_work_tab.dart';
import 'package:moneycart/app/referral/pages/rewards_tab.dart';
import 'package:moneycart/config/constants/app_constants.dart';
import 'package:moneycart/config/routes/route_names.dart';
import 'package:moneycart/config/theme/app_pallete.dart';

class ReferralPage extends StatefulWidget {
  const ReferralPage({super.key});

  @override
  State<ReferralPage> createState() => _ReferralPageState();
}

class _ReferralPageState extends State<ReferralPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        drawer: const CustomDrawer(),
        appBar: AppBar(
          leading: Builder(
            builder: (context) => IconButton(
              icon: SvgPicture.asset(
                'assets/icons/menu_fill.svg',
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
          centerTitle: true,
          title: const Text(
            'Reward',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppPallete.secondary,
            ),
          ),
          actions: [
            IconButton(
              icon: SvgPicture.asset(
                'assets/icons/member_list.svg',
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  AppPallete.secondary,
                  BlendMode.srcIn,
                ),
              ),
              onPressed: () => Get.toNamed(AppRoute.referralList),
            ),
          ],
          bottom: const TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: AppPallete.boldprimary,
            labelColor: AppPallete.secondary,
            unselectedLabelColor: AppPallete.grey,
            tabs: _tabs,
          ),
        ),
        body: TabBarView(
          children: _tabs.map((Tab tab) {
            return _buildTabContent(tab);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTabContent(Tab tab) {
    if (tab.text == AppConstants.tab1) {
      return const RewardsPage();
    } else if (tab.text == AppConstants.tab2) {
      return const HowItWorksPage();
    } else {
      return Container();
    }
  }
}

const _tabs = [
  Tab(text: AppConstants.tab1),
  Tab(text: AppConstants.tab2),
];
