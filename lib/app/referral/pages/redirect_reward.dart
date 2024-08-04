import 'package:flutter/material.dart';
import 'package:moneycart/app/referral/pages/how_it_work_tab.dart';
import 'package:moneycart/app/referral/pages/rewards_tab.dart';
import 'package:moneycart/config/constants/app_constants.dart';

class RedirectReward extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (context) => const RedirectReward(),
    );
  }

  const RedirectReward({super.key});

  @override
  State<RedirectReward> createState() => _RedirectRewardState();
}

class _RedirectRewardState extends State<RedirectReward> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: AppBar(
            title: const Text(
              'Referral',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            automaticallyImplyLeading: Navigator.of(context).canPop(),
            backgroundColor: const Color(0xFF56c596),
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
            bottom: const TabBar(
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: Colors.green,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.white,
              tabs: _tabs,
            ),
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
