import 'package:get/get.dart';
import 'package:moneycart/app/auth/pages/onboard_page.dart';
import 'package:moneycart/app/auth/pages/signup_page.dart';
import 'package:moneycart/app/base/pages/base_page.dart';
import 'package:moneycart/app/docs/pages/doc_page.dart';
import 'package:moneycart/app/home/pages/home_page.dart';
import 'package:moneycart/app/insurance/pages/insurance_page.dart';
import 'package:moneycart/app/loan/pages/loan_page.dart';
import 'package:moneycart/app/notification/pages/notification_page.dart';
import 'package:moneycart/app/pf/pages/pf_page.dart';
import 'package:moneycart/app/profile/pages/profile.dart';
import 'package:moneycart/app/profile/pages/profile_setup.dart';
import 'package:moneycart/app/profile/pages/profile_update.dart';
import 'package:moneycart/app/referral/pages/referral_list.dart';
import 'package:moneycart/app/referral/pages/referral_page.dart';
import 'package:moneycart/app/tds/pages/tds_page.dart';
import 'package:moneycart/config/routes/route_names.dart';

class Routes {
  static final List<GetPage> routes = [
    // ----------Onboarding Routes----------
    GetPage(name: AppRoute.onboard, page: () => const OnboardPage()),

    // ----------Authentication Routes----------
    GetPage(name: AppRoute.signup, page: () => const SignupPage()),

    // ----------App Routes----------
    GetPage(name: AppRoute.base, page: () => const BasePage()),
    GetPage(name: AppRoute.notification, page: () => NotificationPage()),

    // ----------Base Routes----------
    GetPage(name: AppRoute.home, page: () => const HomePage()),
    GetPage(name: AppRoute.docs, page: () => DocPage()),
    GetPage(name: AppRoute.referral, page: () => const ReferralPage()),
    GetPage(name: AppRoute.profile, page: () => const ProfilePage()),

    // ----------Home Routes----------
    GetPage(name: AppRoute.tds, page: () => const TdsPage()),
    GetPage(name: AppRoute.pf, page: () => const PfPage()),
    GetPage(name: AppRoute.loan, page: () => const LoanPage()),
    GetPage(name: AppRoute.insurance, page: () => const InsurancePage()),

    // ----------Home Routes----------
    GetPage(name: AppRoute.referralList, page: () => ReferralList()),

    // ----------Profile Routes----------
    GetPage(name: AppRoute.setProfile, page: () => const ProfileSetup()),
    GetPage(name: AppRoute.profileUpdate, page: () => const ProfileUpdate()),
    GetPage(name: AppRoute.account, page: () => const OnboardPage()),
    GetPage(name: AppRoute.settings, page: () => const OnboardPage()),
    GetPage(name: AppRoute.about, page: () => const OnboardPage()),
    GetPage(name: AppRoute.help, page: () => const OnboardPage()),
  ];
}
