import 'package:get/get.dart';

import '../controllers/ground_controller.dart';

class GroundBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GroundController>(
      () => GroundController(),
    );
  }
}
