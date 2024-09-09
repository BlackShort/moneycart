import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneycart/app/home/controllers/home_controller.dart';
import 'package:moneycart/app/home/widgets/custom_image_loader.dart';
import 'package:moneycart/app/home/widgets/banner_carousel.dart';
import 'package:moneycart/app/home/widgets/referral_widget.dart';
import 'package:moneycart/app/home/widgets/service_card.dart';
import 'package:moneycart/app/insurance/pages/insurance_page.dart';
import 'package:moneycart/app/loan/pages/loan_page.dart';
import 'package:moneycart/app/pf/pages/pf_page.dart';
import 'package:moneycart/app/tds/pages/tds_page.dart';
import 'package:moneycart/config/constants/app_constants.dart';
import 'package:moneycart/config/theme/app_pallete.dart';
import 'package:moneycart/app/base/widgets/custom_app_bar.dart';
import 'package:moneycart/app/base/widgets/custom_drawer.dart';

class HomePage extends StatelessWidget {
  final HomeController _controller = Get.put(HomeController());

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 150,
              child: Obx(() {
                return _controller.bannerImages.isEmpty
                    ? const CustomImageLoader()
                    : BannerCarousel(
                        bannerImages: _controller.bannerImages,
                        pageController: _controller.pageController,
                        onPageChanged: (index) {
                          _controller.currentPage.value = index;
                        },
                      );
              }),
            ),
            const SizedBox(height: 10),
            Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildPageIndicator(),
              );
            }),
            const SizedBox(height: 20),
            const Text(
              AppConstants.mainHeading,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 24,
                color: AppPallete.secondary,
                fontFamily: 'Poppins',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: const [
                ServiceCard(
                  title: AppConstants.serviceOpt1,
                  imageUrl: AppConstants.serviceOpt1Img,
                  screen: TdsPage(),
                ),
                ServiceCard(
                  title: AppConstants.serviceOpt2,
                  imageUrl: AppConstants.serviceOpt2Img,
                  screen: PfPage(),
                ),
                ServiceCard(
                  title: AppConstants.serviceOpt3,
                  imageUrl: AppConstants.serviceOpt3Img,
                  screen: LoanPage(),
                ),
                ServiceCard(
                  title: AppConstants.serviceOpt4,
                  imageUrl: AppConstants.serviceOpt4Img,
                  screen: InsurancePage(),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const ReferralWidget(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < _controller.bannerImages.length; i++) {
      indicators.add(
        _indicator(i == _controller.currentPage.value),
      );
    }
    return indicators;
  }

  Widget _indicator(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: 8.0,
      decoration: BoxDecoration(
        color: isActive ? AppPallete.boldprimary : Colors.grey,
        borderRadius: BorderRadius.circular(4.0),
      ),
    );
  }
}
