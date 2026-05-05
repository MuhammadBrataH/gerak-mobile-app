import 'app_routes.dart';
import 'package:get/get.dart';
import '../../features/auth/controllers/auth_binding.dart';
import '../../features/auth/views/login_view.dart';
import '../../features/events/views/dashboard_view.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.login,
      page: () => LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => DashboardView(),
      binding: AuthBinding(),

    ),
    // Add more routes here
  ];
}
