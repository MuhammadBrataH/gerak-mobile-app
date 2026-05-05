import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/routes/app_pages.dart';
import 'core/routes/app_routes.dart';

void main() {
  runApp(GerakApp());
}

class GerakApp extends StatelessWidget {
  const GerakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Gerak Mobile App',
      initialRoute: AppRoutes.login,
      getPages: AppPages.pages,
    );
  }
}