import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneycart/app/auth/models/user_model.dart';
import 'package:moneycart/config/routes/route_names.dart';
import 'package:moneycart/config/theme/app_pallete.dart';
import 'package:moneycart/core/utils/user_preferences.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String? _name;
  String? _phone;
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    UserModel? user = await UserPreferences.getUserModel();
    if (user != null) {
      setState(() {
        _name = user.name;
        _phone = user.phone;
        _profileImageUrl = user.profile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(),
          ..._buildDrawerItems(context),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Container(
      color: Colors.grey[300],
      padding: const EdgeInsets.only(top: 50, bottom: 25, left: 15, right: 15),
      child: Row(
        children: [
          _profileImageUrl != null
              ? ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: _profileImageUrl!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[200],
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                )
              : CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey[300],
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.grey[600],
                  ),
                ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _name?.capitalize ?? 'User',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: AppPallete.secondary,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _phone ?? 'Phone Number',
                  style: const TextStyle(
                    color: AppPallete.secondary,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDrawerItems(BuildContext context) {
    final drawerItems = [
      {
        'icon': Icons.person_rounded,
        'text': 'Edit Profile',
        'onTap': () => Get.toNamed(AppRoute.profileUpdate),
      },
      {
        'icon': Icons.library_books_rounded,
        'text': 'All Referrals',
        'onTap': () => Get.toNamed(AppRoute.referralList),
      },
      {
        'icon': Icons.groups_rounded,
        'text': 'Claim Referral',
        'onTap': () => Get.toNamed(AppRoute.claimReferral),
      },
      {
        'icon': Icons.info_rounded,
        'text': 'About Us',
        'onTap': () => Get.toNamed(AppRoute.about),
      },
      {
        'icon': Icons.security_rounded,
        'text': 'Privacy Policy',
        'onTap': () => Get.toNamed(AppRoute.about),
      },
      {
        'icon': Icons.settings_rounded,
        'text': 'Settings',
        'onTap': () => Get.toNamed(AppRoute.settings),
      },
      {
        'icon': Icons.question_mark_rounded,
        'text': 'Help and Support',
        'onTap': () => Get.toNamed(AppRoute.help),
      },
      {
        'icon': Icons.feedback_rounded,
        'text': 'Feedback',
        'onTap': () => Get.toNamed(AppRoute.feedback),
      },
    ];

    return drawerItems.map((item) {
      return _createDrawerItem(
        context: context,
        icon: item['icon'] as IconData,
        text: item['text'] as String,
        onTap: item['onTap'] as VoidCallback,
      );
    }).toList();
  }

  Widget _createDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppPallete.secondary,
        size: 24,
      ),
      title: Text(text),
      onTap: () {
        Navigator.of(context).pop();
        onTap();
      },
    );
  }
}
