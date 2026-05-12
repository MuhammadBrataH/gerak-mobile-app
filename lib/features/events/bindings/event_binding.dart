import 'package:get/get.dart';
import '../controllers/event_controller.dart';

class EventBinding extends Bindings {
  @override
  void dependencies() {
    // Pakai lazyPut agar lebih hemat RAM (Controller baru dibuat saat halaman dibuka)
    Get.lazyPut<EventController>(() => EventController());
  }
}