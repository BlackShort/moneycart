import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:moneycart/app/auth/models/user_model.dart';
import 'package:moneycart/app/profile/controllers/profile_controller.dart';
import 'package:moneycart/config/constants/app_constants.dart';
import 'package:moneycart/config/theme/app_pallete.dart';
import 'package:moneycart/core/utils/user_preferences.dart';

class RewardsPage extends StatefulWidget {
  const RewardsPage({super.key});

  @override
  State<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  final controller = Get.put(ProfileController());
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
    return Scaffold(
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 32.0,
                        left: 8.0,
                        right: 8.0,
                      ),
                      child: SvgPicture.asset(
                        'assets/svgs/refer.svg',
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: 200,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        AppConstants.referralSubTitle,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontFamily: 'Poppins',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        AppConstants.referralMessage,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _shareReferralLink,
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: AppPallete.boldprimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 20),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      child: const Text(
                        AppConstants.referrlButton,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
      ),
    );
  }
}
