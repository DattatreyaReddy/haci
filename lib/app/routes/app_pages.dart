import 'package:get/get.dart';

import '../modules/ground/bindings/ground_binding.dart';
import '../modules/ground/views/ground_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.home;

  static final routes = [
    GetPage(
      name: _Paths.home,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: "/:userName" + _Paths.ground + "/:groundId",
      page: () => GroundView(),
      binding: GroundBinding(),
    ),
  ];
}
