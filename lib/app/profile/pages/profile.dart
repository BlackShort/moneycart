import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:moneycart/app/auth/controllers/auth_controller.dart';
import 'package:moneycart/app/auth/models/user_model.dart';
import 'package:moneycart/app/base/widgets/custom_app_bar.dart';
import 'package:moneycart/app/base/widgets/custom_drawer.dart';
import 'package:moneycart/app/common/widgets/loader.dart';
import 'package:moneycart/app/common/widgets/loading_button.dart';
import 'package:moneycart/app/profile/controllers/profile_controller.dart';
import 'package:moneycart/config/routes/route_names.dart';
import 'package:moneycart/config/theme/app_pallete.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileController _profileController = Get.put(ProfileController());
  final AuthController _authController = Get.put(AuthController());
  Future<UserModel?>? _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = _profileController.getUserProfile();
  }

  Future<void> _refreshUserProfile() async {
    setState(() {
      _userFuture = _profileController.getUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: const CustomDrawer(),
        appBar: const CustomAppBar(
          title: 'Profile',
          actions: 'assets/icons/user_edit.svg',
          routeName: AppRoute.profileUpdate,
        ),
        body: RefreshIndicator(
          color: AppPallete.boldprimary,
          onRefresh: _refreshUserProfile,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            physics: const AlwaysScrollableScrollPhysics(),
            child: FutureBuilder<UserModel?>(
              future: _userFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Loader();
                } else if (snapshot.hasError || snapshot.data == null) {
                  return _buildErrorUI();
                } else {
                  return _buildProfileUI(snapshot.data!);
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: CircleAvatar(
            radius: 55,
            backgroundColor: Colors.grey[300],
            child: Icon(
              Icons.person,
              size: 55,
              color: Colors.grey[600],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Container(
            height: 20,
            width: MediaQuery.of(context).size.width * 0.7,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: () {
            Get.toNamed(AppRoute.setProfile);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppPallete.boldprimary,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Profile Setup'),
        ),
      ],
    );
  }

  Widget _buildProfileUI(UserModel userData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: CircleAvatar(
            radius: 55,
            backgroundColor: userData.profile.isNotEmpty
                ? Colors.transparent
                : Colors.grey[300],
            child: userData.profile.isNotEmpty
                ? ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: userData.profile,
                      width: 110,
                      height: 110,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(
                        Icons.person,
                        size: 55,
                        color: Colors.grey[600],
                      ),
                    ),
                  )
                : Icon(
                    Icons.person,
                    size: 55,
                    color: Colors.grey[600],
                  ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            userData.name,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 22,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        const SizedBox(height: 16),
        ProfileField(
            icon: 'assets/icons/envelope_fill.svg',
            title: 'Email',
            value: userData.email),
        ProfileField(
            icon: 'assets/icons/phone_fill.svg',
            title: 'Phone',
            value: userData.phone),
        ProfileField(
            icon: 'assets/icons/user_fill.svg',
            title: 'Gender',
            value: userData.gender ?? 'Not specified'),
        ProfileField(
            icon: 'assets/icons/house_user.svg',
            title: 'Address',
            value: userData.address),
        const SizedBox(height: 32),
        Obx(
          () => SizedBox(
            width: double.infinity,
            child: LoadingButton(
              text: 'Log out',
              color: AppPallete.errorColor,
              isLoading: _authController.isLoading.value,
              onPressed: () {
                _authController.signOut();
              },
            ),
          ),
        ),
      ],
    );
  }
}

class ProfileField extends StatelessWidget {
  final String title;
  final String? value;
  final String icon;

  const ProfileField({
    required this.title,
    this.value,
    super.key,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                icon,
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  AppPallete.primary,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 16),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                  ),
                ),
              ]),
            ],
          ),
        ],
      ),
    );
  }
}
