import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moneycart/app/auth/models/user_model.dart';
import 'package:moneycart/config/constants/app_constants.dart';
import 'package:moneycart/config/theme/app_pallete.dart';
import 'package:moneycart/core/utils/user_preferences.dart';

class ReferralWidget extends StatefulWidget {
  const ReferralWidget({super.key});

  @override
  State<ReferralWidget> createState() => _ReferralWidgetState();
}

class _ReferralWidgetState extends State<ReferralWidget> {
  UserModel? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      UserModel? userData = await UserPreferences.getUserModel();
      if (userData != null) {
        setState(() {
          user = userData;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load user data.'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading user data: $e'),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _shareReferralLink() async {
    if (user != null) {
      const String referralLink =
          'https://play.google.com/store/apps/details?id=com.trustingbrains.cartmoney';
      try {
        await FlutterShare.share(
          title: AppConstants.shareTitle,
          text:
              'I\'m inviting you to use MoneyCart, a simple and secure finance management app. Here\'s my code (${user!.phone}) - just enter it at the time of registration. \n',
          linkUrl: referralLink,
        );
      } catch (error) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sharing: $error'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User data not available.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppPallete.backgroundColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/svgs/on_refer.svg',
            width: MediaQuery.of(context).size.width * 0.6,
            height: 170,
          ),
          const SizedBox(height: 20),
          const Text(
            "Refer a Friend",
            style: TextStyle(
              fontSize: 22,
              color: AppPallete.secondary,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Invite your friends and earn rewards when they join and use our services.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.w400,
              fontFamily: 'Poppins',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: AppPallete.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              textStyle: const TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              _shareReferralLink();
            },
            child: const Text(
              "Invite Now",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
