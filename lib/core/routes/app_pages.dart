import 'app_routes.dart';
import 'package:get/get.dart';
import '../../features/auth/controllers/auth_binding.dart';
import '../../features/community/views/community_view.dart';
import '../../features/community/views/community_profile_view.dart';
import '../../features/events/views/dashboard_view.dart';
import '../../features/profile/views/account_info_view.dart';
import '../../features/profile/views/account_settings_view.dart';
import '../../features/profile/views/delete_account_step1_view.dart';
import '../../features/profile/views/delete_account_step2_view.dart';
import '../../features/profile/views/edit_profile_view.dart';
import '../../features/profile/views/email_update_view.dart';
import '../../features/profile/views/password_update_view.dart';
import '../../features/profile/views/phone_update_view.dart';
import '../../features/profile/views/profile_view.dart';
import '../../locofy/login.dart';
import '../../locofy/onboarding1.dart';
import '../../locofy/signup_private_step1.dart';
import '../../locofy/signup_private_step2.dart';
import '../../locofy/signup_private_step3.dart';
import '../../locofy/signup_community_step1.dart';
import '../../locofy/signup_community_step2.dart';
import '../../locofy/signup_select.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(name: AppRoutes.onboarding, page: () => const Onboarding1()),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginLocofy(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => DashboardView(),
      binding: AuthBinding(),
    ),
    GetPage(name: AppRoutes.community, page: () => const CommunityView()),
    GetPage(
      name: AppRoutes.communityProfile,
      page: () => const CommunityProfileView(),
    ),
    GetPage(name: AppRoutes.register, page: () => const SignUpSelect()),
    GetPage(
      name: AppRoutes.registerPrivate1,
      page: () => const SignUpPrivateStep1(),
    ),
    GetPage(
      name: AppRoutes.registerPrivate2,
      page: () => const SignUpPrivateStep2(),
    ),
    GetPage(
      name: AppRoutes.registerPrivate3,
      page: () => const SignUpPrivateStep3(),
    ),
    GetPage(
      name: AppRoutes.registerCommunity1,
      page: () => const SignUpCommunityStep1(),
    ),
    GetPage(
      name: AppRoutes.registerCommunity2,
      page: () => const SignUpCommunityStep2(),
    ),
    GetPage(name: AppRoutes.profile, page: () => const ProfileView()),
    GetPage(name: AppRoutes.editProfile, page: () => const EditProfileView()),
    GetPage(name: AppRoutes.accountInfo, page: () => const AccountInfoView()),
    GetPage(name: AppRoutes.phoneUpdate, page: () => const PhoneUpdateView()),
    GetPage(name: AppRoutes.emailUpdate, page: () => const EmailUpdateView()),
    GetPage(
      name: AppRoutes.accountSettings,
      page: () => const AccountSettingsView(),
    ),
    GetPage(
      name: AppRoutes.passwordUpdate,
      page: () => const PasswordUpdateView(),
    ),
    GetPage(
      name: AppRoutes.deleteAccountStep1,
      page: () => const DeleteAccountStep1View(),
    ),
    GetPage(
      name: AppRoutes.deleteAccountStep2,
      page: () => const DeleteAccountStep2View(),
    ),
    // Add more routes here
  ];
}
