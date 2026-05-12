import 'package:get/get.dart';
import 'app_routes.dart';
import '../../features/auth/presentation/controllers/auth_binding.dart';
import '../../features/auth/presentation/pages/login_view.dart';
import '../../features/auth/presentation/pages/signup_select_view.dart';
import '../../features/auth/presentation/pages/signup_private_step1_view.dart';
import '../../features/auth/presentation/pages/signup_private_step2_view.dart';
import '../../features/auth/presentation/pages/signup_private_step3_view.dart';
import '../../features/auth/presentation/pages/signup_community_step1_view.dart';
import '../../features/auth/presentation/pages/signup_community_step2_view.dart';
import '../../features/community/presentation/pages/community_profile_view.dart';
import '../../features/community/presentation/pages/community_view.dart';
import '../../features/events/presentation/pages/dashboard_view.dart';
import '../../features/events/presentation/pages/sports_all_view.dart';
import '../../features/profile/presentation/pages/account_info_view.dart';
import '../../features/profile/presentation/pages/account_settings_view.dart';
import '../../features/profile/presentation/pages/delete_account_step1_view.dart';
import '../../features/profile/presentation/pages/delete_account_step2_view.dart';
import '../../features/profile/presentation/pages/edit_profile_view.dart';
import '../../features/profile/presentation/pages/email_update_view.dart';
import '../../features/profile/presentation/pages/password_update_view.dart';
import '../../features/profile/presentation/pages/phone_update_view.dart';
import '../../features/profile/presentation/pages/profile_view.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(name: AppRoutes.register, page: () => const SignUpSelectView()),
    GetPage(
      name: AppRoutes.registerPrivate1,
      page: () => const SignUpPrivateStep1View(),
    ),
    GetPage(
      name: AppRoutes.registerPrivate2,
      page: () => const SignUpPrivateStep2View(),
    ),
    GetPage(
      name: AppRoutes.registerPrivate3,
      page: () => const SignUpPrivateStep3View(),
    ),
    GetPage(
      name: AppRoutes.registerCommunity1,
      page: () => const SignUpCommunityStep1View(),
    ),
    GetPage(
      name: AppRoutes.registerCommunity2,
      page: () => const SignUpCommunityStep2View(),
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => DashboardView(),
      binding: AuthBinding(),
    ),
    GetPage(name: AppRoutes.sportsAll, page: () => const SportsAllView()),
    GetPage(name: AppRoutes.community, page: () => const CommunityView()),
    GetPage(
      name: AppRoutes.communityProfile,
      page: () => const CommunityProfileView(),
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
    // TODO: Add onboarding, signup, and other auth pages
  ];
}
